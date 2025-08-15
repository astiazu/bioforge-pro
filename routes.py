import os
import pandas as pd
import json
from datetime import datetime
from flask import render_template, request, redirect, url_for, flash, jsonify, session
from flask_login import current_user, login_required
from werkzeug.utils import secure_filename
from app import app, db
from models import User, Note, Publication, NoteStatus, UserRole
from replit_auth import require_login, require_admin, make_replit_blueprint

# Bio data
BIO_SHORT = "📊 Consultor freelance en Analítica de Datos y Sistemas • Formador en Python y BI • Certificado Google Data Analytics • Transformo datos en decisiones."

BIO_EXTENDED = """
Soy José Luis Astiazu, consultor independiente en análisis de datos, big data y sistemas.
Especialista en Python, Django, automatización de procesos y visualización de datos.
Certificado en Google Data Analytics. Me apasiona simplificar lo complejo y acompañar a mis clientes en todo el ciclo: desde la captura y limpieza de datos hasta la presentación de resultados claros y accionables.
📍 Mina Clavero, Córdoba – Argentina.
"""

# Publications data
PUBLICATIONS = [
    {
        "type": "Educativo",
        "title": "El error más común al analizar datos (y cómo evitarlo)",
        "content": "Muchos creen que el análisis de datos empieza en la visualización, pero la base está en la limpieza y preparación..."
    },
    {
        "type": "Caso de éxito",
        "title": "Cómo un dashboard redujo el tiempo de reportes en un 40%",
        "content": "Un cliente de retail necesitaba reportes semanales que le tomaban horas. Con un dashboard en Python + Power BI logramos..."
    },
    {
        "type": "Autoridad técnica",
        "title": "3 razones para aprender Python si trabajás con datos",
        "content": "1️⃣ Sintaxis clara 2️⃣ Librerías potentes 3️⃣ Comunidad enorme..."
    }
]

# Register authentication blueprint
app.register_blueprint(make_replit_blueprint(), url_prefix="/auth")

# Make session permanent
@app.before_request
def make_session_permanent():
    session.permanent = True

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in {'csv'}

@app.route('/')
def index():
    return render_template('index.html', 
                         bio_short=BIO_SHORT, 
                         bio_extended=BIO_EXTENDED,
                         active_tab='home')

@app.route('/publications')
def publications():
    # Get published notes and database publications
    published_notes = Note.query.filter_by(status=NoteStatus.PUBLISHED).order_by(Note.approved_at.desc()).all()
    db_publications = Publication.query.filter_by(is_published=True).order_by(Publication.published_at.desc()).all()
    
    # Combine static publications with database ones
    all_publications = PUBLICATIONS + [
        {
            'type': pub.type,
            'title': pub.title,
            'content': pub.excerpt or pub.content[:200] + '...',
            'id': pub.id,
            'is_db': True
        } for pub in db_publications
    ]
    
    return render_template('publications.html', 
                         publications=all_publications,
                         published_notes=published_notes,
                         bio_short=BIO_SHORT, 
                         bio_extended=BIO_EXTENDED,
                         active_tab='publications')

@app.route('/portfolio')
def portfolio():
    return render_template('portfolio.html',
                         bio_short=BIO_SHORT, 
                         bio_extended=BIO_EXTENDED,
                         active_tab='portfolio')

@app.route('/notes', methods=['GET', 'POST'])
@require_login
def notes():
    if request.method == 'POST':
        title = request.form.get('title', '').strip()
        content = request.form.get('content', '').strip()
        
        if not title or not content:
            flash('Por favor completa el título y contenido de la nota', 'error')
            return redirect(url_for('notes'))
            
        # Create new note
        note = Note()
        note.title = title
        note.content = content
        note.user_id = current_user.id
        note.status = NoteStatus.PRIVATE
        db.session.add(note)
        db.session.commit()
        flash('✅ Nota creada exitosamente', 'success')
        return redirect(url_for('notes'))
    
    # Get user's notes
    user_notes = Note.query.filter_by(user_id=current_user.id).order_by(Note.created_at.desc()).all()
    
    return render_template('notes.html',
                         user_notes=user_notes,
                         bio_short=BIO_SHORT, 
                         bio_extended=BIO_EXTENDED,
                         active_tab='notes')

@app.route('/data-analysis', methods=['GET', 'POST'])
def data_analysis():
    return render_template('data_analysis.html',
                         bio_short=BIO_SHORT, 
                         bio_extended=BIO_EXTENDED,
                         active_tab='data_analysis')

@app.route('/upload-csv', methods=['POST'])
def upload_csv():
    try:
        if 'file' not in request.files:
            return jsonify({'error': 'No file selected'}), 400
        
        file = request.files['file']
        if file.filename == '':
            return jsonify({'error': 'No file selected'}), 400
        
        if not allowed_file(file.filename):
            return jsonify({'error': 'Please upload a CSV file'}), 400
        
        # Read CSV directly from memory
        file.seek(0)  # Reset file pointer
        df = pd.read_csv(file.stream)
        
        # Basic data info
        info = {
            'columns': df.columns.tolist(),
            'shape': df.shape,
            'dtypes': df.dtypes.astype(str).to_dict(),
            'preview': df.head(10).to_dict('records'),
            'missing_values': df.isnull().sum().to_dict()
        }
        
        # Store dataframe in session for analysis
        session['csv_data'] = df.to_json()
        
        return jsonify(info)
    
    except Exception as e:
        app.logger.error(f"Error processing CSV: {str(e)}")
        return jsonify({'error': f'Error processing file: {str(e)}'}), 500

@app.route('/analyze-data', methods=['POST'])
def analyze_data():
    try:
        if 'csv_data' not in session:
            return jsonify({'error': 'No data available. Please upload a CSV file first.'}), 400
        
        # Restore dataframe from session
        df = pd.read_json(session['csv_data'])
        
        data = request.get_json()
        chart_type = data.get('chart_type', 'scatter')
        x_column = data.get('x_column')
        y_column = data.get('y_column')
        
        if not x_column or not y_column:
            return jsonify({'error': 'Please select both X and Y columns'}), 400
        
        if x_column not in df.columns or y_column not in df.columns:
            return jsonify({'error': 'Selected columns not found in data'}), 400
        
        # Prepare data for Chart.js
        chart_data = {
            'labels': df[x_column].astype(str).tolist()[:100],  # Limit to first 100 points
            'datasets': [{
                'label': f'{y_column} vs {x_column}',
                'data': df[y_column].fillna(0).tolist()[:100],
                'borderColor': 'rgb(75, 192, 192)',
                'backgroundColor': 'rgba(75, 192, 192, 0.2)',
                'tension': 0.1
            }]
        }
        
        # For scatter plots, format data differently
        if chart_type == 'scatter':
            chart_data['datasets'][0]['data'] = [
                {'x': x, 'y': y} for x, y in zip(
                    df[x_column].fillna(0).tolist()[:100], 
                    df[y_column].fillna(0).tolist()[:100]
                )
            ]
        
        return jsonify({
            'chart_data': chart_data,
            'chart_type': chart_type,
            'title': f'{y_column} vs {x_column}'
        })
    
    except Exception as e:
        app.logger.error(f"Error analyzing data: {str(e)}")
        return jsonify({'error': f'Error analyzing data: {str(e)}'}), 500

# Admin routes for publications
@app.route('/admin/publication/new', methods=['GET', 'POST'])
@require_admin
def new_publication():
    if request.method == 'POST':
        title = request.form.get('title', '').strip()
        content = request.form.get('content', '').strip()
        pub_type = request.form.get('type', '').strip()
        excerpt = request.form.get('excerpt', '').strip()
        tags = request.form.get('tags', '').strip()
        
        if not title or not content or not pub_type:
            flash('Por favor completa todos los campos requeridos', 'error')
            return render_template('edit_publication.html', 
                               publication=None,
                               bio_short=BIO_SHORT, 
                               bio_extended=BIO_EXTENDED)
        
        publication = Publication()
        publication.title = title
        publication.content = content
        publication.type = pub_type
        publication.excerpt = excerpt
        publication.tags = tags
        publication.user_id = current_user.id
        publication.is_published = True
        publication.published_at = datetime.now()
        db.session.add(publication)
        db.session.commit()
        flash('✅ Publicación creada exitosamente', 'success')
        return redirect(url_for('admin_panel'))
    
    return render_template('edit_publication.html', 
                         publication=None,
                         bio_short=BIO_SHORT, 
                         bio_extended=BIO_EXTENDED)

@app.route('/admin/publication/<int:pub_id>/edit', methods=['GET', 'POST'])
@require_admin
def edit_publication(pub_id):
    publication = Publication.query.get_or_404(pub_id)
    
    if request.method == 'POST':
        publication.title = request.form.get('title', '').strip()
        publication.content = request.form.get('content', '').strip()
        publication.type = request.form.get('type', '').strip()
        publication.excerpt = request.form.get('excerpt', '').strip()
        publication.tags = request.form.get('tags', '').strip()
        
        if not publication.title or not publication.content or not publication.type:
            flash('Por favor completa todos los campos requeridos', 'error')
            return render_template('edit_publication.html', 
                               publication=publication,
                               bio_short=BIO_SHORT, 
                               bio_extended=BIO_EXTENDED)
        
        db.session.commit()
        flash('✅ Publicación actualizada exitosamente', 'success')
        return redirect(url_for('admin_panel'))
    
    return render_template('edit_publication.html', 
                         publication=publication,
                         bio_short=BIO_SHORT, 
                         bio_extended=BIO_EXTENDED)

@app.route('/admin/publication/<int:pub_id>/delete', methods=['POST'])
@require_admin
def delete_publication(pub_id):
    publication = Publication.query.get_or_404(pub_id)
    db.session.delete(publication)
    db.session.commit()
    flash('🗑️ Publicación eliminada exitosamente', 'info')
    return redirect(url_for('admin_panel'))

# Public view for individual publications and notes
@app.route('/publication/<int:pub_id>')
def view_publication(pub_id):
    publication = Publication.query.filter_by(id=pub_id, is_published=True).first_or_404()
    return render_template('view_publication.html', 
                         publication=publication,
                         bio_short=BIO_SHORT, 
                         bio_extended=BIO_EXTENDED)

@app.route('/note/<int:note_id>')
def view_note(note_id):
    note = Note.query.filter_by(id=note_id, status=NoteStatus.PUBLISHED).first_or_404()
    return render_template('view_note.html', 
                         note=note,
                         bio_short=BIO_SHORT, 
                         bio_extended=BIO_EXTENDED)

@app.route('/note/<int:note_id>/edit', methods=['GET', 'POST'])
@app.route('/note/new', methods=['GET', 'POST'])
@require_login
def edit_note(note_id=None):
    note = None
    if note_id and note_id != 0:
        note = Note.query.get_or_404(note_id)
    
    if note and not note.can_edit(current_user):
        flash('No tienes permisos para editar esta nota', 'error')
        return redirect(url_for('notes'))
    
    if request.method == 'POST':
        title = request.form.get('title', '').strip()
        content = request.form.get('content', '').strip()
        
        if not title or not content:
            flash('Por favor completa el título y contenido de la nota', 'error')
            return render_template('edit_note.html', note=note, bio_short=BIO_SHORT, bio_extended=BIO_EXTENDED)
        
        if note:
            # Update existing note
            note.title = title
            note.content = content
            db.session.commit()
            flash('✅ Nota actualizada exitosamente', 'success')
        else:
            # Create new note
            note = Note()
            note.title = title
            note.content = content
            note.user_id = current_user.id
            note.status = NoteStatus.PRIVATE
            db.session.add(note)
            db.session.commit()
            flash('✅ Nota creada exitosamente', 'success')
        return redirect(url_for('notes'))
    
    return render_template('edit_note.html', 
                         note=note,
                         bio_short=BIO_SHORT, 
                         bio_extended=BIO_EXTENDED)

@app.route('/note/<int:note_id>/delete', methods=['POST'])
@require_login
def delete_note(note_id):
    note = Note.query.get_or_404(note_id)
    
    if not note.can_edit(current_user):
        flash('No tienes permisos para eliminar esta nota', 'error')
        return redirect(url_for('notes'))
    
    db.session.delete(note)
    db.session.commit()
    flash('🗑️ Nota eliminada exitosamente', 'info')
    return redirect(url_for('notes'))

@app.route('/note/<int:note_id>/request-publish', methods=['POST'])
@require_login
def request_publish_note(note_id):
    note = Note.query.get_or_404(note_id)
    
    if note.user_id != current_user.id:
        flash('No tienes permisos para esta acción', 'error')
        return redirect(url_for('notes'))
    
    if note.status == NoteStatus.PUBLISHED:
        flash('Esta nota ya está publicada', 'info')
    elif note.status == NoteStatus.PENDING:
        flash('Esta nota ya está pendiente de aprobación', 'info')
    else:
        note.status = NoteStatus.PENDING
        db.session.commit()
        flash('📤 Solicitud de publicación enviada. Esperando aprobación del administrador.', 'success')
    
    return redirect(url_for('notes'))

@app.route('/admin')
@require_admin
def admin_panel():
    pending_notes = Note.query.filter_by(status=NoteStatus.PENDING).order_by(Note.created_at.desc()).all()
    published_notes = Note.query.filter_by(status=NoteStatus.PUBLISHED).order_by(Note.updated_at.desc()).limit(10).all()
    all_publications = Publication.query.order_by(Publication.updated_at.desc()).all()
    
    return render_template('admin.html',
                         pending_notes=pending_notes,
                         published_notes=published_notes,
                         all_publications=all_publications,
                         bio_short=BIO_SHORT, 
                         bio_extended=BIO_EXTENDED,
                         active_tab='admin')

@app.route('/admin/note/<int:note_id>/approve', methods=['POST'])
@require_admin
def approve_note(note_id):
    note = Note.query.get_or_404(note_id)
    
    note.status = NoteStatus.PUBLISHED
    note.approved_by = current_user.id
    note.approved_at = datetime.now()
    db.session.commit()
    
    flash(f'✅ Nota "{note.title}" aprobada y publicada', 'success')
    return redirect(url_for('admin_panel'))

@app.route('/admin/note/<int:note_id>/reject', methods=['POST'])
@require_admin
def reject_note(note_id):
    note = Note.query.get_or_404(note_id)
    
    note.status = NoteStatus.PRIVATE
    db.session.commit()
    
    flash(f'❌ Nota "{note.title}" rechazada y marcada como privada', 'info')
    return redirect(url_for('admin_panel'))
