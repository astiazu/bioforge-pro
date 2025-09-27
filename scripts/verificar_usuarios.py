# scripts/verificar_usuarios.py
from app import create_app, db
from app.models import User

app = create_app()

with app.app_context():
    print("🔍 Buscando usuarios...")
    users = User.query.all()
    for u in users:
        print(f"ID: {u.id} | Email: {u.email} | Username: {u.username} | Admin: {u.is_admin} | Profesional: {u.is_professional}")