# run.py
import os
from dotenv import load_dotenv
from app import create_app
from flask_cors import CORS

# Carga variables de entorno desde .env
load_dotenv()

app = create_app()
CORS(app)  # Habilita CORS para la aplicación completa

if __name__ == '__main__':
    app.run(debug=True)
    

