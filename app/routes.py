# app/routes.py
import os
import uuid
import pandas as pd
import json
import time
from uuid import uuid4
from datetime import datetime, timedelta
from collections import defaultdict
from flask import (render_template, request, redirect, url_for, flash, jsonify, session, Blueprint, current_app, abort, send_from_directory)
from functools import wraps
from flask_login import current_user, login_required
from werkzeug.utils import secure_filename
from app.models import User, Note, Publication, NoteStatus, Clinic, Availability, Appointment, MedicalRecord, Schedule, UserRole, Subscriber
from app import db, mail
from flask_mail import Message

import re
import chardet

# Carpeta para archivos temporales
UPLOAD_FOLDER = 'temp_csv'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

def generar_slug_unico(base_slug):
    from app.models import User  # ✅ Importación segura
    slug = re.sub(r'[^a-z0-9-]+', '-', base_slug.lower())
    slug = re.sub(r'-+', '-', slug).strip('-')
    original_slug = slug
    counter = 1
    while User.query.filter_by(url_slug=slug).first():
        slug = f"{original_slug}-{counter}"
        counter += 1
    return slug

def enviar_confirmacion_turno(appointment):
    try:
        msg = Message(
            subject="✅ Confirmación de turno médico",
            recipients=[appointment.patient.email],
            body=f"""
        Hola {appointment.patient.username},
        Tu turno ha sido reservado con éxito:
        🔹 Médico: {appointment.availability.clinic.doctor.username}
        🔹 Consultorio: {appointment.availability.clinic.name}
        🔹 Dirección: {appointment.availability.clinic.address}
        🔹 Fecha: {appointment.availability.date.strftime('%d/%m/%Y')}
        🔹 Hora: {appointment.availability.time.strftime('%H:%M')}
        Gracias por usar nuestra plataforma.
        ¡Te esperamos!
        Saludos,
        Equipo de Salud Digital
        """.strip(),
        html=f"""
        <h2>✅ Confirmación de turno</h2>
        <p>Hola <strong>{appointment.patient.username}</strong>,</p>
        <p>Tu turno ha sido reservado con éxito:</p>
        <ul>
            <li><strong>Médico:</strong> {appointment.availability.clinic.doctor.username}</li>
            <li><strong>Consultorio:</strong> {appointment.availability.clinic.name}</li>
            <li><strong>Dirección:</strong> {appointment.availability.clinic.address}</li>
            <li><strong>Fecha:</strong> {appointment.availability.date.strftime('%d/%m/%Y')}</li>
            <li><strong>Hora:</strong> {appointment.availability.time.strftime('%H:%M')}</li>
        </ul>
        <p>Gracias por usar nuestra plataforma.<br>
        ¡Te esperamos!</p>
        <p>Saludos,<br>
        <strong>Equipo de Salud Digital</strong></p>
        """.strip()
        )
        mail.send(msg)
        return True
    except Exception as e:
        print(f"❌ Error al enviar email: {str(e)}")
        return False

routes = Blueprint("routes", __name__)

def enviar_notificacion_turno_reservado(appointment):
    """
    Notifica al admin y al profesional cuando se reserva un turno
    """
    try:
        msg = Message(
            subject="🔔 Nuevo turno reservado",
            recipients=["astiazu@gmail.com"],  # Cambia por tu email de admin
            body=f"""
        Nuevo turno reservado:

        Paciente: {appointment.patient.username}
        Email: {appointment.patient.email}

        Profesional: {appointment.availability.clinic.doctor.username}
        Consultorio: {appointment.availability.clinic.name}
        Dirección: {appointment.availability.clinic.address}
        Fecha: {appointment.availability.date.strftime('%d/%m/%Y')}
        Hora: {appointment.availability.time.strftime('%H:%M')}

        Este mensaje fue generado automáticamente por el sistema.
                    """.strip(),
                    html=f"""
        <h2>🔔 Nuevo turno reservado</h2>
        <p><strong>Paciente:</strong> {appointment.patient.username}</p>
        <p><strong>Email:</strong> {appointment.patient.email}</p>
        <hr>
        <p><strong>Profesional:</strong> {appointment.availability.clinic.doctor.username}</p>
        <p><strong>Consultorio:</strong> {appointment.availability.clinic.name}</p>
        <p><strong>Dirección:</strong> {appointment.availability.clinic.address}</p>
        <p><strong>Fecha:</strong> {appointment.availability.date.strftime('%d/%m/%Y')}</p>
        <p><strong>Hora:</strong> {appointment.availability.time.strftime('%H:%M')}</p>
        <p><em>Este mensaje fue generado automáticamente por el sistema.</em></p>
                    """
        )
        mail.send(msg)
        return True
    except Exception as e:
        current_app.logger.error(f"Error al enviar notificación de turno: {str(e)}")
        return False

def enviar_notificacion_profesional(appointment):
    """
    Envía una notificación al profesional cuando se reserva un turno
    """
    try:
        msg = Message(
            subject=f"📅 Nuevo turno: {appointment.availability.date.strftime('%d/%m/%Y')} a las {appointment.availability.time.strftime('%H:%M')}",
            recipients=[appointment.availability.clinic.doctor.email],
            body=f"""
Hola {appointment.availability.clinic.doctor.username},

Has recibido una nueva reserva de turno:

Paciente: {appointment.patient.username}
Email: {appointment.patient.email}
Fecha: {appointment.availability.date.strftime('%d/%m/%Y')}
Hora: {appointment.availability.time.strftime('%H:%M')}
Consultorio: {appointment.availability.clinic.name}
Dirección: {appointment.availability.clinic.address}

¡Gestiona tus turnos desde tu perfil profesional!

Saludos,
Equipo de BioForge
            """.strip(),
            html=f"""
<h2>📅 Nuevo turno reservado</h2>
<p><strong>Paciente:</strong> {appointment.patient.username}</p>
<p><strong>Email:</strong> {appointment.patient.email}</p>
<hr>
<p><strong>Fecha:</strong> {appointment.availability.date.strftime('%d/%m/%Y')}</p>
<p><strong>Hora:</strong> {appointment.availability.time.strftime('%H:%M')}</p>
<p><strong>Consultorio:</strong> {appointment.availability.clinic.name}</p>
<p><strong>Dirección:</strong> {appointment.availability.clinic.address}</p>
<p><em>Este mensaje fue generado automáticamente por el sistema.</em></p>
            """
        )
        mail.send(msg)
        return True
    except Exception as e:
        current_app.logger.error(f"Error al enviar notificación al profesional: {str(e)}")
        return False
    
def require_admin(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not current_user.is_authenticated or not current_user.is_admin:
            flash("Acceso restringido solo a administradores.", "danger")
            return redirect(url_for("routes.index"))
        return f(*args, **kwargs)
    return decorated_function

BIO_SHORT = "📊 Consultor freelance en Analítica de Datos y Sistemas • Formador en Python y BI • Certificado Google Data Analytics • Transformo datos en decisiones."
BIO_EXTENDED = """Somos una consultora independiente en análisis de datos, big data y sistemas..."""

PUBLICATIONS = [
    {
        "id": 1001,
        "type": "Educativo",
        "title": "El error más común en análisis de datos",
        "content": "En mi experiencia como consultor, el error más común que veo...",
        "image_url": "/static/img/default-article.jpg"
    },
    {
        "id": 1002,
        "type": "Caso de éxito",
        "title": "Cómo optimicé un proceso de ETL con Python",
        "content": "Un cliente tenía un proceso de carga de datos que tardaba 8 horas...",
        "image_url": "/static/img/default-article.jpg"
    }
]

@routes.route("/")
def index():
    return render_template("index.html", bio_short=BIO_SHORT, bio_extended=BIO_EXTENDED, active_tab="home")

@routes.route('/health')
def health():
    return 'OK', 200

@routes.route("/auth/register", methods=["GET", "POST"])
def register():
    roles_activos = UserRole.query.filter_by(is_active=True).all()
    
    if request.method == "POST":
        username = request.form.get("username").strip()
        email = request.form.get("email").strip()
        password = request.form.get("password")
        role_id = request.form.get("role_id")

        if not role_id or not UserRole.query.filter_by(id=role_id, is_active=True).first():
            flash("Por favor selecciona un rol válido", "error")
            return render_template("auth/register.html", roles_activos=roles_activos)

        if User.query.filter_by(email=email).first():
            flash("Este email ya está registrado", "error")
            return render_template("auth/register.html", roles_activos=roles_activos)

        if User.query.filter_by(username=username).first():
            flash("Este nombre de usuario ya existe", "error")
            return render_template("auth/register.html", roles_activos=roles_activos)

        role = UserRole.query.get(role_id)
        user = User(
            username=username,
            email=email,
            role_id=role_id,
            is_professional=(role.name != "Visitante" and role.name != "Paciente")
        )
        user.set_password(password)
        db.session.add(user)
        db.session.commit()

        flash("✅ Registro exitoso. Inicia sesión.", "success")
        return redirect(url_for("auth.login"))

    return render_template("auth/register.html", roles_activos=roles_activos)

@routes.route('/admin/dashboard')
@login_required
def admin_dashboard():
    if not current_user.is_admin:
        flash("Acceso denegado", "danger")
        return redirect(url_for("routes.index"))

    total_users = User.query.count()
    total_medicos = User.query.filter_by(is_professional=True).count()
    pending_notes = Note.query.filter_by(status=NoteStatus.PENDING).all()
    turnos_hoy = Appointment.query.join(Availability).filter(
        Availability.date == datetime.now().date()
    ).count()

    return render_template(
        'admin/admin_dashboard.html',
        total_users=total_users,
        total_medicos=total_medicos,
        pending_notes=pending_notes,
        turnos_hoy=turnos_hoy
    )

@routes.route("/admin/roles")
@login_required
def admin_roles():
    if not current_user.is_admin:
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.index'))
    
    roles = UserRole.query.all()
    return render_template('admin/roles.html', roles=roles)

@routes.route("/admin/roles/nuevo", methods=['GET', 'POST'])
@login_required
def admin_nuevo_rol():
    if not current_user.is_admin:
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.index'))
    
    if request.method == 'POST':
        name = request.form.get('name', '').strip()
        description = request.form.get('description', '').strip()
        
        if not name:
            flash('Nombre del rol es obligatorio', 'error')
        elif UserRole.query.filter_by(name=name).first():
            flash(f'Ya existe un rol llamado "{name}"', 'error')
        else:
            rol = UserRole(name=name, description=description, is_active=True)
            db.session.add(rol)
            db.session.commit()
            flash(f'✅ Rol "{name}" creado', 'success')
            return redirect(url_for('routes.admin_roles'))
    
    return render_template('admin/nuevo_rol.html')

@routes.route('/admin/roles/<int:rol_id>/toggle', methods=['POST'])
@login_required
def admin_toggle_rol(rol_id):
    if not current_user.is_admin:
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.index'))
    
    rol = UserRole.query.get_or_404(rol_id)
    rol.is_active = not rol.is_active
    db.session.commit()
    
    estado = "activado" if rol.is_active else "desactivado"
    flash(f'✅ Rol "{rol.name}" {estado}', 'success')
    return redirect(url_for('routes.admin_roles'))

@routes.route("/admin")
@login_required
def admin_panel():
    if not current_user.is_admin:
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.index'))
    
    pending_notes = Note.query.filter_by(status=NoteStatus.PENDING).all()
    published_notes = Note.query.filter_by(status=NoteStatus.PUBLISHED).all()
    all_publications = Publication.query.all()
    all_roles = UserRole.query.all()  # ✅ Añadido
    
    return render_template(
        "admin/admin_panel.html",
        pending_notes=pending_notes,
        published_notes=published_notes,
        all_publications=all_publications,
        all_roles=all_roles,  # ✅ Pasado al template
        bio_short=BIO_SHORT,
        bio_extended=BIO_EXTENDED
    )

@routes.route('/admin/note/<int:note_id>/approve', methods=['POST'])
@require_admin
def admin_approve_note(note_id):
    note = Note.query.get_or_404(note_id)
    note.status = NoteStatus.PUBLISHED
    note.approved_by = current_user.id
    note.approved_at = datetime.utcnow()
    db.session.commit()
    flash(f'✅ Nota "{note.title}" aprobada y publicada', 'success')
    return redirect(url_for('routes.admin_panel'))

@routes.route('/admin/note/<int:note_id>/reject', methods=['POST'])
@require_admin
def admin_reject_note(note_id):
    note = Note.query.get_or_404(note_id)
    note.status = NoteStatus.PRIVATE
    db.session.commit()
    flash(f'❌ Nota "{note.title}" rechazada y marcada como privada', 'info')
    return redirect(url_for('routes.admin_panel'))

@routes.route("/publications")
def publications():
    # Filtros
    q = request.args.get('q', '').strip()
    category = request.args.get('category', '')

    # Obtener publicaciones de la DB
    db_query = Publication.query.filter_by(is_published=True)
    if q:
        db_query = db_query.filter(
            Publication.title.ilike(f"%{q}%") |
            Publication.content.ilike(f"%{q}%") |
            Publication.tags.ilike(f"%{q}%")
        )
    if category:
        db_query = db_query.filter_by(type=category)
    
    db_publications = db_query.order_by(Publication.published_at.desc()).all()

    # Lista combinada
    combined = []

    # Añadir publicaciones de la DB
    for pub in db_publications:
        if not pub.published_at:
            pub.published_at = pub.created_at or datetime.utcnow()
        combined.append({
            "id": pub.id,
            "type": pub.type,
            "title": pub.title,
            "content": pub.excerpt or (pub.content[:200] + "..."),
            "published_at": pub.published_at,
            "author": pub.author.username if pub.author else "José Luis Astiazu",
            "is_db": True,
            "image_url": pub.image_url or "/static/img/default-article.jpg"
        })

    # Añadir publicaciones estáticas (si existen)
    if 'PUBLICATIONS' in globals():
        for pub in PUBLICATIONS:
            if category and pub["type"] != category:
                continue
            combined.append({
                "id": pub["id"],
                "type": pub["type"],
                "title": pub["title"],
                "content": pub["content"][:200] + "...",
                "published_at": pub.get("published_at", datetime.now()),
                "author": "José Luis Astiazu",
                "is_db": False,
                "image_url": pub.get("image_url", "/static/img/default-article.jpg")
            })

    # Ordenar por fecha
    combined.sort(key=lambda x: x["published_at"], reverse=True)

    return render_template(
        "publications.html",
        publications=combined,
        bio_short=BIO_SHORT,
        bio_extended=BIO_EXTENDED,
        active_tab="publications",
        selected_category=category,
        search_query=q
    )

@routes.route('/publication/<int:pub_id>')
def view_publication(pub_id):
    # ✅ El admin puede ver cualquier publicación (incluso borradores)
    if current_user.is_authenticated and current_user.is_admin:
        publication = Publication.query.get_or_404(pub_id)
    else:
        # Público solo ve publicadas
        publication = Publication.query.filter_by(id=pub_id, is_published=True).first()
    
    if not publication:
        abort(404)

    return render_template(
        'view_publication.html',
        publication=publication,
        bio_short=BIO_SHORT,
        bio_extended=BIO_EXTENDED
    )

@routes.route('/admin/publication/new', methods=['GET', 'POST'])
@require_admin
def new_publication():
    if request.method == 'POST':
        title = request.form.get('title', '').strip()
        content = request.form.get('content', '').strip()
        pub_type = request.form.get('type', '').strip()
        excerpt = request.form.get('excerpt', '').strip()
        tags = request.form.get('tags', '').strip()
        is_published = 'is_published' in request.form

        if not title or not content or not pub_type:
            flash('Por favor completa todos los campos requeridos', 'error')
            return render_template('edit_publication.html', publication=None, bio_short=BIO_SHORT, bio_extended=BIO_EXTENDED)

        # ✅ Crear publicación
        publication = Publication(
            title=title,
            content=content,
            type=pub_type,
            excerpt=excerpt,
            tags=tags,
            user_id=current_user.id,
            is_published=is_published,
            published_at=datetime.now() if is_published else None
        )
        db.session.add(publication)
        db.session.flush()  # Para obtener el ID

        # ✅ Manejo de imagen subida
        if 'image_file' in request.files:
            file = request.files['image_file']
            if file.filename != '':
                filename = secure_filename(f"pub_{publication.id}_{int(time.time())}.jpg")
                filepath = os.path.join('static/uploads', filename)
                file.save(filepath)
                publication.image_url = f"/static/uploads/{filename}"

        db.session.commit()
        flash('✅ Publicación creada exitosamente', 'success')
        return redirect(url_for('routes.admin_panel'))

    return render_template('edit_publication.html', publication=None, bio_short=BIO_SHORT, bio_extended=BIO_EXTENDED)

@routes.route('/admin/publication/<int:pub_id>/edit', methods=['GET', 'POST'])
@require_admin
def edit_publication(pub_id):
    publication = Publication.query.get_or_404(pub_id)
    
    if request.method == 'POST':
        publication.title = request.form.get('title', '').strip()
        publication.content = request.form.get('content', '').strip()
        publication.type = request.form.get('type', '').strip()
        publication.excerpt = request.form.get('excerpt', '').strip()
        publication.tags = request.form.get('tags', '').strip()
        is_published = 'is_published' in request.form  # ✅ Captura el checkbox

        # ✅ Actualizar estado de publicación
        publication.is_published = is_published
        if is_published and not publication.published_at:
            publication.published_at = datetime.now()
        elif not is_published:
            publication.published_at = None

        # ✅ Manejo de imagen: solo si se sube una nueva
        if 'image_file' in request.files and request.files['image_file'].filename != '':
            file = request.files['image_file']
            
            # Eliminar imagen anterior si existe
            if publication.image_url and os.path.exists('.' + publication.image_url):
                os.remove('.' + publication.image_url)
            
            # Guardar nueva imagen
            filename = secure_filename(f"pub_{publication.id}_{int(time.time())}.jpg")
            filepath = os.path.join('static/uploads', filename)
            file.save(filepath)
            publication.image_url = f"/static/uploads/{filename}"

        # ✅ Si no se sube nueva imagen, conserva la anterior
        # (no se hace nada, ya está en publication.image_url)

        db.session.commit()
        flash('✅ Publicación actualizada exitosamente', 'success')
        return redirect(url_for('routes.admin_panel'))

    return render_template('edit_publication.html', publication=publication, bio_short=BIO_SHORT, bio_extended=BIO_EXTENDED)

@routes.route('/admin/publication/<int:pub_id>/delete', methods=['POST'])
@require_admin
def delete_publication(pub_id):
    publication = Publication.query.get_or_404(pub_id)
    db.session.delete(publication)
    db.session.commit()
    flash('🗑️ Publicación eliminada exitosamente', 'info')
    return redirect(url_for('routes.admin_panel'))

@routes.route("/portfolio")
def portfolio():
    return render_template("portfolio.html", bio_short=BIO_SHORT, bio_extended=BIO_EXTENDED, active_tab="portfolio")

@routes.route("/notes")
@login_required
def notes():
    if current_user.is_admin:
        all_notes = Note.query.order_by(Note.created_at.desc()).all()
        user_notes = [n for n in all_notes if n.user_id == current_user.id]
        other_notes = [n for n in all_notes if n.user_id != current_user.id]
    else:
        user_notes = Note.query.filter_by(user_id=current_user.id).all()
        other_notes = []
    return render_template(
        "notes.html",
        user_notes=user_notes,
        other_notes=other_notes,
        bio_short=BIO_SHORT,
        bio_extended=BIO_EXTENDED,
        active_tab="notes"
    )

@routes.route('/note/<int:note_id>')
def view_note(note_id):
    note = Note.query.get_or_404(note_id)
    
    # ✅ Permitir ver si:
    # - Está publicada
    # - O el usuario es el dueño
    # - O es admin
    if not current_user.is_authenticated:
        if note.status != NoteStatus.PUBLISHED:
            abort(404)
    else:
        if note.status != NoteStatus.PUBLISHED and note.user_id != current_user.id and not current_user.is_admin:
            abort(404)

    # ✅ Aumentar contador de vistas solo si está publicada
    if note.status == NoteStatus.PUBLISHED:
        note.view_count += 1
        db.session.commit()

    return render_template("view_note.html", note=note, bio_short=BIO_SHORT, bio_extended=BIO_EXTENDED)

@routes.route('/note/new', methods=['GET', 'POST'])
@routes.route('/note/<int:note_id>/edit', methods=['GET', 'POST'])
@login_required
def edit_note(note_id=None):
    note = None
    if note_id:
        note = Note.query.get_or_404(note_id)
        if not note.can_edit(current_user):
            flash('No tienes permisos para editar esta nota', 'error')
            return redirect(url_for('routes.notes'))

    if request.method == 'POST':
        title = request.form.get('title', '').strip()
        content = request.form.get('content', '').strip()
        
        # ✅ Manejo de imagen: URL o subida
        image_url = request.form.get('image_url', '').strip()
        upload_image = request.files.get('upload_image')

        if not title or not content:
            flash('Por favor completa el título y contenido', 'error')
            return render_template('edit_note.html', note=note, bio_short=BIO_SHORT, bio_extended=BIO_EXTENDED)

        if note:
            note.title = title
            note.content = content

            # ✅ Actualizar imagen
            if upload_image and upload_image.filename != '':
                if upload_image.filename.lower().endswith(('.png', '.jpg', '.jpeg', '.gif')):
                    filename = secure_filename(f"note_{note.id}_{int(datetime.now().timestamp())}.jpg")
                    filepath = os.path.join('static/uploads/notes', filename)
                    os.makedirs(os.path.dirname(filepath), exist_ok=True)
                    upload_image.save(filepath)
                    note.featured_image = f"/{filepath}"
                else:
                    flash('Formato de imagen no permitido. Usa JPG, PNG o GIF.', 'warning')
            elif image_url:
                note.featured_image = image_url

            db.session.commit()
            flash('✅ Nota actualizada', 'success')
        else:
            new_note = Note(
                title=title,
                content=content,
                user_id=current_user.id,
                status=NoteStatus.PRIVATE
            )

            # ✅ Añadir imagen
            if upload_image and upload_image.filename != '':
                if upload_image.filename.lower().endswith(('.png', '.jpg', '.jpeg', '.gif')):
                    filename = secure_filename(f"note_new_{int(datetime.now().timestamp())}.jpg")
                    filepath = os.path.join('static/uploads/notes', filename)
                    os.makedirs(os.path.dirname(filepath), exist_ok=True)
                    upload_image.save(filepath)
                    new_note.featured_image = f"/{filepath}"
            elif image_url:
                new_note.featured_image = image_url

            db.session.add(new_note)
            db.session.commit()
            flash('✅ Nota creada', 'success')
            return redirect(url_for('routes.notes'))

    return render_template('edit_note.html', note=note, bio_short=BIO_SHORT, bio_extended=BIO_EXTENDED)

@routes.route('/note/<int:note_id>/delete', methods=['POST'])
@login_required
def delete_note(note_id):
    note = Note.query.get_or_404(note_id)
    if not note.can_edit(current_user):
        flash('No tienes permisos para eliminar esta nota', 'error')
        return redirect(url_for('routes.notes'))
    db.session.delete(note)
    db.session.commit()
    flash('🗑️ Nota eliminada exitosamente', 'info')
    return redirect(url_for('routes.notes'))

@routes.route("/notas-publicadas")
def public_notes():
    # Notas publicadas, ordenadas por fecha
    published_notes = Note.query.filter_by(status=NoteStatus.PUBLISHED).order_by(Note.approved_at.desc()).all()
    
    # Top 5 más vistas
    top_notes = Note.query.filter_by(status=NoteStatus.PUBLISHED).order_by(Note.view_count.desc()).limit(5).all()
    
    return render_template(
        "public_notes.html",
        published_notes=published_notes,
        top_notes=top_notes,
        bio_short=BIO_SHORT,
        bio_extended=BIO_EXTENDED,
        active_tab="public_notes"
    )


@routes.route('/note/<int:note_id>/request-publish', methods=['POST'])
@login_required
def request_publish_note(note_id):
    """
    Permite a un usuario solicitar la publicación de su nota (cambia estado a PENDING)
    """
    note = Note.query.get_or_404(note_id)
    
    # Verificar que el usuario sea el dueño
    if note.user_id != current_user.id:
        flash('No puedes solicitar publicación de una nota ajena', 'error')
        return redirect(url_for('routes.notes'))
    
    # Cambiar estado a pendiente
    if note.status == NoteStatus.PRIVATE:
        note.status = NoteStatus.PENDING
        db.session.commit()
        flash('✅ Solicitud de publicación enviada al administrador', 'success')
    else:
        flash('La nota ya está en revisión o publicada', 'info')
    
    return redirect(url_for('routes.notes'))

@routes.route("/data-analysis")
def data_analysis():
    return render_template("data_analysis.html", bio_short=BIO_SHORT, bio_extended=BIO_EXTENDED, active_tab="data_analysis")

@routes.route("/upload-csv", methods=["POST"])
def upload_csv():
    try:
        if "file" not in request.files:
            return jsonify({"error": "No file selected"}), 400
        file = request.files["file"]
        if file.filename == "":
            return jsonify({"error": "No file selected"}), 400
        if not file.filename.lower().endswith(".csv"):
            return jsonify({"error": "Please upload a CSV file"}), 400

        # Generar ID único para el archivo
        file_id = str(uuid.uuid4())
        file_path = os.path.join(UPLOAD_FOLDER, f"{file_id}.csv")

        # Detectar codificación
        raw = file.stream.read(10000)
        encoding = chardet.detect(raw)["encoding"] or "utf-8"
        file.stream.seek(0)

        # Guardar archivo
        file.save(file_path)

        # Leer CSV
        df = pd.read_csv(file_path, encoding=encoding)
        if df.empty or len(df.columns) == 0:
            os.remove(file_path)
            return jsonify({"error": "CSV inválido o vacío"}), 400

        # Devolver file_id para usar en análisis
        info = {
            "file_id": file_id,
            "columns": df.columns.tolist(),
            "shape": df.shape,
            "dtypes": df.dtypes.astype(str).to_dict(),
            "preview": df.head(10).to_dict("records"),
            "missing_values": df.isnull().sum().to_dict(),
        }
        return jsonify(info)

    except Exception as e:
        current_app.logger.error(f"Error processing CSV: {str(e)}")
        return jsonify({"error": f"Error procesando el archivo: {str(e)}"}), 500

@routes.route("/analyze-data", methods=["POST"])
def analyze_data():
    try:
        data = request.get_json()
        file_id = data.get("file_id")
        x_column = data.get("x_column")
        y_column = data.get("y_column")
        chart_type = data.get("chart_type", "scatter")

        if not file_id or not x_column or not y_column:
            return jsonify({"error": "Faltan datos: file_id, x_column o y_column"}), 400

        file_path = os.path.join(UPLOAD_FOLDER, f"{file_id}.csv")
        if not os.path.exists(file_path):
            return jsonify({"error": "Datos no encontrados. Suba el CSV nuevamente."}), 400

        df = pd.read_csv(file_path)

        if x_column not in df.columns or y_column not in df.columns:
            return jsonify({"error": "Columnas no encontradas"}), 400

        # ✅ Validar que Y sea numérica
        y_numeric = pd.to_numeric(df[y_column], errors='coerce')
        if y_numeric.isnull().all():
            return jsonify({"error": f"La columna '{y_column}' debe ser numérica para graficar"}), 400

        # Llenar NaNs y tomar solo 100 filas
        x_values = df[x_column].astype(str).tolist()[:100]
        y_values = y_numeric.fillna(0).tolist()[:100]

        chart_data = {
            "labels": x_values,
            "datasets": [{
                "label": f"{y_column} vs {x_column}",
                "data": y_values,
                "borderColor": "rgb(75, 192, 192)",
                "backgroundColor": "rgba(75, 192, 192, 0.2)",
                "tension": 0.1,
            }]
        }

        if chart_type == "scatter":
            chart_data["datasets"][0]["data"] = [
                {"x": x, "y": float(y)} for x, y in zip(x_values, y_values)
            ]

        return jsonify({
            "chart_data": chart_data,
            "chart_type": chart_type,
            "title": f"{y_column} vs {x_column}"
        })
    except Exception as e:
        current_app.logger.error(f"Error analyzing data: {str(e)}")
        return jsonify({"error": f"Error analyzing data: {str(e)}"}), 500
    
@routes.route("/profesionales")
def profesionales():
    category = request.args.get('category', '')
    query = User.query.filter_by(is_professional=True)
    if category:
        # ✅ Filtrar por nombre de rol
        role = UserRole.query.filter_by(name=category).first()
        if role:
            query = query.filter_by(role_id=role.id)
    
    professionals = query.options(db.joinedload(User.clinics)).all()
    professionals = [p.to_dict() for p in professionals]

    # ✅ Categorías = roles activos
    roles = UserRole.query.filter_by(is_active=True).all()
    categories = [r.name for r in roles if r.name not in ['Visitante', 'Paciente']]

    return render_template(
        "profesionales.html",
        professionals=professionals,
        categories=categories,
        selected_category=category,
        bio_short=BIO_SHORT,
        bio_extended=BIO_EXTENDED,
        active_tab="profesionales"
    )

# Perfil público más completo
@routes.route('/profesional/<string:url_slug>')
def perfil_profesional(url_slug):
    professional = User.query.filter_by(url_slug=url_slug, is_professional=True).first_or_404()
    clinics = Clinic.query.filter_by(doctor_id=professional.id, is_active=True).all()
    return render_template(
        'public/perfil_profesional.html',
        doctor=professional,  # mantener doctor por compatibilidad
        clinics=clinics,
        active_tab='profesionales'
    )

@routes.route('/mi-perfil')
@login_required
def mi_perfil():
    if not current_user.is_professional:
        flash("No tienes un perfil profesional", "info")
        return redirect(url_for('routes.index'))

    clinics = Clinic.query.filter_by(doctor_id=current_user.id, is_active=True).all()
    schedules = Schedule.query.filter_by(doctor_id=current_user.id, is_active=True).all()
    turnos_recibidos = Appointment.query.join(Availability).join(Clinic).filter(
        Clinic.doctor_id == current_user.id
    ).order_by(Appointment.created_at.desc()).all()

    return render_template(
        'mi_perfil_medico.html',
        clinics=clinics,
        schedules=schedules,
        turnos_recibidos=turnos_recibidos,
        bio_short=BIO_SHORT,
        bio_extended=BIO_EXTENDED
    )

@routes.route("/profesional/<string:url_slug>")
def perfil_publico_profesional(url_slug):
    doctor = User.query.filter_by(url_slug=url_slug, is_professional=True).first_or_404()
    clinics = Clinic.query.filter_by(doctor_id=doctor.id, is_active=True).all()
    return render_template(
        'public/perfil_profesional.html',
        doctor=doctor,
        clinics=clinics,
        active_tab='profesionales'
    )

@routes.route('/mi-perfil/editar', methods=['GET', 'POST'])
@login_required
def editar_perfil_medico():
    if not current_user.is_professional:
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.index'))

    if request.method == 'POST':
        # ✅ Actualizar campos
        current_user.specialty = request.form.get('specialty', '').strip()
        current_user.license_number = request.form.get('license_number', '').strip()
        current_user.bio = request.form.get('bio', '').strip()
        current_user.years_experience = request.form.get('years_experience', type=int)
        current_user.services = request.form.get('services', '').strip()
        current_user.email = request.form.get('email', '').strip()  # ✅ Guarda el email

        # ✅ Solo cambiar slug si el usuario lo modificó
        url_slug_input = request.form.get('url_slug', '').strip()
        if url_slug_input:
            # El usuario quiere cambiar el slug
            url_slug = re.sub(r'[^a-z0-9]+', '-', url_slug_input.lower())
            url_slug = re.sub(r'-+', '-', url_slug).strip('-')
            
            # Verificar unicidad (excepto para el mismo usuario)
            existing = User.query.filter_by(url_slug=url_slug).first()
            if existing and existing.id != current_user.id:
                flash(f"El enlace '{url_slug}' ya está en uso. Elige otro.", "error")
                return render_template('editar_perfil_medico.html', user=current_user)
            
            current_user.url_slug = url_slug
            # ✅ Si cambia el slug, redirigir al nuevo
            redirect_slug = url_slug
        else:
            # ✅ No se modificó: mantener el actual
            redirect_slug = current_user.url_slug or f"profesional-{current_user.id}"

        # ✅ Subir imagen
        if 'profile_photo' in request.files:
            file = request.files['profile_photo']
            if file.filename != '':
                if file.filename.lower().endswith(('.png', '.jpg', '.jpeg', '.gif')):
                    filename = secure_filename(f"profile_{current_user.id}_{int(datetime.now().timestamp())}.jpg")
                    filepath = os.path.join('static/uploads/profiles', filename)
                    os.makedirs(os.path.dirname(filepath), exist_ok=True)
                    file.save(filepath)
                    current_user.profile_photo = f"/{filepath}"
                else:
                    flash('Formato no permitido. Usa JPG, PNG o GIF.', 'warning')

        # ✅ Guardar
        try:
            db.session.commit()
            flash('✅ Perfil actualizado', 'success')
            return redirect(url_for('routes.mi_perfil'))  # ✅ Correcto
        except Exception as e:
            db.session.rollback()
            flash('❌ Error al guardar', 'danger')

    return render_template('editar_perfil_medico.html', user=current_user)

@routes.route('/consultorio/nuevo', methods=['GET', 'POST'])
@login_required
def nuevo_consultorio():
    if not current_user.is_professional:
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.index'))
    
    if request.method == 'POST':
        name = request.form.get('name', '').strip()
        address = request.form.get('address', '').strip()
        phone = request.form.get('phone', '').strip()
        specialty = request.form.get('specialty', '').strip()
        
        if not name or not address:
            flash('Nombre y dirección son obligatorios', 'error')
            return redirect(url_for('routes.nuevo_consultorio'))
        
        clinic = Clinic(
            name=name,
            address=address,
            phone=phone,
            specialty=specialty,
            doctor_id=current_user.id,
            is_active=True
        )
        db.session.add(clinic)
        db.session.flush()  # Para obtener clinic.id

        # ✅ Generar disponibilidad para agendas existentes
        for schedule in Schedule.query.filter_by(doctor_id=current_user.id).all():
            generar_disponibilidad_automatica(schedule, semanas=52)
        
        db.session.commit()
        flash('✅ Consultorio creado y disponibilidad actualizada', 'success')
        return redirect(url_for('routes.mi_agenda'))
    
    return render_template('nuevo_consultorio.html')

@routes.route('/consultorio/<int:clinic_id>/editar', methods=['GET', 'POST'])
@login_required
def editar_consultorio(clinic_id):
    clinic = Clinic.query.get_or_404(clinic_id)
    if clinic.doctor_id != current_user.id:
        flash('No puedes editar este consultorio', 'danger')
        return redirect(url_for('routes.mi_perfil', doctor_id=current_user.id))
    if request.method == 'POST':
        clinic.name = request.form.get('name', '').strip()
        clinic.address = request.form.get('address', '').strip()
        clinic.phone = request.form.get('phone', '').strip()
        clinic.specialty = request.form.get('specialty', '').strip()
        db.session.commit()
        flash('✅ Consultorio actualizado', 'success')
        return redirect(url_for('routes.mi_perfil', doctor_id=current_user.id))
    return render_template('editar_consultorio.html', clinic=clinic)

@routes.route('/consultorio/<int:clinic_id>/eliminar', methods=['POST'])
@login_required
def eliminar_consultorio(clinic_id):
    clinic = Clinic.query.get_or_404(clinic_id)
    if clinic.doctor_id != current_user.id:
        flash('No puedes eliminar este consultorio', 'danger')
        return redirect(url_for('routes.mi_perfil', doctor_id=current_user.id))
    db.session.delete(clinic)
    db.session.commit()
    flash('🗑️ Consultorio eliminado', 'info')
    return redirect(url_for('routes.mi_perfil', doctor_id=current_user.id))

@routes.route("/turnos/<int:clinic_id>")
def turnos_por_clinica(clinic_id):
    clinic = Clinic.query.get_or_404(clinic_id)
    avail = Availability.query.filter_by(clinic_id=clinic_id, is_booked=False).order_by(
        Availability.date, Availability.time
    ).all()
    from collections import defaultdict
    grouped = defaultdict(list)
    for a in avail:
        grouped[a.date].append(a)
    return render_template(
        "turnos.html",
        clinic=clinic,
        availability=avail,
        grouped=dict(grouped),
        bio_short=BIO_SHORT,
        bio_extended=BIO_EXTENDED
    )

@routes.route('/turno/reservar', methods=['POST'])
def reservar_turno():
    availability_id = request.form.get('availability_id', type=int)
    if not availability_id:
        flash('Turno no válido', 'danger')
        return redirect(url_for('routes.medicos'))

    availability = Availability.query.get_or_404(availability_id)
    if availability.is_booked:
        flash('Este turno ya fue reservado', 'info')
        return redirect(url_for('routes.turnos_por_clinica', clinic_id=availability.clinic_id))

    patient_name = request.form.get('patient_name', '').strip()
    patient_email = request.form.get('patient_email', '').strip()

    if not patient_name or not patient_email:
        flash('Por favor completa tu nombre y email', 'warning')
        return redirect(url_for('routes.turnos_por_clinica', clinic_id=availability.clinic_id))

    # Buscar o crear paciente
    patient = User.query.filter_by(email=patient_email).first()
    if not patient:
        patient = User(
            username=patient_name,
            email=patient_email,
            is_professional=False,
            is_admin=False
        )
        patient.set_password("temp" + patient_email)
        db.session.add(patient)
        db.session.flush()

    # Crear cita
    appointment = Appointment(
        availability_id=availability_id,
        patient_id=patient.id,
        status="confirmed"
    )
    availability.is_booked = True
    db.session.add(appointment)
    db.session.commit()

    # ✅ Enviar todas las notificaciones
    exito_paciente = enviar_confirmacion_turno(appointment)
    exito_admin = enviar_notificacion_turno_reservado(appointment)
    exito_profesional = enviar_notificacion_profesional(appointment)

    # Mensajes de feedback
    if exito_paciente and exito_admin and exito_profesional:
        flash('✅ ¡Turno reservado! Se han enviado todas las confirmaciones.', 'success')
    elif exito_paciente and exito_profesional:
        flash('✅ ¡Turno reservado! Notificación al admin falló, pero paciente y profesional fueron notificados.', 'info')
    elif exito_paciente:
        flash('✅ Turno reservado, pero no pudimos notificar al admin ni al profesional.', 'info')
    else:
        flash('✅ Turno reservado, pero no pudimos enviar los correos.', 'info')

    return redirect(url_for('routes.confirmacion_turno', appointment_id=appointment.id))

@routes.route('/turno/confirmado/<int:appointment_id>')
def confirmacion_turno(appointment_id):
    appointment = Appointment.query.get_or_404(appointment_id)
    return render_template('confirmacion_turno.html', appointment=appointment)

@routes.route('/api/horarios/<int:doctor_id>/<int:clinic_id>/<string:fecha>')
def api_horarios(doctor_id, clinic_id, fecha):
    try:
        # ✅ Asegurar que la fecha sea en formato local (sin UTC)
        fecha_obj = datetime.strptime(fecha, '%Y-%m-%d').date()
    except ValueError:
        return jsonify({"error": "Formato de fecha inválido"}), 400

    avail = Availability.query.join(Clinic).filter(
        Clinic.doctor_id == doctor_id,
        Clinic.id == clinic_id,
        Availability.date == fecha_obj,
        Availability.is_booked == False
    ).all()

    return jsonify([
        {
            "id": a.id,
            "time": a.time.strftime('%H:%M')
        } for a in avail
    ])

@routes.route('/api/dias-disponibles/<int:doctor_id>/<int:clinic_id>')
def api_dias_disponibles(doctor_id, clinic_id):
    from datetime import datetime, timedelta

    # Buscar todos los Availability futuros (hasta 1 año)
    un_anio = datetime.now().date() + timedelta(days=365)
    
    avail = Availability.query.join(Clinic).filter(
        Clinic.doctor_id == doctor_id,
        Clinic.id == clinic_id,
        Availability.is_booked == False,
        Availability.date >= datetime.now().date(),
        Availability.date <= un_anio
    ).all()

    available_dates = {a.date.isoformat() for a in avail}

    return jsonify({
        "available_days": sorted(available_dates)
    })

@routes.route('/calendario/<int:doctor_id>/<int:clinic_id>')
def calendario_turnos(doctor_id, clinic_id):
    doctor = User.query.filter_by(id=doctor_id, is_professional=True).first_or_404()
    clinic = Clinic.query.get_or_404(clinic_id)
    return render_template(
        'public/calendario_turnos.html',
        doctor=doctor,
        clinic=clinic,
        doctor_id=doctor_id,
        clinic_id=clinic_id
    )

@routes.route('/paciente/<int:patient_id>/historial')
@login_required
def historial_paciente(patient_id):
    if not current_user.is_professional:
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.index'))
    patient = User.query.get_or_404(patient_id)
    tiene_turno = Appointment.query.join(Availability).join(Clinic).filter(
        Clinic.doctor_id == current_user.id,
        Appointment.patient_id == patient_id
    ).first()
    if not tiene_turno:
        flash('No puedes ver este historial: el paciente no ha tenido turnos contigo.', 'danger')
        return redirect(url_for('routes.mi_perfil_medico'))
    turnos = Appointment.query.join(Availability).join(Clinic).filter(
        Clinic.doctor_id == current_user.id,
        Appointment.patient_id == patient_id
    ).order_by(Appointment.created_at.desc()).all()
    notas = MedicalRecord.query.filter_by(
        doctor_id=current_user.id,
        patient_id=patient_id
    ).order_by(MedicalRecord.created_at.desc()).all()
    return render_template(
        'historial_paciente.html',
        patient=patient,
        turnos=turnos,
        notas=notas
    )

@routes.route('/paciente/<int:patient_id>/nota/nueva', methods=['GET', 'POST'])
@login_required
def nueva_nota(patient_id):
    if not current_user.is_professional:
        return "Acceso denegado", 403
    patient = User.query.get_or_404(patient_id)
    if not Appointment.query.join(Availability).join(Clinic).filter(
        Clinic.doctor_id == current_user.id,
        Appointment.patient_id == patient_id
    ).first():
        flash('No puedes agregar notas a este paciente.', 'danger')
        return redirect(url_for('routes.mi_perfil_medico'))
    if request.method == 'POST':
        title = request.form.get('title', '').strip()
        notes = request.form.get('notes', '').strip()
        if not title or not notes:
            flash('Completa todos los campos', 'warning')
        else:
            record = MedicalRecord(
                patient_id=patient_id,
                doctor_id=current_user.id,
                title=title,
                notes=notes
            )
            db.session.add(record)
            db.session.commit()
            flash('✅ Nota clínica guardada', 'success')
            return redirect(url_for('routes.historial_paciente', patient_id=patient_id))
    return render_template('nueva_nota.html', patient=patient)

@routes.route('/mi-agenda')
@login_required
def mi_agenda():
    if not current_user.is_professional:
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.index'))
    
    clinics = Clinic.query.filter_by(doctor_id=current_user.id, is_active=True).all()
    schedules = Schedule.query.filter_by(doctor_id=current_user.id, is_active=True).all()
    
    appointments = db.session.query(Appointment, Availability, User)\
        .join(Availability).join(User, User.id == Appointment.patient_id)\
        .join(Clinic).filter(Clinic.doctor_id == current_user.id)\
        .order_by(Availability.date, Availability.time).all()

    days = {0: 'Lunes', 1: 'Martes', 2: 'Miércoles', 3: 'Jueves', 4: 'Viernes', 5: 'Sábado', 6: 'Domingo'}

    return render_template(
        'mi_agenda.html',
        clinics=clinics,
        schedules=schedules,
        appointments=appointments,
        days=days,
        bio_short=BIO_SHORT,
        bio_extended=BIO_EXTENDED
    )

@routes.route('/agenda/nueva', methods=['GET', 'POST'])
@login_required
def nueva_agenda():
    if not current_user.is_professional:
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.index'))
    
    if request.method == 'POST':
        day_of_week = request.form.get('day_of_week', type=int)
        clinic_id = request.form.get('clinic_id', type=int)
        start_time_str = request.form.get('start_time')
        end_time_str = request.form.get('end_time')

        # Validaciones
        if not all([day_of_week in range(7), clinic_id, start_time_str, end_time_str]):
            flash('Todos los campos son obligatorios', 'error')
            return redirect(url_for('routes.mi_agenda'))

        try:
            start_time = datetime.strptime(start_time_str, '%H:%M').time()
            end_time = datetime.strptime(end_time_str, '%H:%M').time()
        except ValueError:
            flash('Formato de hora inválido', 'error')
            return redirect(url_for('routes.mi_agenda'))

        if start_time >= end_time:
            flash('La hora de inicio debe ser menor a la de fin', 'error')
            return redirect(url_for('routes.mi_agenda'))

        # Verificar que el consultorio pertenece al médico
        clinic = Clinic.query.filter_by(id=clinic_id, doctor_id=current_user.id).first()
        if not clinic:
            flash('Consultorio no válido', 'error')
            return redirect(url_for('routes.mi_agenda'))

        # Evitar duplicados
        if Schedule.query.filter_by(
            doctor_id=current_user.id,
            clinic_id=clinic_id,
            day_of_week=day_of_week
        ).first():
            flash('Ya tienes una agenda para ese día en este consultorio', 'warning')
            return redirect(url_for('routes.mi_agenda'))

        # Crear agenda
        schedule = Schedule(
            doctor_id=current_user.id,
            clinic_id=clinic_id,
            day_of_week=day_of_week,
            start_time=start_time,
            end_time=end_time,
            is_active=True
        )
        db.session.add(schedule)
        db.session.flush()  # Para obtener ID

        # Generar disponibilidad
        try:
            generar_disponibilidad_automatica(schedule, semanas=52)
            db.session.commit()
            flash('✅ Agenda guardada y disponibilidad generada', 'success')
        except Exception as e:
            db.session.rollback()
            current_app.logger.error(f"Error al generar disponibilidad: {str(e)}")
            flash('❌ Error al generar disponibilidad', 'danger')
            return redirect(url_for('routes.mi_agenda'))

        return redirect(url_for('routes.mi_agenda'))

    # Si es GET
    clinics = Clinic.query.filter_by(doctor_id=current_user.id, is_active=True).all()
    if not clinics:
        flash('Primero debes crear un consultorio', 'info')
        return redirect(url_for('routes.nuevo_consultorio'))
    
    days = {
        0: 'Lunes', 1: 'Martes', 2: 'Miércoles',
        3: 'Jueves', 4: 'Viernes', 5: 'Sábado', 6: 'Domingo'
    }
    return render_template('nueva_agenda.html', clinics=clinics, days=days)


@routes.route('/agenda/eliminar/<int:schedule_id>', methods=['POST'])
@login_required
def eliminar_agenda(schedule_id):
    schedule = Schedule.query.get_or_404(schedule_id)
    
    if schedule.doctor_id != current_user.id:
        return "Acceso denegado", 403

    try:
        # ✅ Solo borrar disponibilidad NO reservada
        Availability.query.filter(
            Availability.clinic_id == schedule.clinic_id,
            Availability.is_booked == False
        ).delete()

        db.session.delete(schedule)
        db.session.commit()
        flash('❌ Agenda eliminada', 'info')
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"Error al eliminar agenda: {str(e)}")
        flash('❌ Error al eliminar agenda', 'danger')

    return redirect(url_for('routes.mi_agenda'))

@routes.route('/contacto', methods=['POST'])
def contacto():
    try:
        # Obtener datos del formulario
        nombre = request.form.get('nombre', '').strip()
        email = request.form.get('email', '').strip()
        mensaje = request.form.get('mensaje', '').strip()
        asunto = request.form.get('asunto', 'Contacto desde el sitio web').strip()

        # Validar datos
        if not all([nombre, email, mensaje]):
            flash('Por favor completa todos los campos', 'error')
            return redirect(url_for('routes.index'))

        if len(nombre) < 2 or len(asunto) < 3 or len(mensaje) < 10:
            flash('Los datos no son válidos', 'error')
            return redirect(url_for('routes.index'))

        # Enviar email
        msg = Message(
            subject=f"📩 {asunto}",
            recipients=["astiazu@gmail.com"],  # Cambia por tu email
            reply_to=email,
            body=f"""
                Nuevo mensaje de contacto:

                Nombre: {nombre}
                Email: {email}
                Asunto: {asunto}

                Mensaje:
                {mensaje}

                ---
                Este mensaje fue enviado desde tu sitio web.
            """
        )
        mail.send(msg)
        
        flash('✅ ¡Gracias por tu mensaje! Te responderé pronto.', 'success')
        
    except Exception as e:
        current_app.logger.error(f"Error al enviar email: {str(e)}")
        flash('❌ Hubo un error al enviar tu mensaje. Intenta más tarde.', 'danger')
    
    return redirect(url_for('routes.index'))

@routes.route('/subscribe', methods=['POST'])
def subscribe():
    email = request.form.get('email', '').strip()
    
    if not email:
        flash('Por favor ingresa un email válido', 'error')
    else:
        # Evitar duplicados
        if Subscriber.query.filter_by(email=email).first():
            flash('✅ Ya estás suscripto. ¡Gracias!', 'info')
        else:
            subscriber = Subscriber(email=email)
            db.session.add(subscriber)
            try:
                db.session.commit()
                flash('✅ ¡Gracias por suscribirte! Pronto recibirás contenido exclusivo.', 'success')
            except Exception as e:
                db.session.rollback()
                flash('❌ Hubo un error. Intenta más tarde.', 'danger')
    
    return redirect(request.referrer or url_for('routes.index'))

# ✅ Mover esta función fuera de cualquier ruta
def generar_disponibilidad_automatica(schedule, semanas=52):
    """Genera automáticamente turnos disponibles para las próximas 'semanas' semanas."""
    today = datetime.now().date()
    for i in range(semanas):
        days_ahead = (schedule.day_of_week - today.weekday()) % 7
        fecha = today + timedelta(days=days_ahead + i * 7)
        current = datetime.combine(fecha, schedule.start_time)
        end = datetime.combine(fecha, schedule.end_time)

        while current.time() < end.time():
            # Evitar duplicados
            if not Availability.query.filter_by(
                clinic_id=schedule.clinic_id,
                date=fecha,
                time=current.time()
            ).first():
                avail = Availability(
                    clinic_id=schedule.clinic_id,
                    date=fecha,
                    time=current.time(),
                    is_booked=False
                )
                db.session.add(avail)
            current += timedelta(minutes=30)  # Duración del turno

@routes.route('/fix-view-count')
@login_required
def fix_view_count():
    if not current_user.is_admin:
        return "Acceso denegado", 403

    # Buscar notas con view_count = NULL
    notes = Note.query.filter(Note.view_count.is_(None)).all()
    for note in notes:
        note.view_count = 0

    db.session.commit()
    return f"✅ Se corrigieron {len(notes)} notas con view_count NULL"