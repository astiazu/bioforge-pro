# debug_db.py - Notes
from app import create_app
from app.models import Note

app = create_app()

with app.app_context():
    print("\n" + "="*50)
    print("🔍 NOTAS EN LA BASE DE DATOS")
    print("="*50)
    for note in Note.query.all():
        print(f"ID: {note.id} | Título: {note.title} | Status: {note.status} | Type: {type(note.status)}")
    print("="*50)