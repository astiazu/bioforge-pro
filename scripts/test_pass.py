# test_password.py
from app import create_app
from app.models import User

app = create_app()

with app.app_context():
    user = User.query.filter_by(email="admin@local").first()
    if not user:
        print("❌ No se encontró el usuario")
    else:
        print(f"Usuario: {user.username}")
        print(f"Hash: {user.password_hash}")

        # Prueba con la contraseña correcta
        if user.check_password("admin123"):
            print("✅ check_password('admin123') → OK")
        else:
            print("❌ check_password('admin123') → FALLÓ")

        # Prueba con una incorrecta
        if user.check_password("123"):
            print("❌ check_password('123') → Debería fallar")
        else:
            print("✅ check_password('123') → Rechazada correctamente")