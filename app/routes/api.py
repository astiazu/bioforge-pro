from app.services.servicio_anuncios import ServicioAnuncios

@api.route('/anuncios/<int:anuncio_id>/clic', methods=['POST'])
def registrar_clic_anuncio(anuncio_id):
    ServicioAnuncios.registrar_clic(anuncio_id)
    return jsonify({'success': True})

@api.route('/anuncios/<int:anuncio_id>/impresion', methods=['POST'])
def registrar_impresion_anuncio(anuncio_id):
    ServicioAnuncios.registrar_impresion(anuncio_id)
    return jsonify({'success': True})