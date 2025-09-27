import json
from datetime import datetime
from app import create_app, db
from app.models import User, UserRole, Publication, Clinic, Note, Assistant, Task, Subscriber

def parse_datetime(s):
    if not s:
        return None
    try:
        return datetime.fromisoformat(s.replace(" ", "T"))
    except:
        return None

def cargar_datos():
    app = create_app()
    app.app_context().push()

    with open('datos.json', 'r', encoding='utf-8') as f:
        data = json.load(f)

    print("📦 Cargando UserRoles...")
    role_map = {}
    for item in data.get('user_roles', []):
        role = UserRole.query.filter_by(name=item['name']).first()
        if not role:
            role = UserRole(
                id=item['id'],
                name=item['name'],
                description=item.get('description', ''),
                is_active=item.get('is_active', True),
                created_at=parse_datetime(item.get('created_at'))
            )
            db.session.add(role)
            print(f"  ➕ {role.name}")
        role_map[item['id']] = role.id

    print("\n👤 Cargando Usuarios...")
    user_map = {}
    for item in data.get('users', []):
        if User.query.filter_by(email=item['email']).first():
            print(f"  ➖ Ya existe: {item['email']}")
            continue
            
        user = User(
            id=item['id'],
            username=item['username'],
            email=item['email'],
            password_hash=item['password_hash'],
            is_admin=item.get('is_admin', False),
            is_professional=item.get('is_professional', False),
            created_at=parse_datetime(item.get('created_at')),
            updated_at=parse_datetime(item.get('updated_at')),
            url_slug=item.get('url_slug'),
            professional_category=item.get('professional_category'),
            specialty=item.get('specialty'),
            bio=item.get('bio'),
            years_experience=item.get('years_experience'),
            profile_photo=item.get('profile_photo'),
            license_number=item.get('license_number'),
            services=item.get('services'),
            skills=item.get('skills'),
            role_name=item.get('role_name', 'user'),
            role_id=item.get('role_id')
        )
        db.session.add(user)
        db.session.flush()
        user_map[item['id']] = user.id
        print(f"  ➕ {user.username}")

    print("\n🏥 Cargando Clínicas...")
    clinic_map = {}
    for item in data.get('clinics', []):
        if item['doctor_id'] not in user_map:
            print(f"  ⚠️ Doctor no encontrado: {item.get('name')}")
            continue
        clinic = Clinic.query.filter_by(name=item['name'], doctor_id=user_map[item['doctor_id']]).first()
        if not clinic:
            clinic = Clinic(
                id=item['id'],
                name=item['name'],
                address=item['address'],
                phone=item.get('phone'),
                specialty=item.get('specialty'),
                doctor_id=user_map[item['doctor_id']],
                is_active=item.get('is_active', True)
            )
            db.session.add(clinic)
            db.session.flush()
            clinic_map[item['id']] = clinic.id
            print(f"  ➕ {clinic.name}")

    print("\n📂 Cargando Publicaciones...")
    for item in data.get('publications', []):
        if item['user_id'] not in user_map:
            print(f"  ⚠️ Autor no encontrado: {item.get('title')}")
            continue
        pub = Publication.query.filter_by(title=item['title'], user_id=user_map[item['user_id']]).first()
        if not pub:
            pub = Publication(
                id=item['id'],
                type=item['type'],
                title=item['title'],
                content=item['content'],
                excerpt=item.get('excerpt'),
                is_published=item.get('is_published', True),
                user_id=user_map[item['user_id']],
                tags=item.get('tags'),
                read_time=item.get('read_time'),
                created_at=parse_datetime(item.get('created_at')),
                updated_at=parse_datetime(item.get('updated_at')),
                published_at=parse_datetime(item.get('published_at')),
                image_url=item.get('image_url'),
                view_count=item.get('view_count', 0)
            )
            db.session.add(pub)
            print(f"  ➕ {pub.title}")

    print("\n📝 Cargando Notas...")
    for item in data.get('notes', []):
        if item['user_id'] not in user_map:
            print(f"  ⚠️ Autor no encontrado: {item.get('title')}")
            continue
        note = Note.query.filter_by(title=item['title'], user_id=user_map[item['user_id']]).first()
        if not note:
            note = Note(
                id=item['id'],
                title=item['title'],
                content=item['content'],
                status=item.get('status', 'private'),
                user_id=user_map[item['user_id']],
                patient_id=item.get('patient_id'),
                created_at=parse_datetime(item.get('created_at')),
                approved_by=item.get('approved_by'),
                approved_at=parse_datetime(item.get('approved_at')),
                updated_at=parse_datetime(item.get('updated_at')),
                featured_image=item.get('featured_image'),
                view_count=item.get('view_count', 0)
            )
            db.session.add(note)
            print(f"  ➕ {note.title}")

    print("\n👥 Cargando Asistentes...")
    assistant_map = {}
    for item in data.get('assistants', []):
        if item['doctor_id'] not in user_map:
            print(f"  ⚠️ Doctor no encontrado: {item.get('name')}")
            continue
        assistant = Assistant.query.filter_by(name=item['name'], doctor_id=user_map[item['doctor_id']]).first()
        if not assistant:
            assistant = Assistant(
                id=item['id'],
                name=item['name'],
                email=item.get('email'),
                whatsapp=item.get('whatsapp'),
                is_active=item.get('is_active', True),
                clinic_id=item.get('clinic_id'),
                doctor_id=user_map[item['doctor_id']],
                telegram_id=item.get('telegram_id'),
                type=item.get('type', 'common'),
                user_id=item.get('user_id')
            )
            db.session.add(assistant)
            db.session.flush()
            assistant_map[item['id']] = assistant.id
            print(f"  ➕ {assistant.name}")

    print("\n✅ Cargando Tareas...")
    for item in data.get('tasks', []):
        if item['doctor_id'] not in user_map:
            print(f"  ⚠️ Doctor no encontrado: {item.get('title')}")
            continue
        if item['assistant_id'] not in assistant_map:
            print(f"  ⚠️ Asistente no encontrado: {item.get('title')}")
            continue
        task = Task.query.filter_by(title=item['title'], doctor_id=user_map[item['doctor_id']]).first()
        if not task:
            task = Task(
                id=item['id'],
                title=item['title'],
                description=item.get('description'),
                due_date=item.get('due_date'),
                status=item.get('status', 'pending'),
                doctor_id=user_map[item['doctor_id']],
                assistant_id=assistant_map[item['assistant_id']],
                clinic_id=item.get('clinic_id'),
                created_at=parse_datetime(item.get('created_at'))
            )
            db.session.add(task)
            print(f"  ➕ {task.title}")

    print("\n📧 Cargando Suscriptores...")
    for item in data.get('subscribers', []):
        if Subscriber.query.filter_by(email=item['email']).first():
            print(f"  ➖ Ya existe: {item['email']}")
            continue
        sub = Subscriber(
            id=item['id'],
            email=item['email'],
            subscribed_at=parse_datetime(item.get('subscribed_at'))
        )
        db.session.add(sub)
        print(f"  ➕ {sub.email}")

    db.session.commit()
    print("\n✅ ¡Todos los datos se cargaron exitosamente en PostgreSQL!")

if __name__ == '__main__':
    cargar_datos()