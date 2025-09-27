from datetime import datetime, timedelta
from app import create_app, db
from app.models import Task

app = create_app()

with app.app_context():
    # Fecha base: 1 de septiembre de 2025
    base_date = datetime(2025, 9, 1, 8, 0, 0)  # 01/09/2025 08:00:00

    tasks = Task.query.filter(Task.created_at.is_(None)).all()

    if not tasks:
        print("✅ Todas las tareas ya tienen 'created_at'. Nada que actualizar.")
    else:
        print(f"📦 Actualizando {len(tasks)} tareas...")

        for i, task in enumerate(tasks):
            # Asignar fechas crecientes (una cada 30 minutos)
            task.created_at = base_date + timedelta(minutes=30 * i)
            db.session.add(task)
            print(f"✅ Tarea '{task.title}' -> {task.created_at}")

        db.session.commit()
        print(f"🎉 Listo. Se actualizaron {len(tasks)} tareas con 'created_at'.")