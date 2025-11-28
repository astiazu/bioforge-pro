import os
from datetime import datetime, timedelta
from flask import current_app
from app.models import User, Anuncio, db

class ServicioAnuncios:
    
    @staticmethod
    def generar_anuncios_desde_profesionales_destacados():
        """Genera anuncios automáticamente desde profesionales destacados"""
        profesionales_destacados = User.query.filter_by(
            is_professional=True,
            es_destacado=True
        ).order_by(User.prioridad_anuncio.desc()).all()
        
        # ✅ USAR LAS POSICIONES QUE LOS TEMPLATES ESPERAN
        posiciones_disponibles = ["header", "sidebar", "intermedio", "inarticle", "clients"]
        
        anuncios_creados = 0
        for index, prof in enumerate(profesionales_destacados):
            imagen_anuncio = prof.banner_anuncio or prof.logo_profesional or prof.profile_photo
            if not imagen_anuncio:
                continue
                
            anuncio_existente = Anuncio.query.filter_by(
                profesional_id=prof.id,
                esta_activo=True
            ).first()
            
            if not anuncio_existente:
                # ✅ ASIGNAR POSICIÓN CORRECTA
                posicion_asignada = posiciones_disponibles[index % len(posiciones_disponibles)]
                
                anuncio = Anuncio(
                    profesional_id=prof.id,
                    imagen_url=imagen_anuncio,
                    titulo=f"Consulta con Dr. {prof.username}",
                    descripcion=prof.bio or f"Especialista en {prof.specialty} - {prof.years_experience or 'Varios'} años de experiencia",
                    url_destino=f"/profesional/{prof.url_slug or f'profesional-{prof.id}'}",
                    posicion=posicion_asignada,  # ✅ POSICIÓN CORRECTA
                    esta_activo=True,
                    orden_visualizacion=prof.prioridad_anuncio,
                    expira_en=datetime.utcnow() + timedelta(days=30)
                )
                db.session.add(anuncio)
                anuncios_creados += 1
            else:
                # Actualizar anuncio existente con posición correcta
                anuncio_existente.imagen_url = imagen_anuncio
                anuncio_existente.titulo = f"Consulta con Profesional de {prof.username}"
                anuncio_existente.descripcion = prof.bio or f"Especialista en {prof.specialty}"
                anuncio_existente.orden_visualizacion = prof.prioridad_anuncio
                # ✅ ACTUALIZAR TAMBIÉN LA POSICIÓN SI ES "rotatorio"
                if anuncio_existente.posicion == "rotatorio":
                    nueva_posicion = posiciones_disponibles[index % len(posiciones_disponibles)]
                    anuncio_existente.posicion = nueva_posicion
                    print(f"🔄 Anuncio {anuncio_existente.id} actualizado a posición: {nueva_posicion}")
        
        db.session.commit()
        return anuncios_creados
    
    @staticmethod
    def obtener_anuncios_activos(limite=10, posicion=None):
        """Obtiene anuncios activos para mostrar"""
        query = Anuncio.query.filter_by(esta_activo=True)
        
        if posicion:
            query = query.filter_by(posicion=posicion)
            
        return query.order_by(
            Anuncio.orden_visualizacion.desc(),
            Anuncio.creado_en.desc()
        ).limit(limite).all()
    
    @staticmethod
    def desactivar_anuncios_profesional(profesional_id):
        """Desactiva todos los anuncios de un profesional"""
        anuncios = Anuncio.query.filter_by(profesional_id=profesional_id).all()
        for anuncio in anuncios:
            anuncio.esta_activo = False
        db.session.commit()
        return len(anuncios)
    
    @staticmethod
    def registrar_clic(anuncio_id):
        """Registra un clic en el anuncio"""
        anuncio = Anuncio.query.get(anuncio_id)
        if anuncio:
            anuncio.contador_clics += 1
            db.session.commit()
    
    @staticmethod
    def registrar_impresion(anuncio_id):
        """Registra una impresión del anuncio"""
        anuncio = Anuncio.query.get(anuncio_id)
        if anuncio:
            anuncio.contador_impresiones += 1
            db.session.commit()
    
    @staticmethod
    def obtener_rendimiento_anuncios():
        """Obtiene métricas de rendimiento de anuncios"""
        return db.session.query(
            Anuncio.id,
            Anuncio.titulo,
            Anuncio.contador_clics,
            Anuncio.contador_impresiones,
            Anuncio.posicion,  # ✅ AGREGAR ESTE CAMPO
            User.username
        ).join(User).filter(
            Anuncio.esta_activo == True
        ).all()