# debug_login.py
from app import create_app
from app.models import User

app = create_app()

with app.app_context():
    print("\n" + "="*60)
    print("🔍 DEBUG: Verificando usuario admin@local")
    print("="*60)

    # 1. Buscar usuario
    user = User.query.filter_by(email="admin@local").first()
    if not user:
        print("❌ No se encontró el usuario admin@local")
        print("💡 Ejecuta: python init_db.py")
        print("="*60)
        exit()

    print(f"✅ Usuario encontrado: {user.username}")
    print(f"Email: {user.email}")
    print(f"Is Admin: {user.is_admin}")
    print(f"Password Hash: {user.password_hash}")

    # 2. Probar contraseña
    print("\n🔐 Probando check_password('admin123')...")
    if user.check_password("admin123"):
        print("✅ check_password('admin123') → OK")
    else:
        print("❌ check_password('admin123') → FALLÓ")

    print("\n🔐 Probando check_password('123')...")
    if user.check_password("123"):
        print("❌ check_password('123') → Debería fallar")
    else:
        print("✅ check_password('123') → Rechazada correctamente")

    print("="*60)