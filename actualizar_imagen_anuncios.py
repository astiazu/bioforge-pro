from app.models import Anuncio
from app import db

# Lista de posiciones que usan los templates
posiciones_template = ["header", "sidebar", "intermedio", "inarticle", "clients"]

# Obtener todos los anuncios
anuncios = Anuncio.query.all()

print("🔄 Actualizando posiciones de anuncios...")
for i, anuncio in enumerate(anuncios):
    nueva_posicion = posiciones_template[i % len(posiciones_template)]
    anuncio.posicion = nueva_posicion
    print(f"  ✅ Anuncio {anuncio.id}: '{anuncio.titulo[:30]}...' -> posición '{nueva_posicion}'")

db.session.commit()
print(f"🎉 {len(anuncios)} anuncios actualizados correctamente")

# Verificar los cambios
print("\n📊 Verificación final:")
for anuncio in Anuncio.query.all():
    print(f"  - Anuncio {anuncio.id}: {anuncio.posicion}")