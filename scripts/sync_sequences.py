# scripts/sync_sequences.py
from app import db
from sqlalchemy import text

def sync_all_sequences():
    tables = [
        "user_roles",
        "users",
        "subscribers",
        "clinic",
        "assistants",
        "schedules",
        "availability",
        "appointments",
        "medical_records",
        "tasks",
        "notes",
        "publications",
        "company_invites",
        "invitation_logs"
    ]

    print("🔄 Sincronizando secuencias de PostgreSQL...\n")

    for table in tables:
        try:
            result = db.session.execute(text(f"SELECT MAX(id) FROM {table}")).scalar()
            max_id = result if result is not None else 0
            seq_name = f"{table}_id_seq"
            db.session.execute(text(f"SELECT setval('{seq_name}', {max_id})"))
            print(f"✅ {table:20} → próximo ID: {max_id + 1}")
        except Exception as e:
            print(f"❌ Error en {table}: {e}")

    db.session.commit()
    print("\n✨ ¡Todas las secuencias están sincronizadas!")