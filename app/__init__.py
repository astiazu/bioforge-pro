# app/__init__.py
import os
from flask import Flask, request
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from flask_mail import Mail
from flask_migrate import Migrate
from dotenv import load_dotenv
import cloudinary

# === Instancias globales ===
db = SQLAlchemy()
login_manager = LoginManager()
mail = Mail()
migrate = Migrate()

def create_app(strict_mode=False):
    """
    Crea e inicializa la aplicación Flask.
    Compatible con entornos locales y Render.
    """
    # Cargar variables locales si no estamos en producción
    if os.environ.get("FLASK_ENV") != "production":
        load_dotenv()

    app = Flask(
        __name__,
        instance_relative_config=True,
        template_folder="../templates",
        static_folder="../static"
    )

    # === Configuración general ===
    app.config["SECRET_KEY"] = os.environ.get("SECRET_KEY")

    # --- Configuración base de datos ---
    database_url = os.environ.get("DATABASE_URL")
    if database_url:
        if database_url.startswith("postgres://"):
            database_url = database_url.replace("postgres://", "postgresql://", 1)
        app.config["SQLALCHEMY_DATABASE_URI"] = database_url
    else:
        os.makedirs(app.instance_path, exist_ok=True)
        app.config["SQLALCHEMY_DATABASE_URI"] = f"sqlite:///{os.path.join(app.instance_path, 'portfolio.db')}"

    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    # --- Configuración de Email ---
    app.config["MAIL_SERVER"] = os.environ.get("MAIL_SERVER")
    app.config["MAIL_PORT"] = int(os.environ.get("MAIL_PORT", 587))
    app.config["MAIL_USE_TLS"] = os.environ.get("MAIL_USE_TLS") == "True"
    app.config["MAIL_USERNAME"] = os.environ.get("MAIL_USERNAME")
    app.config["MAIL_PASSWORD"] = os.environ.get("MAIL_PASSWORD")
    app.config["MAIL_DEFAULT_SENDER"] = os.environ.get("MAIL_DEFAULT_SENDER")
    app.config["ADMIN_EMAIL"] = os.environ.get("ADMIN_EMAIL")

    # --- Configuración de Celery ---
    app.config["broker_url"] = os.environ.get("broker_url", "redis://localhost:6379/0")
    app.config["result_backend"] = os.environ.get("result_backend", "redis://localhost:6379/0")
    app.config["imports"] = os.environ.get("imports", "app.tasks")

    # --- Configuración de Cloudinary ---
    cloudinary.config(
        cloud_name=os.environ.get("CLOUDINARY_CLOUD_NAME"),
        api_key=os.environ.get("CLOUDINARY_API_KEY"),
        api_secret=os.environ.get("CLOUDINARY_API_SECRET")
    )

    # === Inicializar extensiones ===
    db.init_app(app)
    migrate.init_app(app, db)
    login_manager.init_app(app)
    mail.init_app(app)
    login_manager.login_view = "auth.login"

    @login_manager.user_loader
    def load_user(user_id):
        from app.models import User
        return User.query.get(int(user_id))

    # === Registrar blueprints y filtros ===
    with app.app_context():
        from app import models
        from datetime import datetime
        from app.routes import routes
        from app.auth import auth

        app.register_blueprint(routes)
        app.register_blueprint(auth, url_prefix="/auth")

        # --- Filtros de plantilla personalizados ---
        @app.template_filter("sort_by_due_date")
        def sort_by_due_date(tasks):
            def sort_key(task):
                return task.due_date if task.due_date else datetime.max.date()
            return sorted(tasks, key=sort_key)

        @app.template_filter("without_page")
        def without_page(args):
            """Elimina el parámetro 'page' de la query string (paginación limpia)."""
            return {k: v for k, v in args.items() if k != "page"}

        # --- Registro de visitas ---
        @app.before_request
        def log_visit():
            """Registra cada visita en la base de datos (salvo rutas de login)."""
            if request.endpoint and not request.endpoint.startswith("auth"):
                from app.models import Visit
                Visit.log_visit(request)

    return app


# === Comandos CLI personalizados ===
def register_cli_commands(app):
    """Comandos CLI para gestión de la BD"""
    @app.cli.command("create-tables")
    def create_tables():
        """Crea todas las tablas manualmente"""
        with app.app_context():
            db.create_all()
            print("✅ Tablas creadas o ya existentes.")

    @app.cli.command("sync-sequences")
    def sync_sequences_command():
        """Sincroniza secuencias de PostgreSQL tras migración."""
        from scripts.sync_sequences import sync_all_sequences
        sync_all_sequences()


# === Instancia global para Gunicorn o Flask CLI ===
app = create_app()