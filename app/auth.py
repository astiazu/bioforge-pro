# app/auth.py

from flask import Blueprint, render_template, request, flash, redirect, url_for, session
from flask_login import login_user, logout_user, login_required, current_user
from app.models import User, Assistant, Clinic, UserRole
from datetime import datetime
from app import db


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
            return render_template('auth/login.html')

        user = User.query.filter_by(email=email).first()
        if user and user.check_password(password):
            login_user(user, remember=True)
            flash('✅ Sesión iniciada correctamente', 'success')

            # Detectar roles usando consultas reales, no campos booleanos
            es_admin = user.is_admin is True
            es_profesional = Clinic.query.filter_by(doctor_id=user.id, is_active=True).first() is not None
            
            # Verificar si el usuario tiene un registro en la tabla Assistant
            asistente_encontrado = Assistant.query.filter_by(user_id=user.id, is_active=True).first()
            es_asistente = asistente_encontrado is not None

            print(f"\n🔍 DIAGNÓSTICO LOGIN - Usuario ID: {user.id}")
            print(f"   Email: {user.email}, Admin: {es_admin}, Profesional: {es_profesional}, Asistente: {'SÍ' if es_asistente else 'NO'}")
            
            if asistente_encontrado:
                print(f"   Assistant ID: {asistente_encontrado.id}, Doctor ID: {asistente_encontrado.doctor_id}, Type: {asistente_encontrado.type}")
            else:
                print("   ❌ No se encontró ningún registro de asistente activo para este usuario.")

            roles_activos = sum([int(es_admin), int(es_profesional), int(es_asistente)])
            print(f"   Roles activos: admin={es_admin}, profesional={es_profesional}, asistente={es_asistente} → total={roles_activos}")

            if roles_activos == 1:
                # Un solo rol → redirigir directamente
                if es_admin:
                    return redirect(url_for('routes.admin_dashboard'))
                elif es_profesional:
                    session['active_role'] = 'profesional'
                    return redirect(url_for('routes.mi_perfil'))
                elif es_asistente:
                    session['active_role'] = 'asistente'
                    session['active_assistant_id'] = asistente_encontrado.id
                    print(f"   ✅ Sesion establecida: active_role='asistente', active_assistant_id={asistente_encontrado.id}")
                    return redirect(url_for('routes.mi_trabajo'))
            else:
                # Múltiples roles → usar selector (¡incluso si es admin!)
                return redirect(url_for('routes.seleccionar_perfil'))
        else:
            flash('❌ Credenciales inválidas', 'danger')

    return render_template('auth/login.html')

@auth.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        username = request.form.get('username', '').strip()
        email = request.form.get('email', '').strip()
        password = request.form.get('password', '').strip()
        role = request.form.get('role', 'patient')

        if not username or not email or not password:
            flash('Por favor completa todos los campos', 'warning')
            return render_template('signup.html')

        existing_user = User.query.filter(
            (User.username == username) | (User.email == email)
        ).first()
        if existing_user:
            flash('El usuario o email ya existe', 'warning')
            return render_template('signup.html')

        new_user = User(
            username=username,
            email=email,
            is_professional=(role == 'professional'),
            is_admin=False
        )
        new_user.set_password(password)
        from app import db
        db.session.add(new_user)
        db.session.commit()

        flash('✅ Registro exitoso. Inicia sesión.', 'success')
        return redirect(url_for('auth.login'))

    return render_template('signup.html')

@auth.route('/register', methods=['GET', 'POST'])
def register():
    roles_activos = UserRole.query.filter_by(is_active=True).all()

    if request.method == 'POST':
        username = request.form.get('username').strip()
        email = request.form.get('email').strip()
        password = request.form.get('password')
        role_id = request.form.get('role_id')

        # Validación rol
        if not role_id or not UserRole.query.filter_by(id=role_id, is_active=True).first():
            flash('Por favor selecciona un rol válido', 'error')
            return render_template('auth/register.html', roles_activos=roles_activos)

        # Validación email y usuario
        if User.query.filter_by(email=email).first():
            flash('Este email ya está registrado', 'error')
            return render_template('auth/register.html', roles_activos=roles_activos)

        if User.query.filter_by(username=username).first():
            flash('Este nombre de usuario ya existe', 'error')
            return render_template('auth/register.html', roles_activos=roles_activos)

        # Creación usuario
        user = User(
            username=username,
            email=email,
            role_id=int(role_id),
            is_professional=(int(role_id) in PROFESSIONAL_ROLE_IDS)
        )
        user.set_password(password)
        db.session.add(user)
        db.session.commit()

        flash('✅ Registro exitoso. Inicia sesión.', 'success')
        return redirect(url_for('auth.login'))

    return render_template('auth/register.html', roles_activos=roles_activos)

@auth.route('/logout')
@login_required
def logout():
    logout_user()
    flash('👋 Sesión cerrada', 'info')
    return redirect(url_for('routes.index'))