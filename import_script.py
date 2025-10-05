# ===============================
# import_script.py (root)
# ===============================

from app import create_app, db
from app.models import User, Publication, Note  # 👈 Ajustá según tus modelos reales
from sqlalchemy.exc import IntegrityError

def run_import():
    """Inicializa la base de datos con datos iniciales o relaciones clave."""
    print("🔹 Iniciando importación automática en Render...")

    try:
        db.create_all()
        print("✅ Tablas creadas o ya existentes.")

        # 🔸 Usuario admin inicial (solo si no existe)
        if not User.query.first():
            admin = User(
                username="admin",
                email="admin@example.com",
                password="1234",  # en producción: reemplazá por hash real
                role="admin"
            )
            db.session.add(admin)
            db.session.commit()
            print("✅ Usuario admin creado correctamente.")
        else:
            print("ℹ️ Usuario existente detectado. No se creó uno nuevo.")

    except IntegrityError as e:
        db.session.rollback()
        print(f"⚠️ Error de integridad: {e}")

    except Exception as e:
        print(f"❌ Error general durante la importación: {e}")

    print("🏁 Importación finalizada.")


if __name__ == "__main__":
    app = create_app(strict_mode=False)
    with app.app_context():
        run_import()