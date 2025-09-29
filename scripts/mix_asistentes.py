import os
import sys
import uuid
from datetime import datetime

# Aseguramos que el entorno de Flask esté cargado
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import create_app, db
from app.models import User, Assistant, Task, Clinic, UserRole

app = create_app()
app.app_context().push()

# Contraseña por defecto para usuarios temporales (hasheada)
from werkzeug.security import generate_password_hash
TEMP_PASSWORD = "bioforge_temp123"
TEMP_PASSWORD_HASH = generate_password_hash(TEMP_PASSWORD)

def create_temp_user(assistant_name, doctor_id):
    """Crea un usuario temporal para un asistente sin email."""
    base_email = f"temp_{uuid.uuid4().hex[:8]}@bioforge.local"
    username = f"temp_{assistant_name.replace(' ', '_')}"[:20]
    
    # Evitar colisiones de username
    counter = 1
    original_username = username
    while User.query.filter_by(username=username).first():
        username = f"{original_username}_{counter}"
        counter += 1

    user = User(
        username=username,
        email=base_email,
        password_hash=TEMP_PASSWORD_HASH,
        is_professional=False,
        role_id=3,  # Asistente
        created_at=datetime.utcnow()
    )
    db.session.add(user)
    db.session.flush()  # Para obtener el user.id sin commitear aún
    return user

def main():
    print("🔍 Iniciando corrección de asistentes y tareas...")

    # 1. Vincular assistants con users (o crear usuarios temporales)
    assistants = Assistant.query.all()
    for assistant in assistants:
        if assistant.email and assistant.email.strip():
            # Buscar usuario existente por email (case-insensitive)
            user = User.query.filter(
                db.func.lower(User.email) == db.func.lower(assistant.email.strip())
            ).first()
            if user:
                assistant.user_id = user.id
                print(f"✅ Vinculado: {assistant.name} ({assistant.email}) → user.id={user.id}")
            else:
                print(f"⚠️  Usuario no encontrado para email: {assistant.email}. Creando temporal...")
                temp_user = create_temp_user(assistant.name, assistant.doctor_id)
                assistant.user_id = temp_user.id
                print(f"🆕 Creado usuario temporal: {temp_user.username} ({temp_user.email})")
        else:
            # Email vacío → crear usuario temporal
            print(f"📧 Email vacío para asistente '{assistant.name}'. Creando usuario temporal...")
            temp_user = create_temp_user(assistant.name or "SinNombre", assistant.doctor_id)
            assistant.user_id = temp_user.id
            print(f"🆕 Creado usuario temporal: {temp_user.username} ({temp_user.email})")

    # 2. Completar tasks.created_by = doctor_id
    tasks = Task.query.filter(Task.created_by.is_(None)).all()
    for task in tasks:
        task.created_by = task.doctor_id
        print(f"✏️  Tarea {task.id}: created_by = {task.doctor_id}")

    # 3. Completar tasks.clinic_id desde assistant.clinic_id
    for task in Task.query.filter(Task.clinic_id.is_(None)).all():
        if task.assistant_id:
            assistant = Assistant.query.get(task.assistant_id)
            if assistant and assistant.clinic_id:
                task.clinic_id = assistant.clinic_id
                print(f"🏢 Tarea {task.id}: clinic_id = {assistant.clinic_id} (desde asistente)")

    # Guardar todos los cambios
    try:
        db.session.commit()
        print("\n✅ ¡Corrección completada y guardada en la base de datos!")
        print(f"💡 Los usuarios temporales usan contraseña: {TEMP_PASSWORD}")
    except Exception as e:
        db.session.rollback()
        print(f"\n❌ Error al guardar: {e}")
        raise

if __name__ == "__main__":
    main()