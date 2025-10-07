"""
sync_sequences.py
-----------------
Script definitivo para sincronizar secuencias PostgreSQL con los datos actuales de las tablas.
Previene errores de "llave duplicada" al insertar nuevos registros.
Guarda logs históricos en logs/sync_sequences.log
"""

import os
import sys
from datetime import datetime
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError

# Agregar carpeta raíz al path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import create_app, db

# Crear app y contexto
app = create_app()

# Carpeta de logs
LOG_DIR = os.path.join(os.path.dirname(__file__), '..', 'logs')
os.makedirs(LOG_DIR, exist_ok=True)
LOG_FILE = os.path.join(LOG_DIR, 'sync_sequences.log')

def log(msg, level="INFO"):
    """Logging en consola y archivo con timestamp"""
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    line = f"[{timestamp}] {level}: {msg}"
    print(line)
    try:
        with open(LOG_FILE, 'a', encoding='utf-8') as f:
            f.write(line + "\n")
    except Exception as e:
        print(f"[{timestamp}] ERROR: No se pudo escribir log en archivo: {e}")

def sync_sequences():
    with app.app_context():
        log("Iniciando sincronización de secuencias...")

        try:
            # Obtener todas las secuencias del esquema 'public'
            sequences = db.session.execute(
                text("""
                    SELECT sequence_name
                    FROM information_schema.sequences
                    WHERE sequence_schema = 'public';
                """)
            ).fetchall()
        except SQLAlchemyError as e:
            log(f"Error al obtener secuencias: {e}", "ERROR")
            return

        if not sequences:
            log("No se detectaron secuencias en el esquema 'public'", "WARNING")
            return

        log(f"Secuencias detectadas: {[seq[0] for seq in sequences]}")

        for seq_name, in sequences:
            if not seq_name.endswith('_id_seq'):
                log(f"Secuencia '{seq_name}' no sigue el formato esperado '_id_seq', se ignora", "WARNING")
                continue

            table_name = seq_name[:-7]  # elimina '_id_seq'

            try:
                # Obtener el ID máximo actual de la tabla
                max_id = db.session.execute(
                    text(f"SELECT COALESCE(MAX(id), 0) FROM {table_name}")
                ).scalar()

                next_id = max_id + 1

                # Ajustar secuencia para que el próximo insert sea seguro
                db.session.execute(
                    text(f"SELECT setval(:seq_name, :next_id, false)")
                    .bindparams(seq_name=seq_name, next_id=next_id)
                )

                log(f"Secuencia sincronizada: '{seq_name}' (tabla '{table_name}'), próximo ID: {next_id}")

            except SQLAlchemyError as e:
                log(f"Error sincronizando secuencia '{seq_name}' para tabla '{table_name}': {e}", "ERROR")
                db.session.rollback()  # Evitar abortar todas las demás secuencias
                continue

        try:
            db.session.commit()
            log("✅ Todas las secuencias procesadas y commit realizado correctamente")
        except SQLAlchemyError as e:
            log(f"Error al hacer commit final: {e}", "ERROR")
            db.session.rollback()

if __name__ == "__main__":
    sync_sequences()