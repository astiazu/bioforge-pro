# debug_user.py
from app import create_app
from app.models import User

app = create_app()

with app.app_context():
    user = User.query.filter_by(email="admin@local").first()
    if user:
        print(f"✅ Usuario encontrado: {user.username}")
        print(f"Email: {user.email}")
        print(f"¿Es admin? {user.is_admin}")
        print(f"Contraseña hash: {user.password_hash}")
    else:
        print("❌ No se encontró el usuario admin@local")