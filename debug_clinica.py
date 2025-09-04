#debug_clinicas.py para consultorios
from app import create_app
from app.models import Clinic

app = create_app()

with app.app_context():
    print("\n" + "="*50)
    print("🔍 CONSULTORIOS EN LA DB")
    print("="*50)
    for c in Clinic.query.all():
        print(f"ID: {c.id} | Nombre: {c.name} | Doctor ID: {c.doctor_id}")
    print("="*50)