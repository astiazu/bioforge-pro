# create_availability.py
from app import create_app, db
from app.models import Clinic, Availability
from datetime import date, time

app = create_app()

with app.app_context():
    # Obtener un consultorio (el primero)
    clinic = Clinic.query.first()
    if not clinic:
        print("❌ No hay consultorios. Crea uno primero en el panel del médico.")
    else:
        print(f"✅ Usando consultorio: {clinic.name} (ID: {clinic.id})")

        # Fechas y horarios de prueba
        disponibilidad = [
            (date(2025, 4, 12), time(9, 0)),
            (date(2025, 4, 12), time(9, 30)),
            (date(2025, 4, 12), time(10, 0)),
            (date(2025, 4, 12), time(10, 30)),
            (date(2025, 4, 13), time(15, 0)),
            (date(2025, 4, 13), time(15, 30)),
            (date(2025, 4, 13), time(16, 0)),
        ]

        for fecha, hora in disponibilidad:
            # Evitar duplicados
            exists = Availability.query.filter_by(
                clinic_id=clinic.id,
                date=fecha,
                time=hora
            ).first()
            if not exists:
                avail = Availability(
                    clinic_id=clinic.id,
                    date=fecha,
                    time=hora,
                    is_booked=False
                )
                db.session.add(avail)  # ✅ Ahora dentro del 'if'
                print(f"✅ Añadido: {fecha} a las {hora}")

        db.session.commit()

