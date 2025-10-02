import csv
import os
from datetime import datetime
from dateutil import parser as date_parser
from app import create_app, db
from app.models import (
    User, Assistant, Clinic, Task, Note, Publication, Availability,
    Appointment, MedicalRecord, Schedule, UserRole, Subscriber,
    CompanyInvite, InvitationLog, Visit
)

app = create_app()
app.app_context().push()

# ✅ Vaciar todas las tablas
print("🗑️  Vaciamos todas las tablas para sincronización limpia...")
for table in reversed(db.metadata.sorted_tables):
    print(f"  → Eliminando {table.name}...")
    db.session.execute(table.delete())
db.session.commit()
print("✅ Todas las tablas vaciadas.")

def import_csv_to_model(csv_path, model, skip_id=False):
    if not os.path.exists(csv_path):
        print(f"⚠️  No encontrado: {csv_path}")
        return

    with open(csv_path, 'r', encoding='utf-8-sig') as f:
        reader = csv.DictReader(f)
        count = 0
        for row in reader:
            cleaned = {}
            for key, value in row.items():
                if key == 'id' and skip_id:
                    continue  # ←←← Saltar el ID
                if value == '' or value is None:
                    cleaned[key] = None
                elif key in ['id', 'user_id', 'doctor_id', 'assistant_id', 'clinic_id', 'patient_id', 'role_id', 'created_by', 'approved_by']:
                    if not skip_id:  # solo convertir si no estamos saltando id
                        cleaned[key] = int(value) if str(value).isdigit() else None
                elif key in [
                    'is_active', 'is_admin', 'is_professional', 'is_used', 'success',
                    'is_published'
                ]:
                    cleaned[key] = str(value).strip().lower() in ('1', 'true', 't', 'yes', 'on', 'sí', 'si')
                elif key in ['created_at', 'updated_at', 'due_date', 'published_at', 'expires_at', 'used_at', 'approved_at']:
                    if value:
                        try:
                            cleaned[key] = date_parser.parse(value)
                        except:
                            cleaned[key] = None
                    else:
                        cleaned[key] = None
                else:
                    cleaned[key] = value

            try:
                obj = model(**cleaned)
                db.session.add(obj)
                count += 1
            except Exception as e:
                print(f"❌ Error en {model.__tablename__}, fila {count + 1}: {e}")
                continue

        db.session.commit()
        print(f"✅ Importado: {count} registros en {model.__tablename__}")

# Tablas con ID crítico (usuarios, roles, etc.) → mantener ID
import_csv_to_model('backup_render/user_roles.csv', UserRole, skip_id=False)
import_csv_to_model('backup_render/users.csv', User, skip_id=False)
import_csv_to_model('backup_render/clinic.csv', Clinic, skip_id=False)
import_csv_to_model('backup_render/assistants.csv', Assistant, skip_id=False)
import_csv_to_model('backup_render/tasks.csv', Task, skip_id=False)
import_csv_to_model('backup_render/notes.csv', Note, skip_id=False)
import_csv_to_model('backup_render/publications.csv', Publication, skip_id=False)
import_csv_to_model('backup_render/schedules.csv', Schedule, skip_id=False)
import_csv_to_model('backup_render/availability.csv', Availability, skip_id=False)
import_csv_to_model('backup_render/appointments.csv', Appointment, skip_id=False)
import_csv_to_model('backup_render/medical_records.csv', MedicalRecord, skip_id=False)
import_csv_to_model('backup_render/subscribers.csv', Subscriber, skip_id=False)
import_csv_to_model('backup_render/company_invites.csv', CompanyInvite, skip_id=False)
import_csv_to_model('backup_render/invitation_logs.csv', InvitationLog, skip_id=True)  # ← logs: sin ID
import_csv_to_model('backup_render/visits.csv', Visit, skip_id=True)  # ←←← logs: sin ID

print("🎉 Sincronización completada exitosamente.")