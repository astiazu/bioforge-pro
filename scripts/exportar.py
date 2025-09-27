import os
import json
from datetime import datetime
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

# === Configura la conexión a Render ===
DATABASE_URL = "postgresql://bioforgepro_db_user:8APUeBHQJXXFiweFQVwm0z07WiuxfC5x@dpg-d340ghffte5s73ebv2og-a.oregon-postgres.render.com/bioforgepro_db?sslmode=require"

if DATABASE_URL.startswith("postgresql://"):
    DATABASE_URL = DATABASE_URL.replace("postgresql://", "postgresql+psycopg2://", 1)

engine = create_engine(DATABASE_URL, echo=False)
Session = sessionmaker(bind=engine)
session = Session()

# === Tablas que queremos exportar (según tus modelos locales) ===
TARGET_TABLES = [
    'users',
    'notes',
    'publications',
    'note_statuses',
    'clinic',
    'availabilities',
    'appointments',
    'medical_records',
    'schedules',
    'user_roles',
    'subscribers',
    'assistants',
    'tasks',
    'task_statuses',
    'company_invites'
]

# Normalizamos: permitimos singular o plural en la DB
def normalize_table_name(name):
    """Convierte a singular para comparar (ej: 'notes' → 'note')"""
    if name.endswith('ies'):
        return name[:-3] + 'y'
    elif name.endswith('es'):
        return name[:-2]
    elif name.endswith('s'):
        return name[:-1]
    return name

try:
    # Verificar conexión
    result = session.execute(text("SELECT version();"))
    print(f"✅ Conectado a: {result.fetchone()[0]}")

    # Obtener tablas reales en Render
    result = session.execute(text("""
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema='public' AND table_type='BASE TABLE'
    """))
    render_tables = {row[0].lower() for row in result}
    print(f"📋 Tablas en Render: {sorted(render_tables)}")

    # Leer JSON existente (si existe)
    existing_data = {}
    if os.path.exists('data_from_render.json'):
        with open('data_from_render.json', 'r', encoding='utf-8') as f:
            try:
                existing_data = json.load(f)
            except json.JSONDecodeError:
                print("⚠️  JSON anterior corrupto. Se creará uno nuevo.")

    # Inicializar nuevo JSON
    data = {
        "export_date": datetime.utcnow().isoformat(),
        "tables_exported": [],
        "tables_missing": [],
        **existing_data
    }

    # Función para exportar una tabla
    def export_table(table_name):
        try:
            result = session.execute(text(f"SELECT * FROM {table_name}"))
            keys = list(result.keys())
            rows = [dict(zip(keys, row)) for row in result]
            return rows
        except Exception as e:
            print(f"❌ Error al exportar '{table_name}': {e}")
            return None

    # Intentar exportar cada tabla objetivo
    for table in TARGET_TABLES:
        found = False
        # Buscar coincidencia exacta
        if table in render_tables:
            rows = export_table(table)
            if rows is not None:
                data[table] = rows
                data["tables_exported"].append(table)
                found = True
        else:
            # Buscar versión singular
            singular = normalize_table_name(table)
            candidates = [t for t in render_tables if normalize_table_name(t) == singular]
            if candidates:
                actual_table = candidates[0]
                rows = export_table(actual_table)
                if rows is not None:
                    data[table] = rows  # Guardamos con nombre canónico (plural)
                    data["tables_exported"].append(table)
                    found = True

        if not found:
            print(f"⚠️  Tabla '{table}' no encontrada en Render (¿aún no desplegada?)")
            data["tables_missing"].append(table)

    # Guardar JSON
    with open('data_from_render.json', 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, default=str, ensure_ascii=False)

    print("\n🎉 ¡Exportación completada!")
    print(f"✅ Tablas exportadas: {len(data['tables_exported'])}")
    print(f"❌ Tablas faltantes: {len(data['tables_missing'])}")
    if data['tables_missing']:
        print("   → " + ", ".join(data['tables_missing']))

except Exception as e:
    print(f"❌ Error general: {e}")
finally:
    session.close()