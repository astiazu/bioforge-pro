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

def import_csv_to_model(csv_path, model, skip_id=False, foreign_key_validations=None, strict_mode=True):
    """
    Importa datos desde un archivo CSV a una tabla específica del modelo.
    
    Args:
        csv_path: Ruta al archivo CSV
        model: Clase del modelo SQLAlchemy
        skip_id: Si True, no importa la columna 'id'
        foreign_key_validations: Dict con {columna: tabla_referenciada}
        strict_mode: Si False, omite registros con FK inválidas en lugar de fallar
    """
    if not os.path.exists(csv_path):
        print(f"⚠️ Archivo CSV no encontrado: {csv_path}")
        return 0

    with open(csv_path, "r", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        rows = list(reader)

        if not rows:
            print(f"⚠️ Archivo CSV vacío: {csv_path}")
            return 0

        # VALIDACIONES DE FK DESHABILITADAS
        # PostgreSQL se encargará de validar la integridad
        # if foreign_key_validations:
        #     for fk_column, referenced_table in foreign_key_validations.items():
        #         if fk_column in rows[0]:
        #             referenced_ids = get_existing_ids(referenced_table)
        #             rows = validate_foreign_keys(rows, fk_column, referenced_ids, strict_mode)
        #             
        #             if not rows:
        #                 print(f"⚠️ No hay registros válidos después de validar {fk_column}")
        #                 return 0

        count = 0
        errors = 0
        
        for idx, row in enumerate(rows, 1):
            try:
                cleaned = {}
                for key, value in row.items():
                    # Saltar ID si se especifica
                    if key == "id" and skip_id:
                        continue
                    
                    # Normalizar el valor (convertir string "None" a None real)
                    if isinstance(value, str):
                        value = value.strip()
                        if value.lower() == 'none' or value == '':
                            value = None
                    
                    # Valores vacíos
                    if value is None:
                        cleaned[key] = None
                    # Claves foráneas
                    elif key.endswith("_id"):
                        cleaned[key] = int(value) if str(value).strip().isdigit() else None
                    # Campos booleanos (TODOS los casos posibles)
                    elif (key.startswith("is_") or 
                          key.endswith("_enabled") or 
                          key.endswith("_included") or
                          key in ["active", "enabled", "verified", "has_tax_included", "store_enabled"]):
                        cleaned[key] = str(value).strip().lower() in ("1", "true", "t", "yes", "on", "sí", "si")
                    # Campos numéricos
                    elif key in ["day_of_week", "duration", "amount", "price", "stock", "view_count"]:
                        cleaned[key] = int(value) if str(value).strip().isdigit() else None
                    # Campos decimales
                    elif key in ["base_price", "tax_rate", "promotion_discount"]:
                        try:
                            cleaned[key] = float(value) if value else None
                        except (ValueError, TypeError):
                            cleaned[key] = None
                    # Campos JSON (como image_urls)
                    elif key == "image_urls" and value:
                        # Ya viene como string JSON del CSV, mantenerlo así
                        cleaned[key] = value
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
                print(f"❌ Error en fila {idx} de {csv_path}: {str(e)[:150]}")
                db.session.rollback()
                continue

        # Commit final
        try:
            db.session.commit()
            print(f"✅ Importado: {count} registros en {model.__tablename__} (Errores: {errors})")
            return count
        except Exception as e:
            print(f"❌ Error al hacer commit final en {model.__tablename__}: {e}")
            db.session.rollback()
            return 0

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
    
    # Asegurar que las tablas existen
    print("📋 Verificando estructura de base de datos...")
    db.create_all()
    print("✅ Estructura verificada")
    
    # Vaciar tablas existentes
    truncate_tables_safely()
    
    # Definir orden de importación SIN validaciones de FK
    # Las validaciones las hace PostgreSQL automáticamente
    IMPORT_CONFIG = [
        ("users", None, False),
        ("user_roles", None, False),
        ("clinic", None, False),
        ("product_category", None, False),
        ("assistants", None, False),
        ("schedules", None, False),
        ("tasks", None, False),
        ("availability", None, False),
        ("appointments", None, False),
        ("medical_records", None, False),
        ("publications", None, False),
        ("notes", None, False),
        ("event", None, False),
        ("subscribers", None, False),
        ("company_invites", None, False),
        ("invitation_logs", None, True),  # skip_id = True
        ("visits", None, True),  # skip_id = True
        ("product", None, False),
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