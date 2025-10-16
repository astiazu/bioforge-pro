# app/auth.py
import secrets
from email_validator import validate_email, EmailNotValidError
from flask_mail import Mail, Message
from flask import Blueprint, render_template, request, flash, redirect, url_for, session
from flask_login import login_user, logout_user, login_required, current_user
from app.models import User, Assistant, Clinic, UserRole
from app.utils import is_valid_email, generate_verification_code, send_verification_email
from flask import session
from app.config.constants import PROFESSIONAL_ROLE_IDS
from datetime import datetime
from app import db

from sqlalchemy.orm.exc import NoResultFound

auth = Blueprint('auth', __name__)

PROFESSIONAL_ROLE_IDS = [1, 2, 6]  # Profesional, Tienda, PyME

@auth.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('routes.index'))
    
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')

        if not email or not password:
            flash('⚠️ Por favor completa todos los campos.', 'warning')
            return render_template('auth/login.html')  # Usa el archivo login.html

        user = User.query.filter_by(email=email).first()

        if user and user.check_password(password):
            login_user(user, remember=True)
            flash('✅ Sesión iniciada correctamente', 'success')

            # Detectar roles usando consultas reales, no campos booleanos
            es_admin = user.is_admin is True
            es_profesional = (
                Clinic.query.filter_by(doctor_id=user.id, is_active=True).first() is not None or
                (user.role_id in PROFESSIONAL_ROLE_IDS)
            )
            asistente_encontrado = Assistant.query.filter_by(user_id=user.id, is_active=True).first()
            es_asistente = asistente_encontrado is not None

            roles_activos = sum([int(es_admin), int(es_profesional), int(es_asistente)])
            if roles_activos == 1:
                if es_admin:
                    return redirect(url_for('routes.admin_dashboard'))
                elif es_profesional:
                    session['active_role'] = 'profesional'
                    return redirect(url_for('routes.mi_perfil'))
                elif es_asistente:
                    session['active_role'] = 'asistente'
                    session['active_assistant_id'] = asistente_encontrado.id
                    return redirect(url_for('routes.mi_trabajo'))
            else:
                return redirect(url_for('routes.seleccionar_perfil'))
        else:
            flash('❌ Credenciales inválidas. ¿No tienes cuenta? <a href="{}">Regístrate aquí</a>'.format(url_for('auth.register')), 'danger')

    return render_template('auth/login.html')  # Usa el archivo login.html

@auth.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        username = request.form.get('username', '').strip()
        email = request.form.get('email', '').strip()
        password = request.form.get('password', '').strip()
        role = request.form.get('role', 'patient')

        if not username or not email or not password:
            flash('Por favor completa todos los campos', 'warning')
            return render_template('auth/autenticacion.html')

        existing_user = User.query.filter(
            (User.username == username) | (User.email == email)
        ).first()
        if existing_user:
            flash('El usuario o email ya existe', 'warning')
            return render_template('auth/autenticacion.html')

        new_user = User(
            username=username,
            email=email,
            is_professional=(role == 'professional'),
            is_admin=False
        )
        new_user.set_password(password)
        db.session.add(new_user)
        db.session.commit()

        flash('✅ Registro exitoso. Inicia sesión.', 'success')
        return redirect(url_for('auth.login'))

    return render_template('auth/autenticacion.html')

@auth.route('/register', methods=['GET', 'POST'])
def register():
    # Obtener roles activos desde la base de datos
    roles_activos = UserRole.query.filter_by(is_active=True).all()

    if request.method == 'POST':
        username = request.form.get('username').strip()
        email = request.form.get('email').strip()
        password = request.form.get('password')
        role_id = request.form.get('role_id')
        accept_terms = request.form.get("accept_terms")  # Campo para términos y condiciones

        # Validar campos obligatorios
        if not username or not email or not password or not role_id:
            flash('⚠️ Por favor completa todos los campos.', 'warning')
            return render_template('auth/register.html', roles_activos=roles_activos)

        # Verificar términos y condiciones
        if not accept_terms:
            flash("❌ Debes aceptar los Términos y Condiciones y la Política de Privacidad.", "warning")
            return render_template('auth/register.html', roles_activos=roles_activos)

        # Validar el formato y dominio del correo
        if not is_valid_email(email):
            flash('❌ El correo electrónico no es válido.', 'error')
            return render_template('auth/register.html', roles_activos=roles_activos)

        # Verificar si el rol es válido
        role = UserRole.query.filter_by(id=role_id, is_active=True).first()
        if not role:
            flash('⚠️ El rol seleccionado no es válido.', 'error')
            return render_template('auth/register.html', roles_activos=roles_activos)

        # Verificar si el usuario o email ya existen
        if User.query.filter_by(email=email).first():
            flash('❌ Este email ya está registrado.', 'error')
            return render_template('auth/register.html', roles_activos=roles_activos)

        if User.query.filter_by(username=username).first():
            flash('❌ Este nombre de usuario ya existe.', 'error')
            return render_template('auth/register.html', roles_activos=roles_activos)

        # Generar un código de verificación y enviarlo por correo
        verification_code = generate_verification_code()
        session['verification_code'] = verification_code
        session['pending_email'] = email
        session['pending_user_data'] = {
            'username': username,
            'email': email,
            'password': password,
            'role_id': role_id
        }

        send_verification_email(email, verification_code)

        flash('✅ Se ha enviado un código de verificación a tu correo electrónico.', 'success')
        return redirect(url_for('auth.verify_email'))

    return render_template('auth/register.html', roles_activos=roles_activos)

@auth.route('/verify-email', methods=['GET', 'POST'])
def verify_email():
    if request.method == 'POST':
        user_code = request.form.get('code')
        stored_code = session.get('verification_code')

        if user_code == stored_code:
            # Crear el nuevo usuario
            user_data = session.get('pending_user_data')
            new_user = User(
                username=user_data['username'],
                email=user_data['email'],
                role_id=int(user_data['role_id']),
                is_professional=(int(user_data['role_id']) in PROFESSIONAL_ROLE_IDS)
            )
            new_user.set_password(user_data['password'])
            db.session.add(new_user)
            db.session.commit()

            # Limpiar la sesión
            session.pop('verification_code', None)
            session.pop('pending_email', None)
            session.pop('pending_user_data', None)

            flash('✅ Registro exitoso. Inicia sesión ahora.', 'success')
            return redirect(url_for('auth.login'))
        else:
            flash('❌ Código incorrecto. Inténtalo de nuevo.', 'error')

    return render_template('auth/verify_email.html')

@auth.route('/logout')
@login_required
def logout():
    logout_user()
    flash('👋 Sesión cerrada', 'info')
    return redirect(url_for('routes.index'))
