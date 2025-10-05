import os
import csv
from sqlalchemy import create_engine, MetaData, Table
from sqlalchemy.orm import sessionmaker

# === Configuración de la Base de Datos Local ===
LOCAL_DATABASE_URL = "postgresql://bioforge_user:mysecretpassword@localhost:5432/bioforge_dev"

engine = create_engine(LOCAL_DATABASE_URL)
Session = sessionmaker(bind=engine)
session = Session()

# Crear un objeto MetaData sin el argumento 'bind'
metadata = MetaData()

# Reflejar las tablas de la base de datos
metadata.reflect(bind=engine)

# === Directorio de Salida ===
EXPORT_DIR = "exported_data"
os.makedirs(EXPORT_DIR, exist_ok=True)

def export_table_to_csv(table_name):
    """
    Exporta una tabla específica a un archivo CSV.
    """
    try:
        # Obtener la tabla del objeto metadata
        table = metadata.tables[table_name]
        
        # Ejecutar consulta para obtener todos los registros
        result = session.execute(table.select())
        columns = table.columns.keys()

        # Crear el archivo CSV
        file_path = os.path.join(EXPORT_DIR, f"{table_name}.csv")
        with open(file_path, "w", newline="", encoding="utf-8") as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=columns)
            writer.writeheader()
            
            # Escribir cada fila en el archivo CSV
            for row in result:
                row_dict = {column: getattr(row, column) for column in columns}
                writer.writerow(row_dict)

        print(f"✅ Exportado: {table_name} → {file_path}")
    
    except KeyError:
        print(f"⚠️ Tabla no encontrada: {table_name}")
    except Exception as e:
        print(f"❌ Error al exportar {table_name}: {str(e)}")

# === Tablas a Exportar ===
TARGET_TABLES = [
    "users",
    "user_roles",  # Añadida la tabla user_roles
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

# === Exportar Todas las Tablas ===
for table in TARGET_TABLES:
    export_table_to_csv(table)

print("🎉 Exportación completada exitosamente.")