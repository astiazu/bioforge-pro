import os
import csv
from sqlalchemy.exc import IntegrityError, DataError
from sqlalchemy import inspect, text
from app.models import db

# Define la ruta del directorio de importación
IMPORT_DIR = "exported_data"

# Verifica que el directorio exista
if not os.path.exists(IMPORT_DIR):
    raise FileNotFoundError(f"El directorio de importación no existe: {IMPORT_DIR}")


def validate_foreign_keys(csv_data, foreign_key_column, referenced_ids):
    """
    Valida que los valores de una columna de clave foránea en los datos CSV
    coincidan con los IDs existentes en la tabla referenciada.
    """
    invalid_keys = []
    for row in csv_data:
        fk_value = row.get(foreign_key_column)
        if fk_value and fk_value != '' and int(fk_value) not in referenced_ids:
            invalid_keys.append(fk_value)

    if invalid_keys:
        raise ValueError(f"❌ Claves foráneas inválidas en '{foreign_key_column}': {set(invalid_keys)}")


def get_existing_ids(table_name):
    """
    Obtiene todos los IDs existentes de una tabla.
    """
    try:
        # Usa SQLAlchemy para generar consultas seguras
        result = db.session.execute(text("SELECT id FROM :table"), {"table": table_name})
        return {row[0] for row in result}
    except Exception as e:
        print(f"⚠️ No se pudieron obtener IDs de {table_name}: {e}")
        return set()


def import_csv_to_model(csv_path, model, skip_id=False, foreign_key_validations=None):
    """
    Importa datos desde un archivo CSV a una tabla específica del modelo.
    
    Args:
        csv_path: Ruta al archivo CSV
        model: Clase del modelo SQLAlchemy
        skip_id: Si True, no importa la columna 'id'
        foreign_key_validations: Dict con {columna: tabla_referenciada}
    """
    if not os.path.exists(csv_path):
        print(f"⚠️ Archivo CSV no encontrado: {csv_path}")
        return

    with open(csv_path, "r", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        rows = list(reader)

        if not rows:
            print(f"⚠️ Archivo CSV vacío: {csv_path}")
            return

        # Validar claves foráneas si se especifican
        if foreign_key_validations:
            for fk_column, referenced_table in foreign_key_validations.items():
                if fk_column in rows[0]:
                    referenced_ids = get_existing_ids(referenced_table)
                    validate_foreign_keys(rows, fk_column, referenced_ids)

        count = 0
        errors = 0

        for idx, row in enumerate(rows, 1):
            try:
                cleaned = {}
                for key, value in row.items():
                    # Saltar ID si se especifica
                    if key == "id" and skip_id:
                        continue

                    # Valores vacíos
                    if value == "" or value is None:
                        cleaned[key] = None
                    # Claves foráneas
                    elif key.endswith("_id"):
                        cleaned[key] = int(value) if str(value).strip().isdigit() else None
                    # Campos booleanos
                    elif key.startswith("is_") or key in ["active", "enabled", "verified"]:
                        cleaned[key] = str(value).strip().lower() in ("1", "true", "t", "yes", "on", "sí", "si")
                    # Campos numéricos
                    elif key in ["day_of_week", "duration", "amount", "price", "stock"]:
                        cleaned[key] = int(value) if str(value).strip().isdigit() else None
                    else:
                        cleaned[key] = value.strip() if isinstance(value, str) else value

                obj = model(**cleaned)
                db.session.add(obj)
                count += 1

                # Commit cada 100 registros para evitar problemas de memoria
                if count % 100 == 0:
                    db.session.commit()
                    print(f"  → Procesados {count} registros...")

            except (ValueError, IntegrityError, DataError) as e:
                errors += 1
                print(f"❌ Error en fila {idx} de {csv_path}: {str(e)[:100]}")
                db.session.rollback()
                continue

        # Commit final
        try:
            db.session.commit()
            print(f"✅ Importado: {count} registros en {model.__tablename__} (Errores: {errors})")
        except Exception as e:
            print(f"❌ Error al hacer commit final en {model.__tablename__}: {e}")
            db.session.rollback()


def truncate_tables_safely():
    """
    Vacía las tablas de forma segura deshabilitando temporalmente las foreign keys.
    """
    print("🗑️ Vaciando tablas...")

    # Orden inverso para respetar dependencias
    TABLES_TO_CLEAR = [
        "event",
        "notes",
        "publications",
        "medical_records",
        "appointments",
        "availability",
        "schedules",  # ← AGREGADA
        "tasks",
        "assistants",
        "product",
        "product_category",
        "clinic",
        "user_roles",
        "visits",
        "invitation_logs",
        "company_invites",
        "subscribers",
    ]

    try:
        # Deshabilitar temporalmente las foreign keys (PostgreSQL)
        db.session.execute(text("SET CONSTRAINTS ALL DEFERRED;"))

        for table in TABLES_TO_CLEAR:
            try:
                db.session.execute(text(f"TRUNCATE TABLE {table} RESTART IDENTITY CASCADE;"))
                print(f"  ✓ Tabla {table} vaciada")
            except Exception as e:
                print(f"  ⚠️ No se pudo vaciar {table}: {str(e)[:80]}")

        db.session.commit()
        print("✅ Tablas vaciadas exitosamente")

    except Exception as e:
        print(f"❌ Error al vaciar tablas: {e}")
        db.session.rollback()
        raise


def import_csv_to_render_db():
    """
    Importa datos desde múltiples archivos CSV a la base de datos.
    """
    print("=" * 60)
    print("🚀 INICIANDO IMPORTACIÓN DE DATOS A PRODUCCIÓN")
    print("=" * 60)

    # Asegurar que las tablas existen (sin intentar crearlas manualmente)
    print("📋 Verificando estructura de base de datos...")
    db.create_all()
    print("✅ Estructura verificada")

    # Vaciar tablas existentes
    truncate_tables_safely()

    # Definir orden de importación con validaciones de FK
    IMPORT_CONFIG = [
        ("users", None, False),
        ("user_roles", {"user_id": "users"}, False),
        ("clinic", {"doctor_id": "users"}, False),
        ("product_category", None, False),
        ("assistants", {"user_id": "users", "doctor_id": "users"}, False),
        ("schedules", {"doctor_id": "users", "clinic_id": "clinic"}, False),
        ("tasks", {"doctor_id": "users"}, False),
        ("availability", {"doctor_id": "users"}, False),
        ("appointments", {"patient_id": "users", "doctor_id": "users"}, False),
        ("medical_records", {"patient_id": "users", "doctor_id": "users"}, False),
        ("publications", None, False),
        ("notes", None, False),
        ("event", None, False),
        ("subscribers", None, False),
        ("company_invites", None, False),
        ("invitation_logs", None, True),  # skip_id = True
        ("visits", None, True),  # skip_id = True
        ("product", {"category_id": "product_category"}, False),
    ]

    total_imported = 0

    for table_name, fk_validations, skip_id in IMPORT_CONFIG:
        csv_path = os.path.join(IMPORT_DIR, f"{table_name}.csv")

        if not os.path.exists(csv_path):
            print(f"\n⚠️ CSV no encontrado: {table_name}.csv - Saltando...")
            continue

        # Obtener el modelo dinámicamente
        model_class = None
        for key in dir(db.Model):
            obj = getattr(db.Model, key)
            if hasattr(obj, '__tablename__') and obj.__tablename__ == table_name:
                model_class = obj
                break

        if not model_class:
            # Intento alternativo: buscar en app.models
            try:
                from app import models
                model_class = getattr(models, table_name.capitalize(), None)
            except:
                pass

        if not model_class:
            print(f"\n⚠️ Modelo no encontrado para tabla '{table_name}' - Saltando...")
            continue

        print(f"\n📥 Importando {table_name}...")
        import_csv_to_model(csv_path, model_class, skip_id, fk_validations)
        total_imported += 1

    print("\n" + "=" * 60)
    print(f"🎉 IMPORTACIÓN COMPLETADA: {total_imported} tablas procesadas")
    print("=" * 60)


if __name__ == "__main__":
    try:
        import_csv_to_render_db()
    except Exception as e:
        print(f"\n💥 ERROR CRÍTICO: {e}")
        import traceback
        traceback.print_exc()