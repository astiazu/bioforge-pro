# app/__init__.py
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from flask_mail import Mail
from flask_migrate import Migrate
import os

# Instancias globales
db = SQLAlchemy()
login_manager = LoginManager()
mail = Mail()
migrate = Migrate()

def create_app():
    app = Flask(
        __name__,
        instance_relative_config=True,
        template_folder="../templates",
        static_folder="../static"
    )

    # Crear carpeta instance si no existe
    try:
        os.makedirs(app.instance_path, exist_ok=True)
    except Exception as e:
        print(f"Error creando instance_path: {e}")

    # === Configuración Principal ===
    app.config["SECRET_KEY"] = os.environ.get("SECRET_KEY") or "clave-secreta-para-desarrollo-cambia-esto-en-produccion"
    
    if os.environ.get('DATABASE_URL'):
        database_url = os.environ.get('DATABASE_URL')
        if database_url.startswith("postgres://"):
            database_url = database_url.replace("postgres://", "postgresql://", 1)
        app.config["SQLALCHEMY_DATABASE_URI"] = database_url
    else:
        app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///portfolio.db"
    
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    # === Configuración de Email (Gmail) ===
    app.config["MAIL_SERVER"] = "smtp.gmail.com"
    app.config["MAIL_PORT"] = 587
    app.config["MAIL_USE_TLS"] = True
    app.config["MAIL_USERNAME"] = os.environ.get("MAIL_USERNAME") or "astiazu@gmail.com"
    app.config["MAIL_PASSWORD"] = os.environ.get("MAIL_PASSWORD") or "wepy imlw ltus fxoq"
    app.config["MAIL_DEFAULT_SENDER"] = ("Equipo Salud", app.config["MAIL_USERNAME"])

    # === Inicializar extensiones ===
    db.init_app(app)
    login_manager.init_app(app)
    mail.init_app(app)
    migrate.init_app(app, db)  # ✅ Aquí está mejor
    login_manager.login_view = "auth.login"

    # === Registrar blueprints y modelos ===
    with app.app_context():
        from app.models import User
        from app.routes import routes
        from app.auth import auth

        app.register_blueprint(routes)
        app.register_blueprint(auth, url_prefix="/auth")

        @login_manager.user_loader
        def load_user(user_id):
            return User.query.get(int(user_id))
    
    return app