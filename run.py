# run.py
from app import create_app

app = create_app()

if __name__ == "__main__":
    app.run(debug=True)

# from app import create_app
# import os

# app = create_app()

# print("\n" + "="*50)
# print("🔐 Variables de entorno cargadas:")
# print(f"SECRET_KEY: {'*' * len(os.getenv('SECRET_KEY', '')) if os.getenv('SECRET_KEY') else 'No definida'}")
# print(f"DATABASE_URL: {os.getenv('DATABASE_URL')}")
# print(f"DEBUG: {os.getenv('DEBUG')}")
# print(f"FLASK_APP: {os.getenv('FLASK_APP')}")
# print("="*50 + "\n")

# # run.py

# print("\n" + "="*50)
# print("🔧 Directorio actual:", os.getcwd())
# print("🔧 Template folder:", app.template_folder)
# print("🔧 Static folder:", app.static_folder)
# print("🔧 Instance path:", app.instance_path)
# print("="*50 + "\n")

# if __name__ == "__main__":
#     app.run(debug=True)

