# app/import_script.py
# Nueva copia del archivo app/import_script.py

import os
import csv
from datetime import datetime
from sqlalchemy.exc import IntegrityError, DataError
from sqlalchemy import inspect, text
from app.models import db

# Define la ruta del directorio de importación
IMPORT_DIR = "exported_data"
# Verifica que el directorio exista
if not os.path.exists(IMPORT_DIR):
    raise FileNotFoundError(f"El directorio de importación no existe: {IMPORT_DIR}")

# ⭐ CONSTRUIR MAPEO AUTOMÁTICAMENTE
def build_model_map():
    """
    Construye un mapeo de nombres de tabla a clases de modelo automáticamente.
    """
    model_map = {}
    
    # Iterar sobre todas las tablas registradas en SQLAlchemy
    for table_name, table in db.metadata.tables.items():
        # Buscar la clase de modelo correspondiente
        for mapper in db.Model.registry.mappers:
            if mapper.mapped_table.name == table_name:
                model_map[table_name] = mapper.class_
                break
    
    return model_map

MODEL_MAP = build_model_map()

print(f"📋 Modelos detectados: {list(MODEL_MAP.keys())}")

def preview_csv_contents(csv_path):
    """
    Muestra una vista previa del contenido de un archivo CSV.
    """
    if not os.path.exists(csv_path):
        print(f"⚠️ Archivo CSV no encontrado: {csv_path}")
        return []
    
    try:
        with open(csv_path, "r", encoding="utf-8-sig") as f:
            reader = csv.DictReader(f)
            rows = list(reader)
            
            if not rows:
                print(f"⚠️ Archivo CSV vacío: {csv_path}")
                return []
            
            print(f"\n📋 Contenido del archivo: {csv_path}")
            print(f"   • Columnas: {reader.fieldnames}")
            print(f"   • Total de registros: {len(rows)}")
            print("   • Primeras 5 filas:")
            for i, row in enumerate(rows[:5], 1):
                print(f"     {i}: {row}")
            
            return rows
    except Exception as e:
        print(f"❌ Error al leer el archivo CSV: {e}")
        return []

def validate_foreign_keys(csv_data, foreign_key_column, referenced_ids, strict_mode=True):
    """
    Valida que los valores de una columna de clave foránea en los datos CSV
    coincidan con los IDs existentes en la tabla referenciada.
    
    Args:
        csv_data: Lista de diccionarios con los datos del CSV
        foreign_key_column: Nombre de la columna de clave foránea
        referenced_ids: Set de IDs válidos en la tabla referenciada
        strict_mode: Si True, lanza excepción. Si False, filtra registros inválidos.
    
    Returns:
        Lista de datos validados (puede estar filtrada si strict_mode=False)
    """
    invalid_keys = []
    valid_rows = []
    invalid_rows = []
    
    for row in csv_data:
        fk_value = row.get(foreign_key_column)
        
        # Si el valor está vacío, es válido (NULL permitido)
        if not fk_value or fk_value == '':
            valid_rows.append(row)
            continue
        
        # Verificar si el ID existe
        try:
            fk_int = int(fk_value)
            if fk_int in referenced_ids:
                valid_rows.append(row)
            else:
                invalid_keys.append(fk_value)
                invalid_rows.append(row)
        except ValueError:
            invalid_keys.append(fk_value)
            invalid_rows.append(row)
    
    if invalid_keys:
        message = f"⚠️ Claves foráneas inválidas en '{foreign_key_column}': {set(invalid_keys)} ({len(invalid_rows)} registros)"
        
        if strict_mode:
            raise ValueError(f"❌ {message}")
        else:
            print(f"   {message} - OMITIENDO registros inválidos")
            return valid_rows
    
    return csv_data

def get_existing_ids(table_name):
    """
    Obtiene todos los IDs existentes de una tabla.
    """
    try:
        result = db.session.execute(text(f"SELECT id FROM {table_name}"))
        return {row[0] for row in result}
    except Exception as e:
        print(f"⚠️ No se pudieron obtener IDs de {table_name}: {e}")
        return set()

def import_csv_to_model(csv_path, model, skip_id=False, foreign_key_validations=None, strict_mode=False):
    rows = preview_csv_contents(csv_path)
    if not rows:
        return 0

    # Validar claves foráneas
    if foreign_key_validations:
        for fk_column, referenced_table in foreign_key_validations.items():
            if fk_column in rows[0]:
                referenced_ids = get_existing_ids(referenced_table)
                rows = validate_foreign_keys(rows, fk_column, referenced_ids, strict_mode)
                
                if not rows:
                    print(f"⚠️ No hay registros válidos después de validar {fk_column}")
                    return 0

    def clean_value(key, value):
        if isinstance(value, str):
            value = value.strip()
            if value.lower() == 'none' or value == '':
                return None
        elif key.endswith("_id"):
            return int(value) if str(value).strip().isdigit() else None
        elif key.startswith("is_") or key.endswith("_enabled"):
            return str(value).strip().lower() in ("true", "1", "yes")
        elif key in ["created_at", "updated_at"]:
            try:
                return datetime.strptime(value, "%Y-%m-%d %H:%M:%S.%f")
            except ValueError:
                return None
        return value.strip() if isinstance(value, str) else value

    count = 0
    failed_rows = []
    for row in rows:
        try:
            cleaned = {}
            for key, value in row.items():
                if key == "id" and skip_id:
                    continue
                cleaned[key] = clean_value(key, value)

                # Validar campos obligatorios
                if key in ["name", "email"] and not cleaned[key]:
                    raise ValueError(f"❌ Campo obligatorio '{key}' está vacío en la fila: {row}")

            obj = model(**cleaned)
            db.session.add(obj)
            count += 1

            # Commit cada 100 registros
            if count % 100 == 0:
                db.session.commit()
                print(f"  → Procesados {count} registros...")
        except Exception as e:
            failed_rows.append(row)
            print(f"❌ Error al procesar fila {row}: {str(e)[:150]}")
            db.session.rollback()
            continue

    # Commit final para los registros restantes
    db.session.commit()
    print(f"✅ Importación completada para {model.__tablename__} ({count} registros)")

    if failed_rows:
        print(f"⚠️ Filas fallidas: {len(failed_rows)}")
        # Guardar las filas fallidas en un archivo o log para revisión posterior
        
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
        "schedules",
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
        "users",  # Usuario al final
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

def import_csv_to_render_db(strict_mode=True):
    """
    Importa datos desde múltiples archivos CSV a la base de datos.
    
    Args:
        strict_mode: Si True, falla ante FK inválidas. Si False, omite registros inválidos.
    """
    print("=" * 60)
    print("🚀 INICIANDO IMPORTACIÓN DE DATOS A PRODUCCIÓN")
    print(f"   Modo: {'ESTRICTO' if strict_mode else 'PERMISIVO'}")
    print("=" * 60)
    
    # Asegurar que las tablas existan
    print("📋 Verificando estructura de base de datos...")
    db.create_all()
    print("✅ Estructura verificada")
    
    # Vaciar tablas existentes
    truncate_tables_safely()
    
    # Definir orden de importación con validaciones de FK
    IMPORT_CONFIG = [
        ("user_roles", None, False),  # Importar primero user_roles
        ("users", {"role_id": "user_roles"}, False),
        ("clinic", {"doctor_id": "users"}, False),
        ("assistants", {"user_id": "users", "doctor_id": "users"}, False),
        ("tasks", {"doctor_id": "users", "assistant_id": "assistants"}, False),
        ("schedules", {"doctor_id": "users", "clinic_id": "clinic"}, False),
        ("medical_records", {"patient_id": "users", "doctor_id": "users"}, False),
        ("publications", {"user_id": "users"}, False),
        ("notes", None, False),
        ("event", None, False),
        ("subscribers", None, False),
        ("company_invites", None, False),
        ("invitation_logs", None, True),  # skip_id = True
        ("visits", None, True),  # skip_id = True
        ("product", {"category_id": "product_category"}, False),
    ]
    
    total_imported = 0
    total_records = 0
    
    for table_name, fk_validations, skip_id in IMPORT_CONFIG:
        csv_path = os.path.join(IMPORT_DIR, f"{table_name}.csv")
        
        if not os.path.exists(csv_path):
            print(f"\n⚠️ CSV no encontrado: {table_name}.csv - Saltando...")
            continue
        
        # Obtener el modelo del mapeo
        model_class = MODEL_MAP.get(table_name)
        
        if not model_class:
            print(f"\n⚠️ Modelo no encontrado para tabla '{table_name}' - Saltando...")
            continue
        
        print(f"\n📥 Importando {table_name}...")
        records = import_csv_to_model(csv_path, model_class, skip_id, fk_validations, strict_mode)
        
        if records > 0:
            total_imported += 1
            total_records += records
    
    print("\n" + "=" * 60)
    print(f"🎉 IMPORTACIÓN COMPLETADA")
    print(f"   • Tablas procesadas: {total_imported}")
    print(f"   • Registros importados: {total_records}")
    print("=" * 60)

if __name__ == "__main__":
    import sys
    
    # Permitir modo permisivo con argumento --permissive
    strict = "--permissive" not in sys.argv
    
    try:
        import_csv_to_render_db(strict_mode=strict)
    except Exception as e:
        print(f"\n💥 ERROR CRÍTICO: {e}")
        import traceback
        traceback.print_exc()