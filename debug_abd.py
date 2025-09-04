# debug_db.py para disponibilidad
from app import create_app
from app.models import Availability

app = create_app()

with app.app_context():
    print("\n" + "="*50)
    print("🔍 DISPONIBILIDAD EN LA DB")
    print("="*50)
    for a in Availability.query.all():
        print(f"ID: {a.id} | Clinic ID: {a.clinic_id} | Fecha: {a.date} | Hora: {a.time} | Ocupado: {a.is_booked}")
    print("="*50)