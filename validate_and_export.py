# validate_and_export.py
import os
import sys
import csv
import json
from datetime import datetime
from app import create_app
from app.models import (
    User, Assistant, Clinic, Task, Note, Publication, Availability,
    Appointment, MedicalRecord, Schedule, UserRole, Subscriber,
    CompanyInvite, InvitationLog, Visit, Product, ProductCategory, Event, Anuncio
)

def safe_serialize(value):
    if value is None:
        return ''
    if isinstance(value, datetime):
        return value.isoformat()
    if isinstance(value, bool):
        return 'true' if value else 'false'
    if isinstance(value, (int, float)):
        return str(value)
    if isinstance(value, (dict, list)):
        return json.dumps(value, ensure_ascii=False)
    if hasattr(value, '__dict__'):
        return str(value)
    return str(value).replace('\n', ' ').replace('\r', ' ')

def export_table(model, filename, db_session):
    print(f"Exportando {model.__tablename__} → {filename}")
    try:
        records = db_session.query(model).all()
        if not records:
            print(f"  ⚠️  Tabla vacía")
            return

        columns = [col.name for col in model.__table__.columns]

        with open(filename, 'w', newline='', encoding='utf-8-sig') as f:
            writer = csv.DictWriter(f, fieldnames=columns, quoting=csv.QUOTE_MINIMAL)
            writer.writeheader()

            for record in records:
                row = {}
                for col in columns:
                    value = getattr(record, col, None)
                    row[col] = safe_serialize(value)
                writer.writerow(row)

        print(f"  ✅ {len(records)} registros exportados")
    except Exception as e:
        print(f"  ❌ Error al exportar {model.__tablename__}: {e}")

def validate_consistency(db_session):
    print("\n🔍 Validando consistencia referencial...")
    errors = []

    user_ids = set(r.id for r in db_session.query(User.id).all())
    clinic_ids = set(r.id for r in db_session.query(Clinic.id).all())
    assistant_ids = set(r.id for r in db_session.query(Assistant.id).all())
    appointment_ids = set(r.id for r in db_session.query(Appointment.id).all())
    product_category_ids = set(r.id for r in db_session.query(ProductCategory.id).all())
    publication_ids = set(r.id for r in db_session.query(Publication.id).all())

    for user in db_session.query(User).filter(User.role_id.isnot(None)):
        if not db_session.query(UserRole).filter(UserRole.id == user.role_id).first():
            errors.append(f"User {user.id}: role_id {user.role_id} no existe")

    for clinic in db_session.query(Clinic):
        if clinic.doctor_id not in user_ids:
            errors.append(f"Clinic {clinic.id}: doctor_id {clinic.doctor_id} no existe")

    for a in db_session.query(Assistant):
        if a.doctor_id not in user_ids:
            errors.append(f"Assistant {a.id}: doctor_id {a.doctor_id} no existe")
        if a.clinic_id and a.clinic_id not in clinic_ids:
            errors.append(f"Assistant {a.id}: clinic_id {a.clinic_id} no existe")
        if a.user_id and a.user_id not in user_ids:
            errors.append(f"Assistant {a.id}: user_id {a.user_id} no existe")

    for appt in db_session.query(Appointment):
        if appt.patient_id not in user_ids:
            errors.append(f"Appointment {appt.id}: patient_id {appt.patient_id} no existe")

    for mr in db_session.query(MedicalRecord):
        if mr.patient_id not in user_ids:
            errors.append(f"MedicalRecord {mr.id}: patient_id {mr.patient_id} no existe")
        if mr.doctor_id not in user_ids:
            errors.append(f"MedicalRecord {mr.id}: doctor_id {mr.doctor_id} no existe")
        if mr.appointment_id and mr.appointment_id not in appointment_ids:
            errors.append(f"MedicalRecord {mr.id}: appointment_id {mr.appointment_id} no existe")

    for t in db_session.query(Task):
        if t.doctor_id not in user_ids:
            errors.append(f"Task {t.id}: doctor_id {t.doctor_id} no existe")
        if t.assistant_id not in assistant_ids:
            errors.append(f"Task {t.id}: assistant_id {t.assistant_id} no existe")
        if t.clinic_id and t.clinic_id not in clinic_ids:
            errors.append(f"Task {t.id}: clinic_id {t.clinic_id} no existe")

    for p in db_session.query(Product):
        if p.doctor_id not in user_ids:
            errors.append(f"Product {p.id}: doctor_id {p.doctor_id} no existe")
        if p.category_id and p.category_id not in product_category_ids:
            errors.append(f"Product {p.id}: category_id {p.category_id} no existe")

    for e in db_session.query(Event):
        if e.doctor_id not in user_ids:
            errors.append(f"Event {e.id}: doctor_id {e.doctor_id} no existe")
        if e.clinic_id and e.clinic_id not in clinic_ids:
            errors.append(f"Event {e.id}: clinic_id {e.clinic_id} no existe")
        if e.publication_id and e.publication_id not in publication_ids:
            errors.append(f"Event {e.id}: publication_id {e.publication_id} no existe")

    for a in db_session.query(Anuncio):
        if a.profesional_id not in user_ids:
            errors.append(f"Anuncio {a.id}: profesional_id {a.profesional_id} no existe")

    if errors:
        print("  ❌ Errores encontrados:")
        for err in errors:
            print(f"    - {err}")
    else:
        print("  ✅ Todos los datos son consistentes")

    return len(errors) == 0

def main():
    os.environ["FLASK_ENV"] = "development"
    app = create_app()

    with app.app_context():
        from app import db

        if not validate_consistency(db.session):
            print("\n🛑 Corrige los errores antes de exportar.")
            sys.exit(1)

        tables = [
            (UserRole, "user_roles.csv"),
            (User, "users.csv"),
            (Clinic, "clinic.csv"),
            (Assistant, "assistants.csv"),
            (Availability, "availability.csv"),
            (Appointment, "appointments.csv"),
            (MedicalRecord, "medical_records.csv"),
            (Schedule, "schedules.csv"),
            (Note, "notes.csv"),
            (Publication, "publications.csv"),
            (Task, "tasks.csv"),
            (Subscriber, "subscribers.csv"),
            (CompanyInvite, "company_invites.csv"),
            (InvitationLog, "invitation_logs.csv"),
            (Visit, "visits.csv"),
            (ProductCategory, "product_category.csv"),
            (Product, "product.csv"),
            (Event, "event.csv"),
            (Anuncio, "anuncios.csv"),
        ]

        os.makedirs("exported_data", exist_ok=True)
        for model, filename in tables:
            export_table(model, f"exported_data/{filename}", db.session)

        print("\n🎉 Exportación completada en ./exported_data/")

if __name__ == "__main__":
    main()