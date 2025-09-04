# app/auth.py
from flask import Blueprint, render_template, redirect, url_for, request, flash
from flask_login import login_user, logout_user, login_required
from app.models import User, UserRole
from app import db

auth = Blueprint("auth", __name__)

@auth.route("/login", methods=["GET", "POST"])
def login():
    print("\n" + "="*50)
    print("🔍 DEBUG: Formulario recibido")
    print("Method:", request.method)
    print("Form data:", dict(request.form))
    print("Email:", request.form.get("email"))
    print("Password:", "no vacía" if request.form.get("password") else "vacía")
    print("="*50)

    if request.method == "POST":
        email = request.form.get("email")
        password = request.form.get("password")

        if not email or not password:
            flash("⚠️ Por favor completa todos los campos.", "warning")
            return render_template("login.html")

        user = User.query.filter_by(email=email).first()
        if user and user.check_password(password):
            login_user(user, remember=True)
            flash("✅ Sesión iniciada correctamente", "success")
            return redirect(url_for("routes.index"))
        else:
            flash("❌ Credenciales inválidas", "danger")

    return render_template("app/login.html")

# app/auth.py
@auth.route("/signup", methods=["GET", "POST"])
def signup():
    if request.method == "POST":
        print("\n🔍 Datos recibidos:", dict(request.form))  # Depuración

        username = request.form.get("username", "").strip()
        email = request.form.get("email", "").strip()
        password = request.form.get("password", "").strip()
        role = request.form.get("role", "patient")

        if not username or not email or not password:
            flash("Por favor completa todos los campos", "warning")
            return render_template("signup.html")

        existing_user = User.query.filter(
            (User.username == username) | (User.email == email)
        ).first()
        if existing_user:
            flash("El usuario o email ya existe", "warning")
            return render_template("signup.html")

        # ✅ Crear usuario con is_professional
        new_user = User(
            username=username,
            email=email,
            is_professional=(role == "professional"),
            is_admin=False
        )
        new_user.set_password(password)
        db.session.add(new_user)
        db.session.commit()

        flash("✅ Registro exitoso. Inicia sesión.", "success")
        return redirect(url_for("auth.login"))

    return render_template("signup.html")

@auth.route("/logout")
@login_required
def logout():
    logout_user()
    flash("👋 Sesión cerrada", "info")
    return redirect(url_for("routes.index"))

# app/auth.py
@auth.route("/register", methods=["GET", "POST"])
def register():
    roles_activos = UserRole.query.filter_by(is_active=True).all()
    
    if request.method == "POST":
        username = request.form.get("username").strip()
        email = request.form.get("email").strip()
        password = request.form.get("password")
        role_id = request.form.get("role_id")

        # Validaciones
        if not role_id or not UserRole.query.filter_by(id=role_id, is_active=True).first():
            flash("Por favor selecciona un rol válido", "error")
            return render_template("auth/register.html", roles_activos=roles_activos)

        if User.query.filter_by(email=email).first():
            flash("Este email ya está registrado", "error")
            return render_template("auth/register.html", roles_activos=roles_activos)

        if User.query.filter_by(username=username).first():
            flash("Este nombre de usuario ya existe", "error")
            return render_template("auth/register.html", roles_activos=roles_activos)

        # Crear usuario
        user = User(
            username=username,
            email=email,
            role_id=role_id,
            is_professional=(role_id != 1)  # Ajusta según ID de "Visitante"
        )
        user.set_password(password)
        db.session.add(user)
        db.session.commit()

        flash("✅ Registro exitoso. Inicia sesión.", "success")
        return redirect(url_for("auth.login"))

    return render_template("auth/register.html", roles_activos=roles_activos)