from flask_bcrypt import Bcrypt

bcrypt = Bcrypt()

# Hash de la contraseña almacenada en la base de datos
#stored_hash ="$2b$12$EixZa54olQW3tqz9v0JrXeTn8gCf1cBw6pK7kLmN9yZxY8jKlMnOwS"  # Reemplaza con tu hash real
stored_hash = "$2b$12$EixZa54olQW3tqz9v0JrXeTn8gCf1cBw6pK7kLmN9yZxY8jKlMnOwS"  # Reemplaza con tu hash real"
# Contraseña que intentaste usar

password_to_check = "admin123"

# Verifica si coinciden
if bcrypt.check_password_hash(stored_hash, password_to_check):
    print("La contraseña es válida.")
else:
    print("La contraseña no coincide.")