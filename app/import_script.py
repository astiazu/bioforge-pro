import os
import csv
from datetime import datetime
from dateutil import parser as date_parser
from sqlalchemy import inspect
from sqlalchemy.exc import IntegrityError, DataError
from app import db
from app.models import (
    User, Assistant, Clinic, Task, Note, Publication, Availability,
    Appointment, MedicalRecord, Schedule, UserRole, Subscriber,
    CompanyInvite, InvitationLog, Visit, Product, ProductCategory, Event
)

# === Configuración del Directorio de CSV ===
IMPORT_DIR = "exported_data"

def import_csv_to_model(csv_path, model, skip_id=False):
    if not os.path.exists(csv_path):
        print(f"⚠️ Archivo CSV no encontrado: {csv_path}")
        return

    with open(csv_path, "r", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        count = 0
        for row in reader:
            try:
                cleaned = {}
                for key, value in row.items():
                    if key == "id" and skip_id:
                        continue  # Saltar el ID si se especifica
                    if value == "" or value is None:
                        cleaned[key] = None
                    elif key.endswith("_id"):  # Claves foráneas
                        cleaned[key] = int(value) if str(value).isdigit() else None
                    elif key.startswith("is_"):  # Campos booleanos
                        cleaned[key] = str(value).strip().lower() in ("1", "true", "t", "yes", "on", "sí", "si")
                    else:
                        cleaned[key] = value

                obj = model(**cleaned)
                db.session.add(obj)
                count += 1
            except Exception as e:
                print(f"❌ Error al procesar fila {count + 1} en {csv_path}: {e}")
                db.session.rollback()
                continue

        db.session.commit()
        print(f"✅ Importado: {count} registros en {model.__tablename__}")
        
def import_csv_to_render_db():
    print("🗑️ Vaciamos todas las tablas para sincronización limpia...")
    inspector = inspect(db.engine)
    existing_tables = inspector.get_table_names()

    for table in reversed(db.metadata.sorted_tables):
        if table.name in existing_tables:
            print(f"  → Eliminando {table.name}...")
            db.session.execute(table.delete())
        else:
            print(f"  ⚠️ Tabla {table.name} no existe. Creándola...")
            table.create(bind=db.engine)
    db.session.commit()
    print("✅ Todas las tablas vaciadas.")

    TARGET_TABLES = [
        "users",            # 1. Tabla independiente
        "user_roles",       # 2. Tabla independiente
        "clinic",           # 3. Depende de users
        "product_category", # 4. Depende de users
        "assistants",       # 5. Depende de users y clinic
        "tasks",            # 6. Depende de users y assistants
        "availability",     # 7. Depende de clinic
        "appointments",     # 8. Depende de users y availability
        "medical_records",  # 9. Depende de users y appointments
        "publications",     # 10. Depende de users
        "notes",            # 11. Depende de users
        "event",            # 12. Depende de users y clinic
        "subscribers",      # 13. Tabla independiente
        "company_invites",  # 14. Depende de users y clinic
        "invitation_logs",  # 15. Depende de users
        "visits",           # 16. Tabla independiente
        "product"           # 17. Depende de product_category y users
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