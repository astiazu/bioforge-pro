# debug_db.py
from app import create_app
from app.models import Publication

app = create_app()

with app.app_context():
    print("\n" + "="*50)
    print("🔍 PUBLICACIONES EN LA DB")
    print("="*50)
    for pub in Publication.query.all():
        print(f"ID: {pub.id} | Título: {pub.title}")
        print(f"  is_published: {pub.is_published}")
        print(f"  published_at: {pub.published_at}")
        print(f"  created_at: {pub.created_at}")
        print("  " + "-"*40)
    print("="*50)