import os
import csv
from datetime import datetime
from dateutil import parser as date_parser
from sqlalchemy import inspect
from app import db
from app.models import (
    User, Assistant, Clinic, Task, Note, Publication, Availability,
    Appointment, MedicalRecord, Schedule, UserRole, Subscriber,
    CompanyInvite, InvitationLog, Visit, Product, ProductCategory, Event
)

# === Configuración del Directorio de CSV ===
IMPORT_DIR = "BioForge/exported_data"

def import_csv_to_model(csv_path, model, skip_id=False):
    if not os.path.exists(csv_path):
        print(f"⚠️  No encontrado: {csv_path}")
        return

    with open(csv_path, "r", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        count = 0
        for row in reader:
            cleaned = {}
            for key, value in row.items():
                if key == "id" and skip_id:
                    continue  # Saltar el ID si se especifica
                if value == "" or value is None:
                    cleaned[key] = None
                elif key in ["id", "user_id", "doctor_id", "assistant_id", "clinic_id", "patient_id", "role_id"]:
                    cleaned[key] = int(value) if str(value).isdigit() else None
                elif key in ["is_active", "is_admin", "is_professional", "success"]:
                    cleaned[key] = str(value).strip().lower() in ("1", "true", "t", "yes", "on", "sí", "si")
                elif key in ["created_at", "updated_at", "due_date", "published_at", "expires_at", "used_at", "approved_at"]:
                    cleaned[key] = date_parser.parse(value) if value else None
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


def import_csv_to_render_db():
    inspector = inspect(db.engine)  # Inspector para verificar tablas
    existing_tables = inspector.get_table_names()  # Lista de tablas existentes

    print("🗑️  Vaciamos todas las tablas para sincronización limpia...")
    for table in reversed(db.metadata.sorted_tables):
        if table.name in existing_tables:
            print(f"  → Eliminando {table.name}...")
            db.session.execute(table.delete())
        else:
            print(f"  ⚠️ Tabla {table.name} no existe. Creándola...")
            table.create(bind=db.engine)  # Crea la tabla si no existe
    db.session.commit()
    print("✅ Todas las tablas vaciadas.")

    TARGET_TABLES = [
        "users",
        "assistants",
        "clinic",
        "tasks",
        "notes",
        "publications",
        "schedules",
        "availability",
        "appointments",
        "medical_records",
        "subscribers",
        "company_invites",
        "invitation_logs",
        "visits",
        "product",
        "product_category",
        "event"
    ]

    for table in TARGET_TABLES:
        csv_path = os.path.join(IMPORT_DIR, f"{table}.csv")
        if not os.path.exists(csv_path):
            print(f"  ⚠️ Archivo CSV para {table} no encontrado. Saltando...")
            continue

        model_class = globals().get(table.capitalize())
        if not model_class:
            print(f"  ⚠️ Modelo para {table} no encontrado. Saltando...")
            continue

        import_csv_to_model(csv_path, model_class, skip_id=(table in ["invitation_logs", "visits"]))

    print("🎉 Sincronización completada exitosamente.")