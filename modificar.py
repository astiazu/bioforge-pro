from app import create_app, db
from app.models import Assistant, Clinic

app = create_app()
with app.app_context():
    for assistant in Assistant.query.filter(Assistant.clinic_id.is_(None)).all():
        # Asigna el primer consultorio del médico
        clinic = Clinic.query.filter_by(doctor_id=assistant.doctor_id).first()
        if clinic:
            assistant.clinic_id = clinic.id
            print(f"Asignado {assistant.name} → {clinic.name}")
    
    db.session.commit()
    print("✅ Todos los asistentes actualizados")