# debug_db.py
from app import create_app
from app.models import User

app = create_app()

with app.app_context():
    print("\n" + "="*60)
    print("🔍 DEBUG: Verificando base de datos en instance/portfolio.db")
    print("="*60)

    # Listar todos los usuarios
    users = User.query.all()
    if not users:
        print("❌ No hay usuarios en la base de datos.")
    else:
        print(f"✅ Hay {len(users)} usuario(s):")
        for u in users:
            print(f"  ID: {u.id}")
            print(f"  Username: {u.username}")
            print(f"  Email: {u.email}")
            print(f"  Is Admin: {u.is_admin}")
            print(f"  Password Hash: {u.password_hash}")
            print(f"  is_professional: {u.is_professional}")
            print("  " + "-"*40)            

    # Buscar específicamente al admin@local
    admin = User.query.filter_by(email="admin@local").first()
    if admin:
        print("✅ ¡Usuario admin@local encontrado!")
        print(f"  Es admin: {admin.is_admin}")
        print(f"  Hash: {admin.password_hash}")
    else:
        print("❌ No se encontró el usuario admin@local")

    print("="*60)