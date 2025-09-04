# init_db.py
from app import create_app, db
from app.models import User

app = create_app()

with app.app_context():
    db.create_all()
    print("✅ Tablas creadas")

    admin = User.query.filter_by(email="admin@local").first()
    if not admin:
        admin = User(
            username="admin",
            email="admin@local",
            is_admin=True,
            is_professional=False  # ✅ Asegúrate de incluirlo
        )
        admin.set_password("admin123")
        db.session.add(admin)
        db.session.commit()
        print("✅ Admin creado: admin@local / admin123")
    else:
        print("ℹ️ El admin ya existe.")