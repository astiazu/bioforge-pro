"""
Script para reiniciar completamente el sistema de migraciones.
Útil cuando hay errores persistentes en Alembic.
"""
import os
import shutil
from pathlib import Path

# Configuración
PROJECT_ROOT = Path(__file__).parent
MIGRATIONS_FOLDER = PROJECT_ROOT / "migrations"
DATABASE_FILE = PROJECT_ROOT / "portfolio.db"
ALEMBIC_VERSION_TABLE = "alembic_version"

def confirm_action():
    """Pide confirmación antes de borrar archivos."""
    print("\n" + "="*60)
    print("⚠️  ADVERTENCIA: Este script BORRARÁ:")
    print(f"   - La base de datos: {DATABASE_FILE}")
    print(f"   - Todas las migraciones anteriores en: {MIGRATIONS_FOLDER}/versions/")
    print("   (Se mantendrá la estructura de carpetas y env.py)")
    print("="*60)
    
    confirm = input("\n¿Continuar? (s/N): ").lower().strip()
    return confirm in ['s', 'si', 'y', 'yes']

def reset_database():
    """Elimina la base de datos si existe."""
    if DATABASE_FILE.exists():
        DATABASE_FILE.unlink()
        print(f"✅ Borrado: {DATABASE_FILE}")
    else:
        print(f"ℹ️  No encontrado: {DATABASE_FILE}")

def reset_migrations_folder():
    """Limpia las migraciones anteriores pero mantiene la estructura."""
    versions_folder = MIGRATIONS_FOLDER / "versions"
    
    if not MIGRATIONS_FOLDER.exists():
        print("❌ Carpeta 'migrations' no encontrada. Debes ejecutar 'flask db init' primero.")
        return False
    
    # Borrar solo los archivos .py dentro de versions/
    if versions_folder.exists():
        for file in versions_folder.glob("*.py"):
            if file.name != "env.py":  # No borrar env.py
                file.unlink()
                print(f"🗑️  Borrado: {file}")
    
    print("✅ Carpetas de migraciones limpias")
    return True

def create_initial_migration():
    """Genera una nueva migración inicial."""
    print("\n🚀 Generando nueva migración inicial...")
    os.system("flask db migrate -m \"Migración inicial después de reinicio\"")
    return (MIGRATIONS_FOLDER / "versions").exists() and len(list((MIGRATIONS_FOLDER / "versions").glob("*.py"))) > 0

def apply_migration():
    """Aplica la migración a la base de datos."""
    print("\n🔥 Aplicando migración a la base de datos...")
    result = os.system("flask db upgrade")
    if result == 0:
        print("✅ Base de datos actualizada correctamente")
        return True
    else:
        print("❌ Error al aplicar la migración")
        return False

def validate_models():
    """Verifica que los modelos se puedan cargar sin errores."""
    print("\n🔍 Validando modelos de SQLAlchemy...")
    try:
        from app import create_app
        app = create_app()
        with app.app_context():
            from app.models import User, Clinic, Assistant, Task  # Importa todos tus modelos
            print("✅ Todos los modelos se cargaron correctamente")
            return True
    except Exception as e:
        print(f"❌ Error al cargar modelos: {e}")
        return False

def main():
    if not confirm_action():
        print("🚫 Operación cancelada por el usuario.")
        return
    
    # Paso 1: Validar modelos
    if not validate_models():
        print("❌ No se puede continuar. Corrige los errores en los modelos primero.")
        return
    
    # Paso 2: Borrar base de datos
    reset_database()
    
    # Paso 3: Limpiar migraciones
    if not reset_migrations_folder():
        return
    
    # Paso 4: Crear nueva migración
    if not create_initial_migration():
        print("❌ No se pudo crear la migración inicial.")
        return
    
    # Paso 5: Aplicar migración
    if not apply_migration():
        print("❌ No se pudo aplicar la migración. Revisa los modelos o la conexión.")
        return
    
    print("\n" + "🎉"*20)
    print("✅ ¡SISTEMA DE MIGRACIONES REINICIADO CON ÉXITO!")
    print("➡️  Puedes comenzar a desarrollar con confianza.")
    print("➡️  Recuerda: Haz una migración por cada cambio pequeño.")
    print("🎉"*20)

if __name__ == "__main__":
    main()