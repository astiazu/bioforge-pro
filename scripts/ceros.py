from app import create_app, db
from app.models import Publication

app = create_app()

with app.app_context():
    # Asegurar que todas las publicaciones tengan view_count = 0 si es None
    publications = Publication.query.filter(Publication.view_count.is_(None)).all()
    for pub in publications:
        pub.view_count = 0
    db.session.commit()
    print(f"✅ Se actualizaron {len(publications)} publicaciones con view_count = 0")