# wsgi.py
from app import create_app

try:
    application = create_app()
except Exception as e:
    print(f"Error al crear la aplicación: {e}")
    raise

if __name__ == "__main__":
    application.run()