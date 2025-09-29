# scripts/fix_assistants_clinic.py

import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import create_app, db
from app.models import Assistant

app = create_app()
app.app_context().push()

# Emails de Mabel y Emiliano
MABEL_EMAIL = 'macalu1966@gmail.com'
EMILIANO_EMAIL = 'emiliano@gmail.com'

# 1. Asignar clinic_id = 1 a Mabel y Emiliano (si clinic_id es NULL)
updated_mabel_emiliano = Assistant.query.filter(
    Assistant.clinic_id.is_(None),
    Assistant.email.in_([MABEL_EMAIL, EMILIANO_EMAIL])
).update({"clinic_id": 1}, synchronize_session=False)

# 2. Asignar clinic_id = 3 a todos los demás con clinic_id NULL
# (incluye los que tienen email NULL o vacío, y los que no son Mabel/Emiliano)
updated_others = Assistant.query.filter(
    Assistant.clinic_id.is_(None)
).filter(
    ~Assistant.email.in_([MABEL_EMAIL, EMILIANO_EMAIL]) | Assistant.email.is_(None) | (Assistant.email == '')
).update({"clinic_id": 3}, synchronize_session=False)

db.session.commit()

print(f"✅ Actualizados {updated_mabel_emiliano} asistentes a clinic_id = 1 (Mabel y Emiliano)")
print(f"✅ Actualizados {updated_others} asistentes a clinic_id = 3 (todos los demás)")
print("✅ Corrección de clinic_id completada.")