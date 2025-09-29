# fix_astiazu.py
from app import create_app, db
from app.models import Assistant, User

app = create_app()
app.app_context().push()

# Buscar usuario astiazu
user = User.query.filter_by(email='astiazu@gmail.com').first()
if not user:
    print("❌ Usuario astiazu no encontrado")
else:
    # Buscar su registro como asistente
    assistant = Assistant.query.filter_by(email='astiazu@gmail.com').first()
    if assistant:
        assistant.user_id = user.id
        db.session.commit()
        print(f"✅ Vinculado: assistant.id={assistant.id} → user.id={user.id}")
    else:
        print("❌ No se encontró asistente con email astiazu@gmail.com")