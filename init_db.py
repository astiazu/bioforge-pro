# init_db.py
from app import create_app, db
from app.models import User, UserRole, Publication, Clinic, Availability, Appointment, MedicalRecord, Schedule

app = create_app()

with app.app_context():
    # ✅ Elimina todas las tablas (opcional, para limpiar)
    # db.drop_all()  # Descomenta si quieres borrar y recrear
    db.create_all()
    print("✅ Tablas creadas")

    # ✅ Crea roles si no existen
    if not UserRole.query.filter_by(name="Profesional").first():
        db.session.add(UserRole(name="Profesional", description="Profesional de la salud"))
    if not UserRole.query.filter_by(name="Tienda").first():
        db.session.add(UserRole(name="Tienda", description="Tienda de productos"))
    if not UserRole.query.filter_by(name="Visitante").first():
        db.session.add(UserRole(name="Visitante", description="Usuario visitante"))
    if not UserRole.query.filter_by(name="Paciente").first():
        db.session.add(UserRole(name="Paciente", description="Paciente"))
    db.session.commit()

    # ✅ Crea admin
    admin = User.query.filter_by(email="admin@local").first()
    if not admin:
        admin = User(
            username="admin",
            email="admin@local",
            is_admin=True,
            is_professional=False,
            role_id=UserRole.query.filter_by(name="Visitante").first().id
        )
        admin.set_password("admin123")
        db.session.add(admin)
        db.session.commit()
        print("✅ Admin creado: admin@local / admin123")
    else:
        print("ℹ️ El admin ya existe.")