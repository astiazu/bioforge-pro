# app/__init__.py
import os
from flask import Flask, request
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from flask_mail import Mail
from flask_migrate import Migrate
from dotenv import load_dotenv
from app.filters import now, format_date
import cloudinary

# === Instancias globales ===
db = SQLAlchemy()
login_manager = LoginManager()
mail = Mail()
migrate = Migrate()


def create_app(strict_mode: bool = False):
    """Crea e inicializa la aplicación Flask."""
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
    app.config["SECRET_KEY"] = os.environ.get("SECRET_KEY", "dev-secret-key")
    app.config["DEBUG"] = True
    
    # --- Configuración base de datos ---
    database_url = os.environ.get("DATABASE_URL")
    if database_url:
        if database_url.startswith("postgres://"):
            database_url = database_url.replace("postgres://", "postgresql://", 1)
        app.config["SQLALCHEMY_DATABASE_URI"] = database_url
    else:
        os.makedirs(app.instance_path, exist_ok=True)
        app.config["SQLALCHEMY_DATABASE_URI"] = f"sqlite:///{os.path.join(app.instance_path, 'bioforge.db')}"

    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    # --- Configuración de Email ---
    app.config.update(
        MAIL_SERVER=os.environ.get("MAIL_SERVER"),
        MAIL_PORT=int(os.environ.get("MAIL_PORT", 587)),
        MAIL_USE_TLS=os.environ.get("MAIL_USE_TLS", "True") == "True",
        MAIL_USERNAME=os.environ.get("MAIL_USERNAME"),
        MAIL_PASSWORD=os.environ.get("MAIL_PASSWORD"),
        MAIL_DEFAULT_SENDER=os.environ.get("MAIL_DEFAULT_SENDER"),
        ADMIN_EMAIL=os.environ.get("ADMIN_EMAIL"),
    )

    # --- Configuración de Celery ---
    app.config["broker_url"] = os.environ.get("broker_url", "redis://localhost:6379/0")
    app.config["result_backend"] = os.environ.get("result_backend", "redis://localhost:6379/0")

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
        from app.utils import format_date
        # ✅ REGISTRAR COMANDOS CLI
        from app.commands import register_commands
        register_commands(app)  # <-- AGREGAR ESTA LÍNEA
        
        # ✅ IMPORTAR Y REGISTRAR BLUEPRINT DE ANUNCIOS
        try:
            from app.admin.anuncios import admin_anuncios
            app.register_blueprint(admin_anuncios)
        except ImportError as e:
            print(f"⚠️  No se pudo registrar blueprint de anuncios: {e}")
            print("⚠️  Asegúrate de crear el archivo app/admin/anuncios.py")

        app.jinja_env.filters["format_date"] = format_date
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
            return {k: v for k, v in args.items() if k != "page"}

        # --- Registro de visitas ---
        @app.before_request
        def log_visit():
            """Registra cada visita (excepto rutas de login y estáticas)."""
            if request.endpoint and not request.endpoint.startswith(("auth", "static")):
                from app.models import Visit
                try:
                    Visit.log_visit(request)
                except Exception:
                    pass  # Evita que un fallo de logging rompa la carga principal
        
        @app.context_processor
        def inject_now():
            """
            Inyecta la función `now` en el contexto global de Jinja2.
            """
            return {'now': now}

        # ✅ NUEVO CONTEXT PROCESSOR PARA ANUNCIOS
        @app.context_processor
        def inject_anuncios():
            """
            Inyecta funciones de anuncios en el contexto global de Jinja2.
            """
            try:
                from app.services.servicio_anuncios import ServicioAnuncios
                
                def obtener_anuncios(posicion="sidebar", limite=5):
                    """Obtiene anuncios activos para mostrar en templates"""
                    return ServicioAnuncios.obtener_anuncios_activos(
                        limite=limite, 
                        posicion=posicion
                    )
                
                def registrar_impresion_anuncio(anuncio_id):
                    """Registra una impresión de anuncio (para usar en templates)"""
                    ServicioAnuncios.registrar_impresion(anuncio_id)
                    return ""  # Retorna string vacío para usar en templates
                
                return {
                    'obtener_anuncios': obtener_anuncios,
                    'registrar_impresion_anuncio': registrar_impresion_anuncio
                }
                
            except ImportError as e:
                print(f"⚠️  No se pudo cargar servicio de anuncios: {e}")
                print("⚠️  Asegúrate de crear el archivo app/services/servicio_anuncios.py")
                
                # Retornar funciones dummy para evitar errores
                def obtener_anuncios_dummy(posicion="sidebar", limite=5):
                    return []
                
                def registrar_impresion_anuncio_dummy(anuncio_id):
                    return ""
                
                return {
                    'obtener_anuncios': obtener_anuncios_dummy,
                    'registrar_impresion_anuncio': registrar_impresion_anuncio_dummy
                }

    return app

app = create_app()