import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import create_app, db
from app.models import Assistant, User

app = create_app()
app.app_context().push()

print("🔍 Vinculando asistentes por email...")

# Obtener todos los asistentes con email no vacío
assistants = Assistant.query.filter(
    Assistant.email.isnot(None),
    Assistant.email != ''
).all()

for assistant in assistants:
    user = User.query.filter_by(email=assistant.email).first()
    if user and assistant.user_id is None:
        assistant.user_id = user.id
        print(f"✅ {assistant.name} ({assistant.email}) → user.id = {user.id}")
    elif user and assistant.user_id == user.id:
        print(f"ℹ️  Ya vinculado: {assistant.name} ({assistant.email})")
    else:
        print(f"⚠️  Usuario no encontrado: {assistant.email}")

db.session.commit()
print("✅ Vinculación completada.")