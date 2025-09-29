# scripts/fix_tasks_clinic.py

import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import create_app, db
from app.models import Task

app = create_app()
app.app_context().push()

# Asignar clinic_id = 3 a todas las tareas que no lo tengan
updated = Task.query.filter(Task.clinic_id.is_(None)).update({"clinic_id": 3})

db.session.commit()

print(f"✅ Actualizadas {updated} tareas: ahora todas tienen clinic_id = 3")