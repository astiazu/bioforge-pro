from flask import Blueprint, render_template, request, jsonify, flash, redirect, url_for
from flask_login import login_required, current_user
from app.models import User, Anuncio, db
from app.services.servicio_anuncios import ServicioAnuncios

admin_anuncios = Blueprint('admin_anuncios', __name__, url_prefix='/admin/anuncios')

@admin_anuncios.route('/toggle-destacado/<int:user_id>', methods=['POST'])
@login_required
def toggle_destacado(user_id):
    if not current_user.is_admin:
        return jsonify({'success': False, 'message': 'No autorizado'}), 403
    
    profesional = User.query.get_or_404(user_id)
    profesional.es_destacado = not profesional.es_destacado
    
    if profesional.es_destacado:
        # Generar anuncio automáticamente
        ServicioAnuncios.generar_anuncios_desde_profesionales_destacados()
        message = f'✅ {profesional.username} ahora es destacado y aparecerá en anuncios'
    else:
        # Desactivar anuncios
        ServicioAnuncios.desactivar_anuncios_profesional(profesional.id)
        message = f'❌ {profesional.username} ya no es destacado'
    
    db.session.commit()
    return jsonify({'success': True, 'message': message})

@admin_anuncios.route('/actualizar-prioridad/<int:user_id>', methods=['POST'])
@login_required
def actualizar_prioridad(user_id):
    if not current_user.is_admin:
        return jsonify({'success': False, 'message': 'No autorizado'}), 403
    
    profesional = User.query.get_or_404(user_id)
    prioridad = request.json.get('prioridad', 0)
    
    profesional.prioridad_anuncio = prioridad
    db.session.commit()
    
    # Actualizar anuncios existentes
    ServicioAnuncios.generar_anuncios_desde_profesionales_destacados()
    
    return jsonify({'success': True, 'message': 'Prioridad actualizada'})

@admin_anuncios.route('/generar-anuncios', methods=['POST'])
@login_required
def generar_anuncios():
    if not current_user.is_admin:
        return jsonify({'success': False, 'message': 'No autorizado'}), 403
    
    anuncios_creados = ServicioAnuncios.generar_anuncios_desde_profesionales_destacados()
    
    return jsonify({
        'success': True, 
        'message': f'Se generaron/actualizaron {anuncios_creados} anuncios'
    })

@admin_anuncios.route('/')
@login_required
def gestion_anuncios():
    if not current_user.is_admin:
        flash('No tienes permisos para acceder a esta sección', 'error')
        return redirect(url_for('main.index'))
    
    professionals = User.query.filter_by(is_professional=True).order_by(User.username).all()
    anuncios_activos = Anuncio.query.filter_by(esta_activo=True).all()
    
    # Contar anuncios por profesional
    for prof in professionals:
        prof.anuncios_count = Anuncio.query.filter_by(
            profesional_id=prof.id, 
            esta_activo=True
        ).count()
    
    # Calcular total de clics
    total_clics = db.session.query(db.func.sum(Anuncio.contador_clics)).scalar() or 0
    
    return render_template('admin/anuncios.html',
                         professionals=professionals,
                         anuncios_activos=anuncios_activos,
                         total_clics=total_clics)

@admin_anuncios.route('/rendimiento')
@login_required
def rendimiento_anuncios():
    if not current_user.is_admin:
        return jsonify({'success': False, 'message': 'No autorizado'}), 403
    
    rendimiento = ServicioAnuncios.obtener_rendimiento_anuncios()
    
    # Calcular métricas
    total_anuncios = len(rendimiento)
    total_impresiones = sum(item.contador_impresiones for item in rendimiento)
    total_clics = sum(item.contador_clics for item in rendimiento)
    ctr_global = (total_clics / total_impresiones * 100) if total_impresiones > 0 else 0
    
    # Métricas por posición
    metricas_por_posicion = {}
    for item in rendimiento:
        # ✅ MANEJAR POSICIONES NULAS O VACÍAS
        posicion = item.posicion or 'sin-posicion'
        if posicion not in metricas_por_posicion:
            metricas_por_posicion[posicion] = {
                'anuncios': 0,
                'impresiones': 0,
                'clics': 0,
                'ctr': 0
            }
        
        metricas_por_posicion[posicion]['anuncios'] += 1
        metricas_por_posicion[posicion]['impresiones'] += item.contador_impresiones
        metricas_por_posicion[posicion]['clics'] += item.contador_clics
    
    # Calcular CTR por posición
    for posicion, datos in metricas_por_posicion.items():
        datos['ctr'] = (datos['clics'] / datos['impresiones'] * 100) if datos['impresiones'] > 0 else 0
    
    return render_template('admin/rendimiento_anuncios.html', 
                         rendimiento=rendimiento,
                         total_anuncios=total_anuncios,
                         total_impresiones=total_impresiones,
                         total_clics=total_clics,
                         ctr_global=ctr_global,
                         metricas_por_posicion=metricas_por_posicion)