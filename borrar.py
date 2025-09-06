from app import create_app, db

app = create_app()

with app.app_context():
    # Elimina la tabla alembic_version si existe
    db.engine.execute("DROP TABLE IF EXISTS alembic_version;")
    print("✅ Tabla alembic_version eliminada")