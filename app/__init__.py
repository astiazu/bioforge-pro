import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from flask_mail import Mail
from flask_migrate import Migrate

# Instancias globales (declaradas fuera de create_app)
db = SQLAlchemy()
login_manager = LoginManager()
mail = Mail()
migrate = Migrate()

# ✅ Cloudinary: import opcional (no rompe si no está instalado)
try:
    import cloudinary
except ImportError:
    cloudinary = None


def create_app():
    app = Flask(
        __name__,
        instance_relative_config=True,
        template_folder="../templates",
        static_folder="../static"
    )

    # === Configuración ===
    app.config["SECRET_KEY"] = os.environ.get("SECRET_KEY") or "clave-secreta-para-desarrollo-cambia-esto-en-produccion"

    # Base de datos
    if os.environ.get('DATABASE_URL'):
        database_url = os.environ.get('DATABASE_URL')
        if database_url.startswith("postgres://"):
            database_url = database_url.replace("postgres://", "postgresql://", 1)
        app.config["SQLALCHEMY_DATABASE_URI"] = database_url
    else:
        os.makedirs(app.instance_path, exist_ok=True)
        app.config["SQLALCHEMY_DATABASE_URI"] = f"sqlite:///{os.path.join(app.instance_path, 'portfolio.db')}"

    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    # Email (Gmail)
    app.config["MAIL_SERVER"] = "smtp.gmail.com"
    app.config["MAIL_PORT"] = 587
    app.config["MAIL_USE_TLS"] = True
    app.config["MAIL_USERNAME"] = os.environ.get("MAIL_USERNAME") or "astiazu@gmail.com"
    app.config["MAIL_PASSWORD"] = os.environ.get("MAIL_PASSWORD") or "wepy imlw ltus fxoq"
    app.config["MAIL_DEFAULT_SENDER"] = ("Equipo Fuerza Bruta", app.config["MAIL_USERNAME"])

    # Telegram
    app.config['TELEGRAM_BOT_TOKEN'] = os.environ.get('TELEGRAM_BOT_TOKEN')
    app.config['TELEGRAM_CHAT_ID'] = os.environ.get('TELEGRAM_CHAT_ID')

    # === Inicializar extensiones ===
    db.init_app(app)
    login_manager.init_app(app)
    mail.init_app(app)
    migrate.init_app(app, db)
    login_manager.login_view = "auth.login"

    # === Configurar Cloudinary (si está disponible) ===
    if cloudinary:
        with app.app_context():
            cloudinary.config(
                cloud_name=os.environ.get("CLOUD_NAME"),
                api_key=os.environ.get("CLOUDINARY_API_KEY"),
                api_secret=os.environ.get("CLOUDINARY_API_SECRET"),
                secure=True
            )

    # === Registrar Blueprints ===
    from app.routes import routes
    from app.auth import auth

    app.register_blueprint(routes)
    app.register_blueprint(auth, url_prefix="/auth")

    # === Contexto de la aplicación ===
    with app.app_context():
        # Crear tablas (solo en desarrollo; en producción usa migraciones)
        db.create_all()

        # Cargar usuario
        from app.models import User

        @login_manager.user_loader
        def load_user(user_id):
            return User.query.get(int(user_id))

        # === Filtros personalizados ===
        from datetime import datetime

        @app.template_filter('sort_by_due_date')
        def sort_by_due_date(tasks):
            def sort_key(task):
                return task.due_date if task.due_date is not None else datetime.max.date()
            return sorted(tasks, key=sort_key)

        @app.template_filter('without_page')
        def without_page(args):
            """Filtra los args para quitar 'page'"""
            return {k: v for k, v in args.items() if k != 'page'}

    return app