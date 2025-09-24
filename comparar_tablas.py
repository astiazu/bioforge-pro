# scripts/comparar_tablas.py
import os
import sys
from app import create_app, db
from sqlalchemy import text

# === Configuración de Render ===
RENDER_DB_URL = "postgresql://bioforgepro_db_user:8APUeBHQJXXFiweFQVwm0z07WiuxfC5x@dpg-d340ghffte5s73ebv2og-a.oregon-postgres.render.com/bioforgepro_db?sslmode=require"

def get_local_tables():
    app = create_app()
    with app.app_context():
        result = db.session.execute(text("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';"))
        return {row[0] for row in result}

def get_render_tables():
    from sqlalchemy import create_engine
    from sqlalchemy.orm import sessionmaker
    url = RENDER_DB_URL.replace("postgresql://", "postgresql+psycopg2://", 1)
    engine = create_engine(url, echo=False)
    Session = sessionmaker(bind=engine)
    session = Session()
    try:
        result = session.execute(text("""
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema='public' AND table_type='BASE TABLE'
        """))
        return {row[0] for row in result}
    finally:
        session.close()

def main():
    print("🔍 Comparando tablas entre Local (SQLite) y Render (PostgreSQL)...\n")
    
    local = get_local_tables()
    render = get_render_tables()

    print(f"✅ Tablas en LOCAL: {sorted(local)}\n")
    print(f"☁️  Tablas en RENDER: {sorted(render)}\n")

    only_local = local - render
    only_render = render - local
    common = local & render

    if only_local:
        print(f"⚠️  Tablas solo en LOCAL (¿faltan en Render?): {sorted(only_local)}")
    if only_render:
        print(f"⚠️  Tablas solo en RENDER (¿faltan en local?): {sorted(only_render)}")
    if common:
        print(f"✅ Tablas comunes: {len(common)}")

    print("\n💡 Recomendación:")
    if only_render:
        print("- Actualizá tu modelo local para incluir las tablas nuevas de Render.")
    if only_local:
        print("- Deployá los cambios de modelo a Render para sincronizar.")

if __name__ == '__main__':
    main()