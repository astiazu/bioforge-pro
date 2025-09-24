# scripts/cargar_datos_locales.py
import os
import json
from datetime import datetime
from app import create_app, db
from app.models import (
    User, Note, Publication, NoteStatus, Clinic, Availability,
    Appointment, MedicalRecord, Schedule, UserRole, Subscriber,
    Assistant, Task, TaskStatus, CompanyInvite
)

# Mapeo flexible para nombres de tablas (singular/plural)
TABLE_ALIASES = {
    'users': 'users',
    'user': 'users',
    'notes': 'notes',
    'note': 'notes',
    'publications': 'publications',
    'publication': 'publications',
    'clinics': 'clinics',
    'clinic': 'clinics',
    'availabilities': 'availabilities',
    'availability': 'availabilities',
    'appointments': 'appointments',
    'appointment': 'appointments',
    'medical_records': 'medical_records',
    'medical_record': 'medical_records',
    'schedules': 'schedules',
    'schedule': 'schedules',
    'assistants': 'assistants',
    'assistant': 'assistants',
    'tasks': 'tasks',
    'task': 'tasks',
    'company_invites': 'company_invites',
    'company_invite': 'company_invites',
    'subscribers': 'subscribers',
    'subscriber': 'subscribers',
    'user_roles': 'user_roles',
    'user_role': 'user_roles'
}

def safe_iso_parse(date_str):
    """Parsea fechas ISO con manejo de 'Z'."""
    if not date_str:
        return None
    if date_str.endswith('Z'):
        date_str = date_str[:-1] + '+00:00'
    try:
        return datetime.fromisoformat(date_str)
    except (ValueError, TypeError):
        return None

def safe_time_parse(time_str):
    """Parsea tiempo en formato 'HH:MM:SS' o 'HH:MM'."""
    if not time_str:
        return None
    try:
        if len(time_str.split(':')) == 2:
            return datetime.strptime(time_str, '%H:%M').time()
        return datetime.strptime(time_str, '%H:%M:%S').time()
    except (ValueError, TypeError):
        return None

def main():
    app = create_app()
    with app.app_context():
        print("🔄 Iniciando carga de datos desde producción...")

        if not os.path.exists('data_from_render.json'):
            print("❌ Error: No se encontró data_from_render.json")
            return

        with open('data_from_render.json', 'r', encoding='utf-8') as f:
            try:
                data = json.load(f)
                print("✅ JSON cargado correctamente")
            except json.JSONDecodeError as e:
                print(f"❌ Error al leer JSON: {str(e)}")
                return

        # === Desactivar FK temporalmente (solo para SQLite) ===
        db.session.execute(db.text("PRAGMA foreign_keys = OFF"))
        db.session.commit()

        # === Limpiar tablas en orden inverso ===
        tables_to_clear = [
            Task, Note, Availability, Appointment, MedicalRecord,
            Schedule, Assistant, Publication, CompanyInvite,
            Subscriber, Clinic, User, UserRole
        ]
        for table in tables_to_clear:
            db.session.query(table).delete()
            print(f"🧹 Tabla {table.__tablename__} limpiada.")
        db.session.commit()
        db.session.execute(db.text("PRAGMA foreign_keys = ON"))
        db.session.commit()

        print("✅ Base de datos local limpia")

        try:
            # ---- USER ROLES ----
            print("👤 Cargando user_roles...")
            user_roles_data = data.get(TABLE_ALIASES['user_roles'], [])
            for ur in user_roles_data:
                if ur.get('id') and ur.get('name'):
                    db.session.add(UserRole(id=ur['id'], name=ur['name']))
            db.session.commit()

            # ---- USERS ----
            print("👥 Cargando users...")
            users_data = data.get(TABLE_ALIASES['users'], [])
            for u in users_data:
                if not (u.get('id') and u.get('username') and u.get('email')):
                    continue
                user = User(
                    id=u['id'],
                    username=u['username'],
                    email=u['email'],
                    is_professional=u.get('is_professional', False),
                    is_admin=u.get('is_admin', False),
                    role_name=u.get('role_name', 'user'),
                    specialty=u.get('specialty'),
                    bio=u.get('bio'),
                    years_experience=u.get('years_experience'),
                    profile_photo=u.get('profile_photo'),
                    url_slug=u.get('url_slug'),
                    license_number=u.get('license_number'),
                    created_at=safe_iso_parse(u.get('created_at')),
                    updated_at=safe_iso_parse(u.get('updated_at'))
                )
                user.set_password('temporal123')
                db.session.add(user)
            db.session.commit()

            # ---- CLINICS ----
            print("🏥 Cargando clinics...")
            clinics_data = data.get(TABLE_ALIASES['clinics'], [])
            for c in clinics_data:
                if not (c.get('id') and c.get('name') and c.get('doctor_id')):
                    continue
                clinic = Clinic(
                    id=c['id'],
                    name=c['name'],
                    address=c.get('address'),
                    phone=c.get('phone'),
                    specialty=c.get('specialty'),
                    doctor_id=c['doctor_id'],
                    is_active=c.get('is_active', True)
                )
                db.session.add(clinic)
            db.session.commit()

            # ---- ASSISTANTS ----
            print("🤝 Cargando assistants...")
            assistants_data = data.get(TABLE_ALIASES['assistants'], [])
            for a in assistants_data:
                if not (a.get('id') and a.get('name') and a.get('doctor_id')):
                    continue
                assistant = Assistant(
                    id=a['id'],
                    name=a['name'],
                    email=a.get('email'),
                    whatsapp=a.get('whatsapp'),
                    doctor_id=a['doctor_id'],
                    clinic_id=a.get('clinic_id'),
                    type=a.get('type', 'common'),
                    user_id=a.get('user_id'),
                    telegram_id=a.get('telegram_id'),
                    created_at=safe_iso_parse(a.get('created_at'))
                )
                db.session.add(assistant)
            db.session.commit()

            # ---- PUBLICATIONS ----
            print("📰 Cargando publications...")
            pubs_data = data.get(TABLE_ALIASES['publications'], [])
            for p in pubs_data:
                if not (p.get('id') and p.get('title') and p.get('user_id')):
                    continue
                from slugify import slugify
                slug = p.get('slug') or slugify(p['title']) or f"pub-{p['id']}"
                pub = Publication(
                    id=p['id'],
                    type=p.get('type', 'blog'),
                    title=p['title'],
                    excerpt=p.get('excerpt'),
                    content=p.get('content', ''),
                    is_published=(p.get('status') == 'published'),
                    user_id=p['user_id'],
                    image_url=p.get('image_url'),
                    slug=slug,
                    published_at=safe_iso_parse(p.get('published_at')),
                    view_count=p.get('view_count', 0),
                    tags=", ".join(p.get('tags', [])) if isinstance(p.get('tags'), list) else p.get('tags', "")
                )
                db.session.add(pub)
            db.session.commit()

            # ---- NOTES ----
            print("📝 Cargando notes...")
            notes_data = data.get(TABLE_ALIASES['notes'], [])
            for n in notes_data:
                if not (n.get('id') and n.get('content') and n.get('user_id')):
                    continue
                raw_status = n.get('status', 'private')
                try:
                    status_value = NoteStatus(raw_status).value
                except ValueError:
                    status_value = NoteStatus.PRIVATE.value
                note = Note(
                    id=n['id'],
                    title=n.get('title', ''),
                    content=n['content'],
                    user_id=n['user_id'],
                    status=status_value,
                    created_at=safe_iso_parse(n.get('created_at'))
                )
                db.session.add(note)
            db.session.commit()

            # ---- SCHEDULES ----
            print("📅 Cargando schedules...")
            schedules_data = data.get(TABLE_ALIASES['schedules'], [])
            for s in schedules_data:
                if not (s.get('id') and s.get('day_of_week') and s.get('doctor_id') and s.get('clinic_id')):
                    continue
                schedule = Schedule(
                    id=s['id'],
                    day_of_week=s['day_of_week'],
                    start_time=safe_time_parse(s.get('start_time')),
                    end_time=safe_time_parse(s.get('end_time')),
                    doctor_id=s['doctor_id'],
                    clinic_id=s['clinic_id'],
                    is_active=s.get('is_active', True)
                )
                db.session.add(schedule)
            db.session.commit()

            # ---- AVAILABILITY ----
            print("✅ Cargando availability...")
            avail_data = data.get(TABLE_ALIASES['availabilities'], [])
            for a in avail_data:
                if not (a.get('id') and a.get('date') and a.get('clinic_id')):
                    continue
                availability = Availability(
                    id=a['id'],
                    date=safe_iso_parse(a['date']).date() if a.get('date') else None,
                    time=safe_time_parse(a.get('time')),
                    clinic_id=a['clinic_id'],
                    is_booked=a.get('is_booked', False),
                    appointment_id=a.get('appointment_id')
                )
                db.session.add(availability)
            db.session.commit()

            # ---- APPOINTMENTS ----
            print("🩺 Cargando appointments...")
            appts_data = data.get(TABLE_ALIASES['appointments'], [])
            for ap in appts_data:
                if not (ap.get('id') and ap.get('patient_id') and ap.get('availability_id')):
                    continue
                appt = Appointment(
                    id=ap['id'],
                    patient_id=ap['patient_id'],
                    availability_id=ap['availability_id'],
                    notes=ap.get('notes'),
                    status=ap.get('status', 'confirmed')
                )
                db.session.add(appt)
            db.session.commit()

            # ---- MEDICAL RECORDS ----
            print("📋 Cargando medical_records...")
            mr_data = data.get(TABLE_ALIASES['medical_records'], [])
            for mr in mr_data:
                if not (mr.get('id') and mr.get('patient_id') and mr.get('doctor_id') and mr.get('title')):
                    continue
                record = MedicalRecord(
                    id=mr['id'],
                    patient_id=mr['patient_id'],
                    doctor_id=mr['doctor_id'],
                    title=mr['title'],
                    notes=mr['notes'],
                    created_at=safe_iso_parse(mr.get('created_at'))
                )
                db.session.add(record)
            db.session.commit()

            # ---- TASKS ----
            print("✅ Cargando tasks...")
            tasks_data = data.get(TABLE_ALIASES['tasks'], [])
            for t in tasks_data:
                if not (t.get('id') and t.get('title') and t.get('doctor_id') and t.get('assistant_id')):
                    continue
                raw_status = t.get('status', 'pending')
                try:
                    status_value = TaskStatus(raw_status).value
                except ValueError:
                    status_value = TaskStatus.PENDING.value
                task = Task(
                    id=t['id'],
                    title=t['title'],
                    description=t.get('description'),
                    due_date=safe_iso_parse(t.get('due_date')).date() if t.get('due_date') else None,
                    status=status_value,
                    doctor_id=t['doctor_id'],
                    assistant_id=t['assistant_id'],
                    clinic_id=t.get('clinic_id'),
                    created_by=t.get('created_by'),
                    created_at=safe_iso_parse(t.get('created_at'))
                )
                db.session.add(task)
            db.session.commit()

            # ---- COMPANY INVITES ----
            print("📨 Cargando company_invites...")
            invites_data = data.get(TABLE_ALIASES['company_invites'], [])
            for inv in invites_data:
                if not (inv.get('id') and inv.get('invite_code') and inv.get('email') and inv.get('doctor_id')):
                    continue
                invite = CompanyInvite(
                    id=inv['id'],
                    invite_code=inv['invite_code'],
                    email=inv['email'],
                    name=inv.get('name'),
                    doctor_id=inv['doctor_id'],
                    clinic_id=inv.get('clinic_id'),
                    assistant_type=inv['assistant_type'],
                    whatsapp=inv.get('whatsapp'),
                    expires_at=safe_iso_parse(inv.get('expires_at')),
                    is_used=inv.get('is_used', False)
                )
                db.session.add(invite)
            db.session.commit()

            # ---- SUBSCRIBERS ----
            print("📩 Cargando subscribers...")
            subs_data = data.get(TABLE_ALIASES['subscribers'], [])
            for s in subs_data:
                if not (s.get('id') and s.get('email')):
                    continue
                sub = Subscriber(
                    id=s['id'],
                    email=s['email'],
                    subscribed_at=safe_iso_parse(s.get('subscribed_at'))
                )
                db.session.add(sub)
            db.session.commit()

            print("\n🎉 ¡Todos los datos han sido cargados exitosamente!")
            print("💡 Contraseñas temporales: 'temporal123'")

            # === Verificación final ===
            print("\n📊 VERIFICACIÓN FINAL:")
            print(f"Usuarios: {User.query.count()}")
            print(f"Notas: {Note.query.count()}")
            print(f"Publicaciones: {Publication.query.count()}")
            print(f"Tareas: {Task.query.count()}")
            print(f"Suscriptores: {Subscriber.query.count()}")
            print(f"Clínicas: {Clinic.query.count()}")
            print(f"Asistentes: {Assistant.query.count()}")

        except Exception as e:
            db.session.rollback()
            print(f"❌ Error durante la carga: {str(e)}")
            raise

if __name__ == '__main__':
    main()