# scripts/export_fixtures.py
import json
import os
import sys
from datetime import datetime, date  # ← IMPORTANTE: añadir 'date'

# Asegurar que el directorio raíz esté en el path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__ + "/../")))

from app import create_app
from app.models import *

def export_fixtures():
    app = create_app()
    with app.app_context():
        data = {}

        models_and_names = [
            (UserRole, "user_roles"),
            (User, "users"),
            (Subscriber, "subscribers"),
            (Clinic, "clinic"),
            (Assistant, "assistants"),
            (Schedule, "schedules"),
            (Availability, "availability"),
            (Appointment, "appointments"),
            (MedicalRecord, "medical_records"),
            (Task, "tasks"),
            (Note, "notes"),
            (Publication, "publications"),
            (CompanyInvite, "company_invites"),
            (InvitationLog, "invitation_logs")
        ]

        for model, name in models_and_names:
            records = []
            for obj in model.query.all():
                record = {}
                for column in model.__table__.columns:
                    value = getattr(obj, column.name)
                    # Convertir fechas y otros tipos no serializables
                    if isinstance(value, datetime):
                        value = value.isoformat()
                    elif isinstance(value, date):  # ← manejar date
                        value = value.isoformat()
                    record[column.name] = value
                records.append(record)
            data[name] = records

        with open("fixtures.json", "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2, ensure_ascii=False)

        print("✅ fixtures.json generado con éxito.")

if __name__ == "__main__":
    export_fixtures()