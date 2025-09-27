# app/__init__.py
import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from flask_mail import Mail

# Instancias globales
db = SQLAlchemy()
login_manager = LoginManager()
mail = Mail()

# Cloudinary (opcional)
try:
    import cloudinary
except ImportError:
    cloudinary = None

def create_app():
    # ✅ Cargar variables de entorno desde .env (solo en desarrollo)
    if os.environ.get("FLASK_ENV") != "production":
        from dotenv import load_dotenv
        load_dotenv()

    app = Flask(
        __name__,
        instance_relative_config=True,
        template_folder="../templates",
        static_folder="../static"
    )
    # ... resto del código ...

    # === Configuración ===
    app.config["SECRET_KEY"] = os.environ.get("SECRET_KEY") or "clave-secreta-para-desarrollo"
    
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
    login_manager.login_view = "auth.login"

    # ✅ USER_LOADER: debe estar aquí, fuera de app_context
    from app.models import User
    @login_manager.user_loader
    def load_user(user_id):
        return User.query.get(int(user_id))

    # === Contexto de la aplicación ===
    with app.app_context():
        # Importar todos los modelos para que SQLAlchemy los registre
        from app import models
        
        # Crear todas las tablas
        db.create_all()

        # ❌ TEMPORALMENTE COMENTADO: no crear admin automáticamente
        # Esto permite que el endpoint /init-db-render cargue datos limpios
        # from app.models import User
        # if not User.query.filter_by(is_admin=True).first():
        #     admin = User(
        #         username='admin',
        #         email='admin@bioforge.com',
        #         is_admin=True,
        #         is_professional=False,
        #         role_name='admin'
        #     )
        #     admin.set_password('temporal123')
        #     db.session.add(admin)
        #     db.session.commit()

        # Registrar Blueprints
        from app.routes import routes
        from app.auth import auth
        app.register_blueprint(routes)
        app.register_blueprint(auth, url_prefix="/auth")

        # Filtros personalizados
        from datetime import datetime

        @app.template_filter('sort_by_due_date')
        def sort_by_due_date(tasks):
            def sort_key(task):
                return task.due_date if task.due_date is not None else datetime.max.date()
            return sorted(tasks, key=sort_key)

        @app.template_filter('without_page')
        def without_page(args):
            return {k: v for k, v in args.items() if k != 'page'}

        # Configurar Cloudinary
        if cloudinary:
            cloudinary.config(
                cloud_name=os.environ.get("CLOUD_NAME"),
                api_key=os.environ.get("CLOUDINARY_API_KEY"),
                api_secret=os.environ.get("CLOUDINARY_API_SECRET"),
                secure=True
            )
        
        register_cli_commands(app)
        
    return app

# === Comandos CLI personalizados ===
def register_cli_commands(app):
    @app.cli.command("sync-sequences")
    def sync_sequences_command():
        """Sincroniza secuencias de PostgreSQL tras migración."""
        from scripts.sync_sequences import sync_all_sequences
        sync_all_sequences()

# ✅ Instancia para gunicorn (Render)
app = create_app()