# app/__init__.py
import os
from flask import Flask, request
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from flask_mail import Mail
from flask_migrate import Migrate
from flask import Flask
from .filters import format_date  # Filtro Fechas

# === Instancias globales ===
db = SQLAlchemy()
login_manager = LoginManager()
mail = Mail()
migrate = Migrate()

try:
    import cloudinary
except ImportError:
    cloudinary = None


def create_app(strict_mode=False):
    """
    Crea e inicializa la aplicación Flask.
    Compatible con entornos locales y Render.
    """
    from dotenv import load_dotenv

    # Cargar variables locales si no estamos en producción
    if os.environ.get("FLASK_ENV") != "production":
        load_dotenv()

    app = Flask(
        __name__,
        instance_relative_config=True,
        template_folder="../templates",
        static_folder="../static"
    )
    
    # Registrar el filtro personalizado
    app.jinja_env.filters['format_date'] = format_date

    # === Configuración general ===
    app.config["SECRET_KEY"] = os.environ.get("SECRET_KEY") or "clave-secreta-para-desarrollo"

    # --- Configuración base de datos ---
    if os.environ.get("DATABASE_URL"):
        database_url = os.environ.get("DATABASE_URL")

        # Render usa postgres:// (viejo) → reemplazar por postgresql://
        if database_url.startswith("postgres://"):
            database_url = database_url.replace("postgres://", "postgresql://", 1)

        app.config["SQLALCHEMY_DATABASE_URI"] = database_url

        # Detectar si estamos en Render o local
        if "render.com" in database_url or os.environ.get("RENDER") == "true":
            ssl_args = {"sslmode": "require"}  # Render exige SSL
        else:
            ssl_args = {}
    else:
        # Base de datos local SQLite
        os.makedirs(app.instance_path, exist_ok=True)
        app.config["SQLALCHEMY_DATABASE_URI"] = f"sqlite:///{os.path.join(app.instance_path, 'portfolio.db')}"
        ssl_args = {}

    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
    app.config["SQLALCHEMY_ENGINE_OPTIONS"] = {
        "connect_args": ssl_args,
        "pool_pre_ping": True,
        "pool_recycle": 300,
        "execution_options": {"strict_mode": strict_mode},
    }

    # === Configuración de Email ===
    
    app.config["MAIL_SERVER"] = "smtp.gmail.com"
    app.config["MAIL_PORT"] = 587
    app.config["MAIL_USE_TLS"] = True
    app.config["MAIL_USERNAME"] = os.environ.get("MAIL_USERNAME") or "astiazu@gmail.com"
    app.config["MAIL_PASSWORD"] = os.environ.get("MAIL_PASSWORD") or "wepy imlw ltus fxoq"

    # Estos dos se fijan explícitamente según lo que pediste
    app.config["MAIL_DEFAULT_SENDER"] = ("Equipo Fuerza Bruta", "astiazu@gmail.com")
    app.config["ADMIN_EMAIL"] = "astiazu@gmail.com"

    # === Inicializar extensiones ===
    db.init_app(app)
    migrate.init_app(app, db)
    login_manager.init_app(app)
    mail.init_app(app)
    login_manager.login_view = "auth.login"

    from app.models import User

    # 🔹 Ahora sí, inicializar Migrate
    migrate.init_app(app, db)

    @login_manager.user_loader
    def load_user(user_id):
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

        # --- Configurar Cloudinary (opcional) ---
        if cloudinary:
            cloudinary.config(
                cloud_name=os.environ.get("CLOUD_NAME"),
                api_key=os.environ.get("CLOUDINARY_API_KEY"),
                api_secret=os.environ.get("CLOUDINARY_API_SECRET"),
                secure=True,
            )

        # No crear tablas automáticamente (se hace manualmente)
        register_cli_commands(app)

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
