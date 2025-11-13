# print("✅ routes.py v20250924 - SIN import magic global")
# app/routes.py
# IMPORTS - ESTÁNDAR
# ================================
import os
import io
import re
import uuid
import time
import json
import csv
import string
import secrets
import traceback
import subprocess

from app.models import *

from datetime import datetime, timedelta, date
from collections import defaultdict
from io import StringIO
from math import ceil
import chardet
from functools import wraps
import urllib.parse

# ================================
# IMPORTS - TERCEROS
# ================================
import pandas as pd
import plotly.express as px
import requests
from flask import (
    render_template, request, redirect, url_for, flash, jsonify,
    session, Blueprint, current_app, abort, send_from_directory, Response, send_file, make_response
)
from flask_login import current_user, login_required, login_user
from flask_mail import Message
from werkzeug.utils import secure_filename
from werkzeug.security import generate_password_hash
from sqlalchemy import or_, and_, func, text
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm.attributes import flag_modified
from sqlalchemy.exc import SQLAlchemyError
from urllib.parse import urlparse
from decimal import Decimal, ROUND_HALF_UP
from app.config.constants import PROFESSIONAL_ROLE_IDS
from itsdangerous import URLSafeTimedSerializer, SignatureExpired, BadSignature

import cloudinary
import cloudinary.uploader

# ================================
# IMPORTS - LOCALES (TU APP)
# ================================
from flask import current_app
from app import db, mail
from scripts.import_script import import_csv_to_render_db  # Importa el script de importación

from app.utils import (
    upload_to_cloudinary, send_telegram_message, generate_invite_token,
    send_invite_email, verify_invite_token, generate_unique_invite_code,
    send_company_invite, can_manage_tasks
)

# Modelos y formularios
from app.models import (
    User, Note, Publication, NoteStatus, Clinic, Availability,
    Appointment, MedicalRecord, Schedule, UserRole, Subscriber,
    Assistant, Task, TaskStatus, CompanyInvite, Visit, ProductCategory, db
)

from app.forms import (
    NoteForm, PublicationForm, ClinicForm, AssistantForm,
    TaskAssignmentForm, AppointmentForm, MedicalRecordForm,
    CompanyInviteForm, SubscriberForm, DataUploadForm,
    ProfessionalProfileForm, PublicationFilterForm, RegistrationForm, 
    TaskForm, EventForm
)
from app.utils import send_telegram_message, send_whatsapp_message

# ================================
# BLUEPRINT
# ================================
routes = Blueprint('routes', __name__)

# ================================
# CONFIGURACIÓN
# ================================
UPLOAD_FOLDER = 'temp_csv'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

MAX_FILE_SIZE = 5 * 1024 * 1024  # 5 MB
ALLOWED_MIME_TYPES = {
    'text/csv',
    'application/vnd.ms-excel',
    'application/csv',
    'text/plain'  # ← permite archivos guardados como texto plano
}
# ================================
# FUNCIONES UTILITARIAS
# ================================

def extract_public_id_from_url(cloudinary_url):
    """
    Extrae el public_id de una URL de Cloudinary.
    Ej: https://res.cloudinary.com/<cloud_name>/image/upload/v123456789/producto_1_1.jpg
    → producto_1_1
    """
    try:
        path = urlparse(cloudinary_url).path
        # Eliminar prefijo y extensión
        if path.startswith('/image/upload/'):
            filename = path.split('/')[-1]
            public_id = filename.split('.')[0]  # Quita la extensión
            return public_id
        return None
    except Exception:
        return None
    
def escape_markdown(text):
    """Escapa caracteres especiales de Markdown en Telegram."""
    if not text:
        return ""
    escape_chars = '_*[]()~`>#+-=|{}.!'
    for char in escape_chars:
        text = text.replace(char, f'\\{char}')
    return text


def sanitize_column_name(name):
    """Sanitiza nombres de columnas para evitar errores o XSS."""
    if not isinstance(name, str):
        name = str(name)
    name = re.sub(r'[^a-zA-Z0-9áéíóúÁÉÍÓÚñÑ\s\-_]', '_', name.strip())
    name = re.sub(r'\s+', ' ', name)
    return name if name else "columna_desconocida"


def validate_csv_structure(df):
    """Valida que el DataFrame tenga estructura mínima válida."""
    if df.empty:
        raise ValueError("El archivo está vacío.")
    if len(df.columns) < 2:
        raise ValueError("Se requieren al menos 2 columnas para generar gráficos.")
    if df.isnull().all().all():
        raise ValueError("Todos los datos son nulos.")
    for col in df.columns:
        if not isinstance(col, str) or len(col.strip()) == 0:
            raise ValueError("Encabezados inválidos o vacíos en el CSV.")
    return True

def sanitize_date_column(series, default_date="2999-12-31"):
    """
    Convierte una serie a datetime, rellenando valores inválidos o vacíos con una fecha por defecto.
    """
    series = pd.to_datetime(series, errors='coerce')
    series = series.fillna(pd.Timestamp(default_date))
    return series


def generar_slug_unico(base_slug):
    """Genera un slug único para usuarios."""
    from app.models import User
    slug = re.sub(r'[^a-z0-9-]+', '-', base_slug.lower())
    slug = re.sub(r'-+', '-', slug).strip('-')
    original_slug = slug
    counter = 1
    while User.query.filter_by(url_slug=slug).first():
        slug = f"{original_slug}-{counter}"
        counter += 1
    return slug

def enviar_notificacion_tarea(task):
    """
    Envía notificación de nueva tarea por email y Telegram.
    """
    try:
        # Notificación por email
        msg = Message(
            subject=f"📋 Nueva Tarea Asignada: {task.title}",
            recipients=[task.assistant.email],
            body=f"""
        Hola {task.assistant.name},
        
        El Usuario. {current_user.username} te ha asignado una nueva tarea:
        
        📌 **Título:** {task.title}
        📝 **Descripción:** {task.description or 'No especificada'}
        📅 **Fecha Límite:** {task.due_date.strftime('%d/%m/%Y') if task.due_date else 'Sin fecha límite'}
        
        Por favor, ingresa al sistema para ver más detalles.
        
        Saludos,
        Sistema de Gestión de Tareas
        """.strip(),
            html=f"""
        <h2>📋 Nueva Tarea Asignada</h2>
        <p>Hola <strong>{task.assistant.name}</strong>,</p>
        <p>El Usuario. <strong>{current_user.username}</strong> te ha asignado una nueva tarea:</p>
        <ul>
            <li><strong>Título:</strong> {task.title}</li>
            <li><strong>Descripción:</strong> {task.description or 'No especificada'}</li>
            <li><strong>Fecha Límite:</strong> {task.due_date.strftime('%d/%m/%Y') if task.due_date else 'Sin fecha límite'}</li>
        </ul>
        <p>Por favor, ingresa al sistema para ver más detalles.</p>
        <p>Saludos,<br>
        <strong>Sistema de Gestión de Tareas</strong></p>
        """.strip()
        )
        mail.send(msg)
        email_ok = True
    except Exception as e:
        print(f"❌ Error al enviar notificación de tarea por email: {str(e)}")
        email_ok = False

    # Notificación por Telegram
    telegram_ok = False
    try:
        TELEGRAM_BOT_TOKEN = current_app.config.get('TELEGRAM_BOT_TOKEN')
        TELEGRAM_CHAT_ID = current_app.config.get('TELEGRAM_CHAT_ID')
        
        if not TELEGRAM_BOT_TOKEN or not TELEGRAM_CHAT_ID:
            print("⚠️ Token o Chat ID de Telegram no configurados")
            return email_ok

        mensaje = (
            f"📋 *Nueva Tarea Asignada*\n\n"
            f"*Asistente:* {escape_markdown(task.assistant.name)}\n"
            f"*Título:* {escape_markdown(task.title)}\n"
            f"*Descripción:* {escape_markdown(task.description or 'No especificada')}\n"
            f"*Fecha Límite:* {task.due_date.strftime('%d/%m/%Y') if task.due_date else 'Sin fecha límite'}\n"
            f"*Profesional:* {escape_markdown(current_user.username)}\n\n"
            f"Accede al sistema para más detalles."
        )

        # ✅ URL CORREGIDA: sin espacios después de "bot"
        url = f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage"
        payload = {
            'chat_id': TELEGRAM_CHAT_ID,
            'text': mensaje,
            'parse_mode': 'Markdown'
        }
        
        response = requests.post(url, data=payload, timeout=10)
        
        if response.status_code == 200:
            telegram_ok = True
            print(f"✅ Notificación enviada a Telegram para {task.assistant.name}")
        else:
            print(f"❌ Error en API Telegram: {response.status_code} - {response.text}")

    except Exception as e:
        print(f"❌ Error al enviar notificación por Telegram: {str(e)}")

    return email_ok or telegram_ok

def validate_mime_type(file):
    """
    Valida el tipo MIME del archivo usando python-magic.
    Si libmagic no está disponible (ej: en Render), hace fallback a validación por extensión.
    """
    print("✅ routes.py cargado sin import magic en el nivel superior")
    try:
        import magic
        mime = magic.from_buffer(file.read(2048), mime=True)
        file.seek(0)
        return mime in ALLOWED_MIME_TYPES
    except Exception as e:
        print(f"⚠️  Advertencia: libmagic no disponible ({e}). Validando solo por extensión.")
        return True  # fallback: confiamos en la extensión .csv

def check_access(doctor_id):
    """Permite acceso si es dueño o asistente Senior del equipo"""
    if current_user.id == doctor_id and current_user.is_professional:
        return True
    if session.get('active_role') == 'asistente':
        assistant_id = session.get('active_assistant_id')
        if assistant_id:
            assistant = Assistant.query.filter_by(
                id=assistant_id,
                user_id=current_user.id,
                doctor_id=doctor_id,
                type='general'
            ).first()
            return assistant is not None
    return False
    
# ================================
# RUTAS - ANÁLISIS DE DATOS (CSV + GRÁFICOS)
# ================================
@routes.route("/politica-de-privacidad")
def politica_privacidad():
    return render_template("legal/politica-de-privacidad.html", current_year=datetime.now().year)

@routes.route("/terminos-y-condiciones")
def terminos_condiciones():
    return render_template("legal/terminos-y-condiciones.html", current_year=datetime.now().year)

@routes.route("/eliminar-datos")
def eliminar_datos():
    return render_template("legal/eliminar-datos.html", current_year=datetime.now().year)

@routes.route('/cookies', methods=['GET', 'POST'])
def cookies():
    if request.method == 'POST':
        # El usuario acepta las cookies
        accept_cookies = request.form.get('accept_cookies')
        if accept_cookies == 'yes':
            session['cookies_accepted'] = True
            flash('✅ Has aceptado el uso de cookies.', 'success')
        else:
            session['cookies_accepted'] = False
            flash('❌ Has rechazado el uso de cookies.', 'warning')

        return redirect(url_for('routes.index'))

    return render_template('legal/cookies.html')

@routes.route('/upload_csv', methods=['GET', 'POST'])
@login_required
def upload_csv():
    if request.method == 'POST':
        file = request.files.get('file')
        if not file or not file.filename:
            flash('❌ No se seleccionó ningún archivo.', 'danger')
            return redirect(request.url)

        file.seek(0, os.SEEK_END)
        size = file.tell()
        file.seek(0)
        if size > MAX_FILE_SIZE:
            flash('❌ El archivo supera el tamaño máximo permitido (5 MB).', 'danger')
            return redirect(request.url)

        # Validar MIME type (con fallback en Render)
        if not validate_mime_type(file):
            flash('❌ Tipo de archivo no permitido. Solo se aceptan CSV válidos.', 'danger')
            return redirect(request.url)

        if not file.filename.lower().endswith('.csv'):
            flash('❌ El archivo debe tener extensión .csv.', 'danger')
            return redirect(request.url)

        encodings = ['utf-8', 'utf-8-sig', 'latin1', 'iso-8859-1']
        df = None
        last_error = None

        for enc in encodings:
            try:
                stream = StringIO(file.stream.read().decode(enc))
                file.stream.seek(0)
                df = pd.read_csv(stream)
                break
            except UnicodeDecodeError as e:
                last_error = e
                continue

        if df is None:
            flash(f'❌ No se pudo decodificar el archivo. Último error: {last_error}', 'danger')
            return redirect(request.url)

        try:
            validate_csv_structure(df)
        except Exception as e:
            flash(f'❌ Estructura inválida: {str(e)}', 'danger')
            return redirect(request.url)

        df.columns = [sanitize_column_name(col) for col in df.columns]

        date_columns_to_sanitize = {
            'Fecha_Limite': '2999-12-31',
            'Creada': '2000-01-01'
        }

        for col_name, default in date_columns_to_sanitize.items():
            if col_name in df.columns:
                original_series = pd.to_datetime(df[col_name], errors='coerce')
                invalid_count = original_series.isna().sum()
                df[col_name] = sanitize_date_column(df[col_name], default)
                if invalid_count > 0:
                    flash(f'⚠️ Se corrigieron {invalid_count} fechas vacías/inválidas en "{col_name}" → asignadas a {default}.', 'warning')

        session['csv_data'] = df.to_dict()
        session['csv_columns'] = df.columns.tolist()

        return redirect(url_for('routes.select_columns'))

    return render_template('upload_csv.html')

@routes.route('/data_preview', methods=['GET'])
@login_required
def data_preview():
    """Vista exploratoria automática del CSV cargado."""
    csv_path = session.get('csv_file')
    if not csv_path or not os.path.exists(csv_path):
        flash('❌ No se encontró ningún archivo cargado.', 'danger')
        return redirect(url_for('routes.upload_csv'))

    try:
        df = pd.read_csv(csv_path)
    except Exception as e:
        current_app.logger.error(f"Error al leer CSV: {e}")
        flash('❌ Error al leer el archivo CSV.', 'danger')
        return redirect(url_for('routes.upload_csv'))

    # --- Análisis básico ---
    info = {
        "rows": len(df),
        "columns": len(df.columns),
        "missing_values": int(df.isna().sum().sum()),
        "column_summary": []
    }

    for col in df.columns:
        dtype = str(df[col].dtype)
        nulls = df[col].isna().sum()
        unique = df[col].nunique()
        sample = df[col].dropna().unique()[:3].tolist()
        info["column_summary"].append({
            "name": col,
            "dtype": dtype,
            "nulls": nulls,
            "unique": unique,
            "sample": sample
        })

    # --- Preparar algunos gráficos automáticos ---
    import plotly.express as px

    graphs = []
    try:
        # 1️⃣ Si hay una columna de fecha → gráfica de series
        date_cols = [c for c in df.columns if "fecha" in c.lower() or "date" in c.lower()]
        if date_cols:
            date_col = date_cols[0]
            df[date_col] = pd.to_datetime(df[date_col], errors='coerce')
            num_cols = df.select_dtypes(include='number').columns.tolist()
            if num_cols:
                fig = px.line(df, x=date_col, y=num_cols[0],
                              title=f"Evolución temporal de {num_cols[0]}",
                              markers=True)
                graphs.append(fig.to_html(full_html=False))

        # 2️⃣ Primer numérico con distribución
        num_cols = df.select_dtypes(include='number').columns.tolist()
        if num_cols:
            fig = px.histogram(df, x=num_cols[0], nbins=30,
                               title=f"Distribución de {num_cols[0]}")
            graphs.append(fig.to_html(full_html=False))

        # 3️⃣ Primera columna categórica
        cat_cols = df.select_dtypes(exclude='number').columns.tolist()
        if cat_cols:
            fig = px.bar(df[cat_cols[0]].value_counts().head(10).reset_index(),
                         x='index', y=cat_cols[0],
                         title=f"Top categorías en {cat_cols[0]}")
            graphs.append(fig.to_html(full_html=False))

    except Exception as e:
        current_app.logger.warning(f"Error generando gráficos: {e}")

    return render_template('data_preview.html', info=info, graphs=graphs)

@routes.context_processor
def inject_active_assistant():
    from flask import session
    from app.models import Assistant  # ajusta la ruta según tu estructura
    active_assistant = None
    if current_user.is_authenticated and session.get('active_role') == 'asistente':
        assistant_id = session.get('active_assistant_id')
        if assistant_id:
            active_assistant = Assistant.query.get(assistant_id)
    return dict(active_assistant=active_assistant)

@routes.route('/select_columns', methods=['GET', 'POST'])
@login_required
def select_columns():
    if 'csv_columns' not in session or 'csv_data' not in session:
        flash('❌ No hay datos cargados. Subí un CSV primero.', 'danger')
        return redirect(url_for('routes.upload_csv'))

    columns = session['csv_columns']
    df = pd.DataFrame(session['csv_data'])

    # === PREPARAR DATOS PARA LA VISTA PREVIA ===
    # Mostrar primeras 10 filas, reemplazar NaN por "—"
    preview_df = df.head(10).fillna('—')
    csv_preview = preview_df.to_dict('records')

    # === DETECTAR COLUMNAS NUMÉRICAS ===
    numeric_columns = df.select_dtypes(include='number').columns.tolist()

    if request.method == 'POST':
        x_column = request.form.get('x_column')
        y_column = request.form.get('y_column')
        chart_type = request.form.get('chart_type', 'bar')

        if not x_column or not y_column:
            flash('❌ Debes seleccionar columnas para los ejes X e Y.', 'danger')
            return render_template(
                'select_columns.html',
                columns=columns,
                csv_preview=csv_preview,
                numeric_columns=numeric_columns
            )

        if x_column not in df.columns or y_column not in df.columns:
            flash(f'❌ Columnas no encontradas: X="{x_column}", Y="{y_column}".', 'danger')
            return render_template(
                'select_columns.html',
                columns=columns,
                csv_preview=csv_preview,
                numeric_columns=numeric_columns
            )

        # Validar que Y sea numérica (obligatorio para gráficos)
        if y_column not in numeric_columns:
            flash(f'❌ La columna Y "{y_column}" debe ser numérica (ej: ID, cantidad, horas).', 'danger')
            return render_template(
                'select_columns.html',
                columns=columns,
                csv_preview=csv_preview,
                numeric_columns=numeric_columns
            )

        # === GENERAR GRÁFICO ===
        try:
            title = f'{y_column} vs {x_column}'
            if chart_type == 'line':
                fig = px.line(df, x=x_column, y=y_column, title=title)
            elif chart_type == 'bar':
                fig = px.bar(df, x=x_column, y=y_column, title=title)
            else:  # scatter
                fig = px.scatter(df, x=x_column, y=y_column, title=title)

            graph_html = fig.to_html(full_html=False)
            return render_template('plot.html', graph_html=graph_html)

        except Exception as e:
            flash(f'❌ Error al generar el gráfico: {str(e)}', 'danger')
            return render_template(
                'select_columns.html',
                columns=columns,
                csv_preview=csv_preview,
                numeric_columns=numeric_columns
            )

    # === MÉTODO GET: mostrar formulario + vista previa ===
    return render_template(
        'select_columns.html',
        columns=columns,
        csv_preview=csv_preview,
        numeric_columns=numeric_columns
    )

@routes.route('/clear_csv')
@login_required
def clear_csv():
    session.pop('csv_data', None)
    session.pop('csv_columns', None)
    flash('✅ Datos del CSV eliminados.', 'info')
    return redirect(url_for('routes.upload_csv'))

def enviar_notificacion_telegram(mensaje):
    """
    Envía un mensaje a través del bot de Telegram.
    """
    try:
        token = current_app.config['TELEGRAM_BOT_TOKEN']
        chat_id = current_app.config['TELEGRAM_CHAT_ID']
        
        url = f"https://api.telegram.org/bot{token}/sendMessage"
        payload = {
            'chat_id': chat_id,
            'text': mensaje,
            'parse_mode': 'Markdown'
        }
        
        response = requests.post(url, data=payload, timeout=10)
        
        if response.status_code == 200:
            print("✅ Notificación enviada a Telegram")
            return True
        else:
            print(f"❌ Error en Telegram: {response.status_code} - {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ Error al enviar notificación por Telegram: {str(e)}")
        return False

def enviar_confirmacion_turno(appointment):
    try:
        msg = Message(
            subject="✅ Confirmación de visita",
            recipients=[appointment.patient.email],
            body=f"""
        Hola {appointment.patient.username},
        Tu visita ha sido reservada con éxito:
        🔹 Profesional: {appointment.availability.clinic.doctor.username}
        🔹 Ubicación: {appointment.availability.clinic.name}
        🔹 Dirección: {appointment.availability.clinic.address}
        🔹 Fecha: {appointment.availability.date.strftime('%d/%m/%Y')}
        🔹 Hora: {appointment.availability.time.strftime('%H:%M')}
        Gracias por usar nuestra plataforma.
        ¡Te esperamos!
        Saludos,
        Equipo de FuerzaBruta
        """.strip(),
        html=f"""
        <h2>✅ Confirmación de Visita</h2>
        <p>Hola <strong>{appointment.patient.username}</strong>,</p>
        <p>Tu visita ha sido reservada con éxito:</p>
        <ul>
            <li><strong>Médico:</strong> {appointment.availability.clinic.doctor.username}</li>
            <li><strong>Ubicación:</strong> {appointment.availability.clinic.name}</li>
            <li><strong>Dirección:</strong> {appointment.availability.clinic.address}</li>
            <li><strong>Fecha:</strong> {appointment.availability.date.strftime('%d/%m/%Y')}</li>
            <li><strong>Hora:</strong> {appointment.availability.time.strftime('%H:%M')}</li>
        </ul>
        <p>Gracias por usar nuestra plataforma.<br>
        ¡Te esperamos!</p>
        <p>Saludos,<br>
        <strong>Equipo de FuerzaBruta</strong></p>
        """.strip()
        )
        mail.send(msg)
        return True
    except Exception as e:
        print(f"❌ Error al enviar email: {str(e)}")
        return False

def enviar_notificacion_turno_reservado(appointment):
    """
    Notifica al admin y al profesional cuando se reserva una Visita
    """
    try:
        msg = Message(
            subject="🔔 Nuevo turno reservado",
            recipients=["astiazu@gmail.com"],  # Cambia por tu email de admin
            body=f"""
        Nueva visita reservada:

        Visita/Paciente: {appointment.patient.username}
        Email: {appointment.patient.email}

        Profesional: {appointment.availability.clinic.doctor.username}
        Ubicación: {appointment.availability.clinic.name}
        Dirección: {appointment.availability.clinic.address}
        Fecha: {appointment.availability.date.strftime('%d/%m/%Y')}
        Hora: {appointment.availability.time.strftime('%H:%M')}

        Este mensaje fue generado automáticamente por el sistema.
                    """.strip(),
                    html=f"""
        <h2>🔔 Nueva visita reservada</h2>
        <p><strong>Visita/Paciente:</strong> {appointment.patient.username}</p>
        <p><strong>Email:</strong> {appointment.patient.email}</p>
        <hr>
        <p><strong>Profesional:</strong> {appointment.availability.clinic.doctor.username}</p>
        <p><strong>Ubicación:</strong> {appointment.availability.clinic.name}</p>
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
            subject=f"📅 Nueva visita: {appointment.availability.date.strftime('%d/%m/%Y')} a las {appointment.availability.time.strftime('%H:%M')}",
            recipients=[appointment.availability.clinic.doctor.email],
            body=f"""
        Hola {appointment.availability.clinic.doctor.username},

        Has recibido una nueva reserva de visita:

        Visita/Paciente: {appointment.patient.username}
        Email: {appointment.patient.email}
        Fecha: {appointment.availability.date.strftime('%d/%m/%Y')}
        Hora: {appointment.availability.time.strftime('%H:%M')}
        Ubicación: {appointment.availability.clinic.name}
        Dirección: {appointment.availability.clinic.address}

        ¡Gestiona tus turnos desde tu perfil profesional!

        Saludos,
        Equipo de FuerzaBruta
                    """.strip(),
                    html=f"""
        <h2>📅 Nuevo turno reservado</h2>
        <p><strong>Visita/Paciente:</strong> {appointment.patient.username}</p>
        <p><strong>Email:</strong> {appointment.patient.email}</p>
        <hr>
        <p><strong>Fecha:</strong> {appointment.availability.date.strftime('%d/%m/%Y')}</p>
        <p><strong>Hora:</strong> {appointment.availability.time.strftime('%H:%M')}</p>
        <p><strong>Ubicación:</strong> {appointment.availability.clinic.name}</p>
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

# PUBLICATIONS = [
#     {
#         "id": 1001,
#         "type": "Educativo",
#         "title": "El error más común en análisis de datos",
#         "content": "En mi experiencia como consultor, el error más común que veo...",
#         "image_url": "/static/img/default-article.jpg"
#     },
#     {
#         "id": 1002,
#         "type": "Caso de éxito",
#         "title": "Cómo optimicé un proceso de ETL con Python",
#         "content": "Un cliente tenía un proceso de carga de datos que tardaba 8 horas...",
#         "image_url": "/static/img/default-article.jpg"
#     }
# ]

@routes.route("/")
def index():
    return render_template("index.html", bio_short=BIO_SHORT, bio_extended=BIO_EXTENDED, active_tab="home")

@routes.route('/health')
def health():
    return 'OK', 200

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
    
    # === Estadísticas de visitas (con manejo de errores) ===
    try:
        from app.models import Visit
        total_visits = Visit.query.count()
        today_visits = Visit.query.filter(
            db.func.date(Visit.created_at) == datetime.utcnow().date()
        ).count()

        # Datos para el gráfico: últimas 7 días
        end_date = datetime.utcnow().date()
        start_date = end_date - timedelta(days=6)
        
        visits_by_day = Visit.query.filter(
            db.func.date(Visit.created_at) >= start_date,
            db.func.date(Visit.created_at) <= end_date
        ).all()

        visit_counts = defaultdict(int)
        for visit in visits_by_day:
            visit_counts[visit.created_at.date().isoformat()] += 1

        chart_labels = []
        chart_data = []
        for i in range(7):
            day = (start_date + timedelta(days=i)).isoformat()
            chart_labels.append((start_date + timedelta(days=i)).strftime('%d/%m'))
            chart_data.append(visit_counts.get(day, 0))
    except Exception as e:
        current_app.logger.error(f"Error en estadísticas de visitas: {e}")
        total_visits = 0
        today_visits = 0
        chart_labels = []
        chart_data = []

    # === Resto de las estadísticas ===
    from flask import current_app  # ✅ Correcto
    
    pending_notes = Note.query.filter_by(status=NoteStatus.PENDING).all()
    published_notes = Note.query.filter_by(status=NoteStatus.PUBLISHED).all()
    all_publications = Publication.query.all()
    all_roles = UserRole.query.all()
    total_users = User.query.count()
    total_subscribers = Subscriber.query.count()

    return render_template(
        "admin/admin_panel.html",
        pending_notes=pending_notes,
        published_notes=published_notes,
        all_publications=all_publications,
        all_roles=all_roles,
        total_users=total_users,
        total_subscribers=total_subscribers,
        bio_short=BIO_SHORT,
        bio_extended=BIO_EXTENDED,
        total_visits=total_visits,
        today_visits=today_visits,
        chart_labels=chart_labels,
        chart_data=chart_data
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

@routes.route('/webhook-telegram', methods=['POST'])
def webhook_telegram():
    """
    Webhook que recibe actualizaciones del bot de Telegram
    """
    try:
        data = request.get_json()
        if not data or 'message' not in data:
            return jsonify({"status": "ignored"}), 200

        message = data['message']
        chat_id = message['chat']['id']
        text = message.get('text', '').strip()

        # Solo procesamos comandos
        if not text.startswith('/'):
            respuesta = (
                "Hola 👋\n\n"
                "Soy el asistente virtual de DatosConsultora.\n\n"
                "Usa:\n"
                "🔹 /start - Para comenzar\n"
                "🔹 /registrar_asistente [tu_nombre] - Para vincular tu cuenta"
            )
            send_telegram_message(chat_id, respuesta)
            return jsonify({"status": "ok"}), 200

        command_parts = text.split()
        command = command_parts[0]

        if command == '/start':
            respuesta = (
                "✅ Bienvenido al sistema de notificaciones de DatosConsultora.\n\n"
                "Si eres un asistente registrado en la plataforma, usa:\n"
                "`/registrar_asistente tu_nombre_completo`\n\n"
                "Ejemplo:\n"
                "`/registrar_asistente Mabel Pérez`"
            )
            send_telegram_message(chat_id, respuesta)

        elif command == '/registrar_asistente':
            if len(command_parts) < 2:
                send_telegram_message(chat_id, "❌ Usa: `/registrar_asistente tu_nombre`")
                return jsonify({"status": "error"}), 200

            nombre_solicitado = " ".join(command_parts[1:]).strip()

            # Verificar si ya está vinculado desde este chat
            existing_assistant = Assistant.query.filter_by(telegram_id=str(chat_id)).first()
            if existing_assistant:
                send_telegram_message(
                    chat_id,
                    f"🟢 Ya estás vinculado como *{existing_assistant.name}*.\n"
                    "No es necesario registrarte nuevamente."
                )
                return jsonify({"status": "ok"}), 200

            # Buscar al asistente por nombre (parcial) y asegurar que pertenezca a un médico activo
            assistant = Assistant.query.join(User).filter(
                Assistant.name.ilike(f"%{nombre_solicitado}%"),
                User.is_professional == True
            ).first()

            if not assistant:
                send_telegram_message(
                    chat_id,
                    f"❌ No se encontró un asistente llamado '{nombre_solicitado}'. "
                    "Verifica el nombre e inténtalo de nuevo."
                )
                return jsonify({"status": "error"}), 200

            # Evitar duplicados: si otro asistente ya tiene este chat_id
            duplicate = Assistant.query.filter(
                Assistant.telegram_id == str(chat_id),
                Assistant.id != assistant.id
            ).first()
            if duplicate:
                send_telegram_message(
                    chat_id,
                    f"⚠️ Este dispositivo ya está vinculado a *{duplicate.name}*.\n"
                    "Contacta al administrador si necesitas cambiarlo."
                )
                return jsonify({"status": "error"}), 200

            # ✅ Vincular el asistente al chat_id
            old_telegram_id = assistant.telegram_id
            assistant.telegram_id = str(chat_id)
            
            try:
                db.session.commit()
                print(f"✅ Vinculado: {assistant.name} -> {assistant.telegram_id}")

                # Confirmación clara al usuario
                send_telegram_message(
                    chat_id,
                    f"✅ ¡Éxito! {assistant.name}, has sido vinculado correctamente.\n\n"
                    "Ahora recibirás notificaciones de tareas asignadas.\n\n"
                    "Gracias por usar el sistema de DatosConsultora."
                )

                # Notificar al médico
                try:
                    medico = User.query.get(assistant.doctor_id)
                    if medico and medico.is_professional:
                        msg = f"🟢 {assistant.name} ha vinculado su cuenta de Telegram."
                        enviar_notificacion_telegram(msg)
                except Exception as e:
                    print(f"Error al notificar al médico: {e}")

            except Exception as e:
                db.session.rollback()
                print(f"❌ Error al guardar en DB: {e}")
                send_telegram_message(
                    chat_id,
                    "❌ Hubo un error al registrar tu cuenta. Intenta más tarde."
                )
                return jsonify({"status": "error"}), 500

        return jsonify({"status": "ok"}), 200

    except Exception as e:
        print(f"Error en webhook Telegram: {e}")
        return jsonify({"status": "error", "error": str(e)}), 500
    
@routes.route("/publications")
def publications():
    # Filtros generales
    q = request.args.get('q', '').strip()
    category = request.args.get('category', '')

    # Consulta base: solo publicadas
    db_query = Publication.query.filter_by(is_published=True)

    if q:
        db_query = db_query.filter(
            Publication.title.ilike(f"%{q}%") |
            Publication.content.ilike(f"%{q}%") |
            Publication.tags.ilike(f"%{q}%")
        )
    
    if category:
        db_query = db_query.filter_by(type=category)
    
    all_publications = db_query.order_by(Publication.published_at.desc()).all()

    # Lista combinada (DB + estáticas si existen)
    combined = []
    for pub in all_publications:
        if not pub.published_at:
            pub.published_at = pub.created_at or datetime.utcnow()
        combined.append({
            "id": pub.id,
            "type": pub.type,
            "title": pub.title,
            "content": (pub.excerpt or pub.content[:200]) + "..." if len(pub.content) > 200 else pub.content,
            "published_at": pub.published_at,
            "author": pub.author.username if pub.author else "José Luis Astiazu",
            "is_db": True,
            "image_url": pub.image_url or "/static/img/default-article.jpg",
            "view_count": pub.view_count or 0
        })

    if 'PUBLICATIONS' in globals():
        for pub in publications:
            if category and pub.get("type") != category:
                continue
            combined.append({
                "id": pub["id"],
                "type": pub["type"],
                "title": pub["title"],
                "content": pub["content"][:200] + "...",
                "published_at": pub.get("published_at", datetime.now()),
                "author": "José Luis Astiazu",
                "is_db": False,
                "image_url": pub.get("image_url", "/static/img/default-article.jpg"),
                "view_count": pub.get("view_count", 0)
            })

    # Ordenar por fecha
    combined.sort(key=lambda x: x["published_at"], reverse=True)

    # Sección 1: Carrusel (3 primeras)
    carousel_items = combined[:3]

    # Sección 2: Publicación principal + 4 tarjetas
    main_pub = combined[0] if combined else None
    side_pubs = combined[1:5]  # 4 siguientes

    # Sección 3: Resto de publicaciones
    rest_pubs = combined[5:]

    # Sección 4: Sociales y Cultura (por tipo o etiquetas)
    social_culture_tags = ['social', 'cultura', 'arte', 'música', 'teatro']
    sociales_y_cultura = [
        p for p in combined 
        if 'social' in p['type'].lower() or any(tag in (p.get('tags') or '').lower() for tag in social_culture_tags)
    ]

    # Sección 5: Deportes
    deportes_tags = ['deporte', 'fútbol', 'tenis', 'atletismo', 'natación']
    deportes = [
        p for p in combined 
        if 'deporte' in p['type'].lower() or any(tag in (p.get('tags') or '').lower() for tag in deportes_tags)
    ]

    return render_template(
        "publications.html",
        carousel_items=carousel_items,
        main_pub=main_pub,
        side_pubs=side_pubs,
        rest_pubs=rest_pubs,
        sociales_y_cultura=sociales_y_cultura,
        deportes=deportes,
        bio_short=BIO_SHORT,
        bio_extended=BIO_EXTENDED,
        active_tab="publications",
        selected_category=category,
        search_query=q
    )

@routes.route('/admin/publication/new', methods=['GET', 'POST'])
@require_admin
def new_publication():
    # ✅ Asegurar que la carpeta existe / para local:
    # upload_folder = 'static/uploads'
    # if not os.path.exists(upload_folder):
    #    os.makedirs(upload_folder, exist_ok=True)

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

        # ✅ Manejo de imagen subida para local:
        # if 'image_file' in request.files:
        #     file = request.files['image_file']
        #     if file.filename != '':
        #         filename = secure_filename(f"pub_{publication.id}_{int(time.time())}.jpg")
        #         filepath = os.path.join('static/uploads', filename)
        #         file.save(filepath)
        #         publication.image_url = f"/static/uploads/{filename}"

                # ✅ Manejo de imagen subida
        if 'image_file' in request.files:
            file = request.files['image_file']
            if file.filename != '':
                # Guardar temporalmente
                temp_dir = 'temp_uploads'
                os.makedirs(temp_dir, exist_ok=True)
                temp_path = os.path.join(temp_dir, secure_filename(file.filename))
                file.save(temp_path)

                # Subir a Cloudinary
                image_url = upload_to_cloudinary(temp_path, folder="publications")

                # Limpiar archivo temporal
                os.remove(temp_path)

                if image_url:
                    publication.image_url = image_url  # ✅ Guarda URL de Cloudinary


        db.session.commit()
        flash('✅ Publicación creada exitosamente', 'success')
        return redirect(url_for('routes.admin_panel'))

    return render_template('edit_publication.html', publication=None, bio_short=BIO_SHORT, bio_extended=BIO_EXTENDED)

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
    
    # ✅ Incrementar contador de vistas
    if publication.view_count is None:
        publication.view_count = 0
    publication.view_count += 1
    db.session.commit()

    return render_template(
        'view_publication.html',
        publication=publication,
        bio_short=BIO_SHORT,
        bio_extended=BIO_EXTENDED 
    )

@routes.route('/admin/publication/<int:pub_id>/edit', methods=['GET', 'POST'])
@require_admin
def edit_publication(pub_id):
    # ✅ Asegurar que la carpeta existe para local:
    # upload_folder = 'static/uploads'
    # if not os.path.exists(upload_folder):
    #     os.makedirs(upload_folder, exist_ok=True)


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
        # if 'image_file' in request.files and request.files['image_file'].filename != '':
        #     file = request.files['image_file']
            
        #     # Eliminar imagen anterior si existe
        #     if publication.image_url and os.path.exists('.' + publication.image_url):
        #         os.remove('.' + publication.image_url)
            
        #     # Guardar nueva imagen
        #     filename = secure_filename(f"pub_{publication.id}_{int(time.time())}.jpg")
        #     filepath = os.path.join('static/uploads', filename)
        #     file.save(filepath)
        #     publication.image_url = f"/static/uploads/{filename}"

        # ✅ Si no se sube nueva imagen, conserva la anterior
        # (no se hace nada, ya está en publication.image_url)
                # ✅ Manejo de imagen: solo si se sube una nueva
        if 'image_file' in request.files and request.files['image_file'].filename != '':
            file = request.files['image_file']
            
            # Guardar temporalmente
            temp_dir = 'temp_uploads'
            os.makedirs(temp_dir, exist_ok=True)
            temp_path = os.path.join(temp_dir, secure_filename(file.filename))
            file.save(temp_path)

            # Subir a Cloudinary
            image_url = upload_to_cloudinary(temp_path, folder="publications")

            # Limpiar archivo temporal
            os.remove(temp_path)

            if image_url:
                publication.image_url = image_url  # ✅ Reemplaza con nueva URL

        # ✅ Si no se sube nueva imagen, conserva la anterior (no hace nada)

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

@routes.route('/publicaciones-destacadas')
def destacadas():
    destacadas = Publication.query.filter_by(is_published=True).order_by(Publication.view_count.desc()).limit(5).all()
    return render_template(
        'destacadas.html',
        destacadas=destacadas,
        bio_short=BIO_SHORT,
        bio_extended=BIO_EXTENDED,
        active_tab="destacadas"
    )

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
    # Obtener email del usuario autenticado o de la sesión
    current_user_email = current_user.email if current_user.is_authenticated else None
    session_email = session.get('subscriber_email')

    # Verificar si el email del usuario está en subscribers
    is_subscriber_db = False
    if current_user_email:
        is_subscriber_db = Subscriber.query.filter_by(email=current_user_email).first() is not None

    # Verificar si el email en sesión está en subscribers
    is_subscriber_session = False
    if session_email:
        is_subscriber_session = Subscriber.query.filter_by(email=session_email).first() is not None

    # Puede ver si: está registrado (User) o su email está en subscribers
    can_view = current_user.is_authenticated or is_subscriber_db or is_subscriber_session

    # depurar
    #print(f"Email del usuario actual: {current_user_email}")
    #print(f"Email en sesión (suscriptor): {session_email}")
    #print(f"¿Email de usuario en subscribers? {is_subscriber_db}")
    #print(f"¿Email de sesión en subscribers? {is_subscriber_session}")
    #print(f"¿Puede ver el contenido? {can_view}")

    # ✅ Verificar si el usuario es suscriptor 
    if 'subscriber_email' in session:
        subscriber = Subscriber.query.filter_by(email=session['subscriber_email']).first()
        is_subscriber = subscriber is not None
    else:
        is_subscriber = False

    #print(f"is_subscriber: {is_subscriber}")
    
    # ✅ Verificar permisos
    if note.status == NoteStatus.PUBLISHED:
        # Si es nota pública, cualquiera puede verla (pero vamos a registrar vistas)
        can_view = True
    else:
        # Si es privada o pendiente, solo dueño o admin
        if not current_user.is_authenticated:
            can_view = False
        else:
            can_view = (note.user_id == current_user.id or current_user.is_admin)
    
    if is_subscriber_db or current_user_email:
        can_view = True

    if not can_view:
        flash("Regístrate o suscríbete para acceder al contenido exclusivo.", "info")
        return redirect(url_for('routes.profesionales'))

    # ✅ Solo aumentar vistas si es PUBLISHED
    if note.status == NoteStatus.PUBLISHED:
        note.view_count += 1
        db.session.commit()

    return render_template(
        "view_note.html",
        note=note,
        bio_short=BIO_SHORT,
        bio_extended=BIO_EXTENDED
    )

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

        # ✅ Subir imagen a Cloudinary si hay archivo
        featured_image = None
        if upload_image and upload_image.filename != '':
            if upload_image.filename.lower().endswith(('.png', '.jpg', '.jpeg', '.gif')):
                # Guardar temporalmente
                temp_dir = 'temp_uploads'
                os.makedirs(temp_dir, exist_ok=True)
                temp_path = os.path.join(temp_dir, secure_filename(upload_image.filename))
                upload_image.save(temp_path)

                # Subir a Cloudinary
                try:
                    response = cloudinary.uploader.upload(
                        temp_path,
                        folder="notes",
                        transformation=[
                            {'width': 800, 'height': 600, 'crop': 'limit'},
                            {'quality': 'auto:good'}
                        ]
                    )
                    featured_image = response['secure_url']
                except Exception as e:
                    db.session.rollback()
                    flash('❌ Error al subir la imagen a Cloudinary', 'danger')
                    print(f"Error Cloudinary: {e}")
                    return render_template('edit_note.html', note=note, bio_short=BIO_SHORT, bio_extended=BIO_EXTENDED)
                finally:
                    # Limpiar archivo temporal
                    if os.path.exists(temp_path):
                        os.remove(temp_path)
            else:
                flash('Formato de imagen no permitido. Usa JPG, PNG o GIF.', 'warning')

        # ✅ Si no se subió archivo pero hay URL
        elif image_url:
            featured_image = image_url

        # ✅ Actualizar o crear nota
        if note:
            note.title = title
            note.content = content
            if featured_image:
                note.featured_image = featured_image
            db.session.commit()
            flash('✅ Nota actualizada', 'success')
        else:
            new_note = Note(
                title=title,
                content=content,
                user_id=current_user.id,
                status=NoteStatus.PRIVATE,
                featured_image=featured_image
            )
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
    return render_template("/upload_csv.html", bio_short=BIO_SHORT, bio_extended=BIO_EXTENDED, active_tab="data_analysis")

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
    
@routes.route('/como-funciona')
def como_funciona():
    return render_template('funcionales/como_funciona.html')

@routes.route("/profesionales")
def profesionales():
    category = request.args.get('category', '')
    
    # Si no hay categoría, mostramos los 3 tipos
    if not category:
        # Asumiendo que tenés un campo `user_type` o `role_name`
        query = User.query.filter(
            (User.is_professional == True) #|(User.is_entrepreneur == True) |(User.is_pyme == True)
        )
    else:
        # Filtrar por categoría específica
        if category == "Profesional":
            query = User.query.filter_by(is_professional=True)
        elif category == "Emprendedor":
            query = User.query.filter_by(is_entrepreneur=True)
        elif category == "PyME":
            query = User.query.filter_by(is_pyme=True)
        else:
            query = User.query.filter_by(is_professional=True)  # fallback
    
    professionals = query.all()
    categories = ["Profesional", "Emprendedor", "PyME"]

    all_professionals = User.query.filter(
        User.is_professional == True,
        User.profile_photo.isnot(None),
        User.profile_photo != ''
    ).order_by(User.username).all()

    return render_template(
        'profesionales.html',
        professionals=professionals,      # para el listado filtrado
        all_professionals=all_professionals,  # ✅ para el slider
        categories=categories,
        selected_category=category
    )

# Perfil público más completo
@routes.route('/profesional/<string:url_slug>')
def perfil_profesional(url_slug):
    # Buscar el profesional
    professional = User.query.filter_by(
        url_slug=url_slug, 
        is_professional=True
    ).first_or_404()

    # Verificar si el usuario está logueado y es el dueño del perfil
    if current_user.is_authenticated:
        if current_user.id == professional.id:
            return redirect(url_for('routes.mi_perfil'))

    # Cargar consultorios activos del profesional
    clinics = Clinic.query.filter_by(
        doctor_id=professional.id, 
        is_active=True
    ).all()

    # Cargar notas publicadas o pendientes del profesional
    published_notes = Note.query.filter(
        Note.user_id == professional.id,
        Note.status.in_([NoteStatus.PUBLISHED, NoteStatus.PRIVATE, NoteStatus.PENDING])
    ).order_by(Note.approved_at.desc().nullslast(), Note.created_at.desc()).all()

    # ✅ Cargar eventos públicos del profesional
    from datetime import datetime
    current_time = datetime.utcnow()
    events = Event.query.filter(
        Event.doctor_id == professional.id,
        Event.is_public == True,
        Event.start_datetime >= current_time
    ).order_by(Event.start_datetime.asc()).all()

    # Renderizar el template
    return render_template(
        'public/perfil_profesional.html',
        doctor=professional,
        clinics=clinics,
        published_notes=published_notes,
        events=events,  # ✅ Pasar los eventos al template
        active_tab='profesionales'
    )

# @routes.route('/mi-perfil')
# @login_required
# def mi_perfil():
#     if session.get('active_role') != 'profesional':
#         flash("Acceso denegado", "danger")
#         return redirect(url_for('routes.seleccionar_perfil'))
    
#     if not current_user.is_professional and not current_user.is_admin:
#         flash('Acceso denegado', 'danger')
#         return redirect(url_for('routes.index'))

#     # ✅ Cargar consultorios del profesional actual
#     from app.models import Clinic, Task, Assistant, Appointment, Availability
#     clinics = Clinic.query.filter_by(doctor_id=current_user.id, is_active=True).all()

#     # ✅ Obtener todas las tareas de mis asistentes
#     all_tasks = Task.query.join(Assistant).filter(Assistant.doctor_id == current_user.id).all()
#     pending_tasks_count = sum(1 for task in all_tasks if task.status == 'pending')

#     # ✅ Turnos recibidos
#     turnos_recibidos = []
#     clinicas_ids = [c.id for c in clinics]  # ✅ Usa la lista ya cargada
#     if clinicas_ids:
#         turnos_recibidos = Appointment.query.join(Availability).filter(
#             Availability.clinic_id.in_(clinicas_ids)
#         ).order_by(Appointment.created_at.desc()).all()

#     return render_template(
#         'mi_perfil_medico.html',
#         user=current_user,
#         clinics=clinics,  # ← ¡Esto es lo nuevo!
#         turnos_recibidos=turnos_recibidos,
#         bio_short=BIO_SHORT,
#         bio_extended=BIO_EXTENDED,
#         pending_tasks_count=pending_tasks_count,
#         total_tasks=len(all_tasks)
#     )

@routes.route('/mi-perfil')
@login_required
def mi_perfil():
    if session.get('active_role') != 'profesional':
        flash("Acceso denegado", "danger")
        return redirect(url_for('routes.seleccionar_perfil'))
    
    # if not current_user.is_professional and not current_user.is_admin:
    #     flash('Acceso denegado', 'danger')
    #     return redirect(url_for('routes.index'))

    # Cargar consultorios del profesional actual
    clinics = Clinic.query.filter_by(doctor_id=current_user.id, is_active=True).all()
    
    # Obtener todas las tareas de mis asistentes
    all_tasks = Task.query.join(Assistant).filter(Assistant.doctor_id == current_user.id).all()
    pending_tasks_count = sum(1 for task in all_tasks if task.status == 'pending')

    # Turnos recibidos
    turnos_recibidos = []
    clinicas_ids = [c.id for c in clinics]
    if clinicas_ids:
        turnos_recibidos = Appointment.query.join(Availability).filter(
            Availability.clinic_id.in_(clinicas_ids)
        ).order_by(Appointment.created_at.desc()).all()

    # Cargar eventos del profesional
    from datetime import datetime
    current_time = datetime.utcnow()
    events = Event.query.filter(
        Event.doctor_id == current_user.id,
        Event.start_datetime >= current_time
    ).order_by(Event.start_datetime.asc()).all()

    return render_template(
        'mi_perfil_medico.html',
        user=current_user,
        events=events,
        clinics=clinics,
        turnos_recibidos=turnos_recibidos,
        pending_tasks_count=pending_tasks_count,
        total_tasks=len(all_tasks)
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

        # ✅ Subir imagen a Cloudinary
        if 'profile_photo' in request.files:
            file = request.files['profile_photo']
            if file.filename != '':
                if file.filename.lower().endswith(('.png', '.jpg', '.jpeg', '.gif')):
                    # Guardar temporalmente
                    temp_dir = 'temp_uploads'
                    os.makedirs(temp_dir, exist_ok=True)
                    temp_path = os.path.join(temp_dir, secure_filename(file.filename))
                    file.save(temp_path)

                    # Subir a Cloudinary
                    try:
                        import cloudinary.uploader
                        response = cloudinary.uploader.upload(
                            temp_path,
                            folder="profiles",
                            public_id=f"profile_{current_user.id}",
                            overwrite=True,
                            transformation=[
                                {'width': 400, 'height': 400, 'crop': 'fill'},
                                {'quality': 'auto:good'}
                            ]
                        )
                        current_user.profile_photo = response['secure_url']  # ✅ URL de Cloudinary
                    except Exception as e:
                        flash('❌ Error al subir la imagen', 'danger')
                        print(f"Error Cloudinary: {e}")
                    finally:
                        # Limpiar archivo temporal
                        if os.path.exists(temp_path):
                            os.remove(temp_path)
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

@routes.route('/perfil-equipo')
@login_required
def perfil_equipo():
    # Si está en modo asistente, mostrar el perfil del equipo donde trabaja
    if session.get('active_role') == 'asistente':
        assistant_id = session.get('active_assistant_id')
        if not assistant_id:
            flash("Rol no válido", "warning")
            return redirect(url_for('routes.seleccionar_perfil'))

        assistant = Assistant.query.get(assistant_id)
        if not assistant or assistant.user_id != current_user.id:
            flash("Asistente no válido", "danger")
            return redirect(url_for('routes.index'))

        doctor = assistant.doctor
        clinic = assistant.clinic

        return render_template(
            'perfil_equipo.html',
            team_name=doctor.username,
            clinic=clinic,
            role="Asistente General",
            start_date=assistant.created_at,
            total_tasks=Task.query.filter_by(assistant_id=assistant.id).count(),
            pending_tasks=Task.query.filter_by(assistant_id=assistant.id).filter(
                Task.status.in_(['pending', 'in_progress'])
            ).count()
        )

    # Si es dueño, mostrar su perfil normal
    return redirect(url_for('routes.mi_perfil'))

@routes.route('/profesional/<int:user_id>/contactar')
def contactar_profesional(user_id):
    profesional = User.query.get_or_404(user_id)
    # Solo permitimos contacto con el dueño del sitio (user_id=2) desde esta sección
    if user_id != 2:
        # Opcional: redirigir o abortar si se intenta acceder a otro ID
        return redirect(url_for('routes.contactar_profesional', user_id=2))
    
    servicio = request.args.get('servicio')
    return render_template('contactar_profesional.html', profesional=profesional, servicio=servicio)

@routes.route('/servicios/<servicio>')
def servicio_detalle(servicio):
    if servicio == 'inteligencia-comercial':
        return render_template('servicios/inteligencia_comercial.html')
    else:
        abort(404)

@routes.route('/profesional/<int:user_id>/mensaje', methods=['POST'])
@login_required
def enviar_mensaje(user_id):
    profesional = User.query.get_or_404(user_id)
    # Aquí procesarías el formulario: guardar en DB, enviar notificación, etc.
    flash("✅ Mensaje enviado. El profesional se contactará a la brevedad.", "success")
    return redirect(url_for('routes.perfil_profesional', url_slug=profesional.url_slug))

@routes.route('/consultorio/nuevo', methods=['GET', 'POST'])
@login_required
def nuevo_consultorio():
    doctor_id = None
    active_assistant = None

    # === Determinar quién es el doctor del equipo ===
    if session.get('active_role') == 'asistente':
        assistant_id = session.get('active_assistant_id')
        if assistant_id:
            active_assistant = Assistant.query.filter_by(
                id=assistant_id,
                user_id=current_user.id
            ).first()
        if active_assistant and active_assistant.doctor_id:
            doctor_id = active_assistant.doctor_id
    elif current_user.is_professional:
        doctor_id = current_user.id

    if not doctor_id:
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.index'))

    # ✅ Siempre crear el formulario (Flask-WTF lo maneja automáticamente)
    form = ClinicForm()

    if form.validate_on_submit():
        name = form.name.data.strip()
        address = form.address.data.strip()
        phone = form.phone.data.strip()
        specialty = form.specialty.data.strip()

        # Prevenir duplicados: mismo nombre + dirección en el mismo equipo
        existing = Clinic.query.filter_by(
            doctor_id=doctor_id,
            name=name,
            address=address
        ).first()
        if existing:
            flash('Ya existe una ubicación con ese nombre y dirección en tu equipo.', 'warning')
        else:
            # Truncar specialty a 50 caracteres (protección adicional)
            if len(specialty) > 50:
                specialty = specialty[:50]

            try:
                clinic = Clinic(
                    name=name,
                    address=address,
                    phone=phone,
                    specialty=specialty,
                    doctor_id=doctor_id,
                    is_active=True
                )
                db.session.add(clinic)
                db.session.commit()
                flash('✅ Ubicación creada exitosamente.', 'success')
                return redirect(url_for('routes.mi_perfil'))

            except Exception as e:
                db.session.rollback()
                current_app.logger.error(f"Error inesperado al crear consultorio: {str(e)}", exc_info=True)
                flash('❌ Ocurrió un error al guardar la ubicación. Inténtalo nuevamente.', 'danger')

    # ✅ Siempre pasa 'form' al template
    return render_template('nuevo_consultorio.html', form=form)

@routes.route('/consultorio/<int:clinic_id>/editar', methods=['GET', 'POST'])
@login_required
def editar_consultorio(clinic_id):
    clinic = Clinic.query.get_or_404(clinic_id)

    # === Verificar acceso al equipo ===
    allowed = False
    doctor_id = None

    if session.get('active_role') == 'asistente':
        assistant_id = session.get('active_assistant_id')
        if assistant_id:
            active_assistant = Assistant.query.filter_by(
                id=assistant_id,
                user_id=current_user.id
            ).first()
            if active_assistant and active_assistant.type == 'general' and clinic.doctor_id == active_assistant.doctor_id:
                allowed = True
                doctor_id = active_assistant.doctor_id
    elif current_user.is_professional and clinic.doctor_id == current_user.id:
        allowed = True
        doctor_id = current_user.id

    if not allowed:
        flash("Acceso denegado", "danger")
        return redirect(url_for('routes.mi_agenda'))

    if request.method == 'POST':
        name = request.form.get('name', '').strip()
        address = request.form.get('address', '').strip()
        phone = request.form.get('phone', '').strip()
        specialty = request.form.get('specialty', '').strip()

        if not name or not address:
            flash("Nombre y dirección son obligatorios", "error")
        else:
            clinic.name = name
            clinic.address = address
            clinic.phone = phone
            clinic.specialty = specialty
            db.session.commit()
            flash("✅ La ubicación fue actualizada correctamente", "success")
            return redirect(url_for('routes.mi_agenda'))

    return render_template('editar_consultorio.html', clinic=clinic)

@routes.route('/consultorio/<int:clinic_id>/eliminar', methods=['POST'])
@login_required
def eliminar_consultorio(clinic_id):
    clinic = Clinic.query.get_or_404(clinic_id)

    # === Verificar acceso al equipo ===
    allowed = False

    if session.get('active_role') == 'asistente':
        assistant_id = session.get('active_assistant_id')
        if assistant_id:
            active_assistant = Assistant.query.filter_by(
                id=assistant_id,
                user_id=current_user.id
            ).first()
            if active_assistant and active_assistant.type == 'general' and clinic.doctor_id == active_assistant.doctor_id:
                allowed = True
    elif current_user.is_professional and clinic.doctor_id == current_user.id:
        allowed = True

    if not allowed:
        flash("Acceso denegado", "danger")
        return redirect(url_for('routes.mi_agenda'))

    try:
        # Eliminar primero las agendas y disponibilidad
        Schedule.query.filter_by(clinic_id=clinic_id).delete()
        Availability.query.filter_by(clinic_id=clinic_id).delete()
        
        db.session.delete(clinic)
        db.session.commit()
        flash("🗑️ La ubicación fue eliminada correctamente", "info")
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"Error eliminando consultorio: {str(e)}", exc_info=True)
        flash("❌ Error al eliminar la ubicación", "danger")

    return redirect(url_for('routes.mi_agenda'))

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

@routes.route('/turno/empezar/<int:appointment_id>')
@login_required
def empezar_turno(appointment_id):
    if not current_user.is_professional:
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.index'))

    appointment = Appointment.query.get_or_404(appointment_id)
    clinic = appointment.availability.clinic

    if clinic.doctor_id != current_user.id:
        flash('No puedes modificar este turno', 'danger')
        return redirect(url_for('routes.mi_agenda'))

    appointment.status = 'in_progress'
    db.session.commit()
    flash(f'🟢 Turno iniciado: {appointment.patient.username}', 'info')
    return redirect(url_for('routes.mi_agenda'))


@routes.route('/turno/finalizar/<int:appointment_id>')
@login_required
def finalizar_turno(appointment_id):
    appointment = Appointment.query.get_or_404(appointment_id)
    clinic = appointment.availability.clinic

    if clinic.doctor_id != current_user.id:
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.mi_agenda'))

    appointment.status = 'completed'
    db.session.commit()
    flash(f'✅ Turno completado: {appointment.patient.username}', 'success')
    return redirect(url_for('routes.mi_agenda'))


@routes.route('/turno/cancelar/<int:appointment_id>', methods=['POST'])
@login_required
def cancelar_turno(appointment_id):
    appointment = Appointment.query.get_or_404(appointment_id)
    clinic = appointment.availability.clinic

    if clinic.doctor_id != current_user.id:
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.mi_agenda'))

    appointment.status = 'cancelled'
    db.session.commit()
    flash(f'❌ Turno cancelado: {appointment.patient.username}', 'info')
    return redirect(url_for('routes.mi_agenda'))

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
    try:
        # Obtener días disponibles
        available_days = Availability.query.filter(
            Availability.clinic_id == clinic_id,
            Availability.date >= datetime.utcnow().date(),
            Availability.is_booked == False
        ).distinct(Availability.date).all()

        # Convertir fechas a formato YYYY-MM-DD y ordenarlas
        available_dates = sorted({day.date.strftime('%Y-%m-%d') for day in available_days})

        # Obtener eventos próximos del profesional
        events = Event.query.filter(
            Event.doctor_id == doctor_id,
            Event.start_datetime >= datetime.utcnow(),
            Event.is_public == True
        ).all()

        # Formatear eventos para el frontend
        event_data = [
            {
                "title": event.title,
                "start": event.start_datetime.strftime('%Y-%m-%d'),
                "end": event.end_datetime.strftime('%Y-%m-%d') if event.end_datetime else None,
                "url": url_for('routes.view_event', event_id=event.id)
            }
            for event in events
        ] if events else []

        # Devolver respuesta JSON
        response = jsonify({
            "available_days": available_dates,
            "events": event_data
        })

        # Imprimir la respuesta para depuración
        print("Respuesta JSON:", response.get_json())

        return response

    except SQLAlchemyError as e:
        # Capturar errores de base de datos
        print(f"Error en la base de datos: {e}")
        return jsonify({"error": "Error al cargar los datos"}), 500
    
@routes.route('/api/eventos/<int:doctor_id>/<int:clinic_id>/<string:date>')
def api_eventos(doctor_id, clinic_id, date):
    try:
        # Convertir la fecha recibida en un objeto datetime
        selected_date = datetime.strptime(date, '%Y-%m-%d')

        # Obtener eventos/turnos para el día seleccionado
        eventos = Event.query.filter(
            Event.doctor_id == doctor_id,
            Event.clinic_id == clinic_id,
            Event.start_datetime >= selected_date,
            Event.start_datetime < selected_date + timedelta(days=1)  # Filtrar por el mismo día
        ).all()

        # Formatear los eventos para el frontend
        evento_data = [
            {
                "title": evento.title,
                "time": evento.start_datetime.strftime('%H:%M'),  # Hora del evento
                "status": "Confirmado" if evento.is_confirmed else "Pendiente"
            }
            for evento in eventos
        ]

        # Devolver respuesta JSON
        return jsonify(evento_data)

    except SQLAlchemyError as e:
        # Capturar errores de base de datos
        print(f"Error en la base de datos: {e}")
        return jsonify({"error": "Error al cargar los datos"}), 500
    
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
    # === Determinar doctor_id según rol activo ===
    doctor_id = None
    active_assistant = None

    if session.get('active_role') == 'asistente':
        assistant_id = session.get('active_assistant_id')
        if assistant_id:
            active_assistant = Assistant.query.filter_by(
                id=assistant_id,
                user_id=current_user.id
            ).first()

        if active_assistant and active_assistant.doctor_id:
            doctor_id = active_assistant.doctor_id
    elif current_user.is_professional:
        doctor_id = current_user.id

    if not doctor_id:
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.index'))

    # Obtener datos del equipo actual (MaicaiPeques o tu clínica)
    clinics = Clinic.query.filter_by(doctor_id=doctor_id, is_active=True).all()
    schedules = Schedule.query.filter_by(doctor_id=doctor_id, is_active=True).all()

    # Consulta optimizada con joins explícitos
    try:
        appointments = db.session.query(
            Appointment,
            Availability,
            User  # paciente
        ).select_from(Appointment)\
         .join(Availability)\
         .join(Clinic)\
         .join(User, User.id == Appointment.patient_id)\
         .filter(Clinic.doctor_id == doctor_id)\
         .order_by(Availability.date, Availability.time)\
         .all()

    except Exception as e:
        current_app.logger.error(f"Error al obtener turnos: {e}")
        flash('Hubo un problema al cargar los turnos.', 'warning')
        appointments = []

    days = {
        0: 'Lunes', 1: 'Martes', 2: 'Miércoles',
        3: 'Jueves', 4: 'Viernes', 5: 'Sábado', 6: 'Domingo'
    }

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

@routes.route('/admin/users')
@require_admin
def admin_users():
    users = User.query.all()
    total_admins = User.query.filter_by(is_admin=True).count()  # ✅ Calcula aquí
    return render_template('admin/users.html', users=users, total_admins=total_admins)

@routes.route('/admin/users/<int:user_id>/edit', methods=['GET', 'POST'])
@require_admin
def admin_edit_user(user_id):
    user = User.query.get_or_404(user_id)
    total_admins = User.query.filter_by(is_admin=True).count()
    can_delete = not user.is_admin or total_admins > 1

    if request.method == 'POST':
        user.username = request.form.get('username', '').strip()
        user.email = request.form.get('email', '').strip()
        user.is_professional = 'is_professional' in request.form
        user.is_admin = 'is_admin' in request.form
        user.role_id = request.form.get('role_id', type=int)

        # ✅ Cambiar contraseña si se ingresa una nueva
        password = request.form.get('password', '').strip()
        if password:
            user.set_password(password)

        try:
            db.session.commit()
            flash('✅ Usuario actualizado', 'success')
            return redirect(url_for('routes.admin_users'))
        except Exception as e:
            db.session.rollback()
            flash('❌ Error al guardar', 'danger')

    roles = UserRole.query.all()
    return render_template(
        'admin/edit_user.html', 
        user=user, 
        roles=roles,
        can_delete=can_delete
    )

@routes.route('/admin/users/<int:user_id>/delete', methods=['POST'])
@require_admin
def admin_delete_user(user_id):
    user = User.query.get_or_404(user_id)
    if user.is_admin and User.query.filter_by(is_admin=True).count() == 1:
        flash('❌ No puedes eliminar el único admin', 'danger')
    else:
        db.session.delete(user)
        db.session.commit()
        flash('✅ Usuario eliminado', 'success')
    return redirect(url_for('routes.admin_users'))

@routes.route('/admin/subscribers')
@require_admin
def admin_subscribers():
    subscribers = Subscriber.query.order_by(Subscriber.subscribed_at.desc()).all()
    return render_template('admin/subscribers.html', subscribers=subscribers)

@routes.route('/admin/subscribers/<int:sub_id>/delete', methods=['POST'])
@require_admin
def admin_delete_subscriber(sub_id):
    subscriber = Subscriber.query.get_or_404(sub_id)
    db.session.delete(subscriber)
    db.session.commit()
    flash('✅ Suscriptor eliminado', 'success')
    return redirect(url_for('routes.admin_subscribers'))

@routes.route('/admin/backup-render')
@login_required
def admin_backup_render():
    if not current_user.is_admin:
        abort(403)

    # Solo permitido en modo desarrollo
    if not current_app.debug:
        flash("Esta función solo está disponible en modo desarrollo.", "danger")
        return redirect(url_for('routes.admin_panel'))

    try:
        # Obtener credenciales de Render desde variables de entorno
        render_host = os.getenv('RENDER_DB_HOST')
        render_db = os.getenv('RENDER_DB_NAME')
        render_user = os.getenv('RENDER_DB_USER')
        render_pass = os.getenv('RENDER_DB_PASS')
        render_port = os.getenv('RENDER_DB_PORT', '5432')

        if not all([render_host, render_db, render_user, render_pass]):
            flash("Faltan variables de entorno de Render.", "danger")
            return redirect(url_for('routes.admin_panel'))

        # Ruta del backup
        backup_path = os.path.join(os.getcwd(), 'backups', 'backup_render.sql')
        os.makedirs(os.path.dirname(backup_path), exist_ok=True)

        # Comando pg_dump
        cmd = [
            'pg_dump',
            '-h', render_host,
            '-p', render_port,
            '-U', render_user,
            '-d', render_db,
            '--no-owner',
            '--no-privileges',
            '--clean',
            '--if-exists',
            '-f', backup_path
        ]

        # Ejecutar con contraseña en variable de entorno
        env = os.environ.copy()
        env['PGPASSWORD'] = render_pass

        result = subprocess.run(cmd, env=env, capture_output=True, text=True)

        if result.returncode == 0:
            flash(f"✅ Backup de Render completado: {backup_path}", "success")
        else:
            flash(f"❌ Error: {result.stderr}", "danger")

    except Exception as e:
        flash(f"❌ Excepción: {str(e)}", "danger")

    return redirect(url_for('routes.admin_panel'))

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

def generar_contrasena(longitud=10):
    alfabeto = string.ascii_letters + string.digits + "!@#$%"
    return ''.join(secrets.choice(alfabeto) for _ in range(longitud))

@routes.route('/subscribe', methods=['POST'])
def subscribe():
    email = request.form.get('email', '').strip().lower()
    
    if not email:
        flash('Por favor ingresa un email válido', 'error')
        return redirect(request.referrer or url_for('routes.index'))

    # Verificar si ya es suscriptor o usuario
    if Subscriber.query.filter_by(email=email).first():
        flash('✅ Ya estás suscrito. ¡Revisa tu bandeja!', 'info')
        return redirect(request.referrer or url_for('routes.index'))
    
    if User.query.filter_by(email=email).first():
        flash('✅ Este email ya está registrado como usuario.', 'info')
        return redirect(request.referrer or url_for('routes.index'))

    try:
        # Crear suscriptor
        subscriber = Subscriber(email=email)
        db.session.add(subscriber)

        # Generar credenciales
        username_base = email.split('@')[0]
        username = username_base
        counter = 1
        while User.query.filter_by(username=username).first():
            username = f"{username_base}{counter}"
            counter += 1

        password = generar_contrasena()

        # Crear usuario
        user = User(
            username=username,
            email=email,
            is_professional=False,
            is_admin=False
        )
        user.set_password(password)
        db.session.add(user)
        db.session.commit()

        # Enviar correo de bienvenida con credenciales
        try:
            msg = Message(
                subject="✅ ¡Bienvenido! Tu cuenta ha sido creada",
                recipients=[email],
                body=f"""
            Hola,

            Tu acceso al contenido exclusivo ha sido activado.

            📌 Datos de acceso:
            Usuario: {username}
            Contraseña: {password}

            👉 Ingresa aquí: https://bioforge-pro.onrender.com/auth/login

            Te recomendamos cambiar tu contraseña después del primer inicio de sesión.

            Este mensaje fue generado automáticamente.
                            """.strip(),
                            html=f"""
            <h2>✅ ¡Bienvenido!</h2>
            <p>Tu acceso al contenido exclusivo ha sido activado.</p>

            <h4>Datos de acceso:</h4>
            <ul>
                <li><strong>Usuario:</strong> {username}</li>
                <li><strong>Contraseña:</strong> <code>{password}</code></li>
            </ul>

            <p><a href="https://bioforge-pro.onrender.com/auth/login" class="btn btn-primary">Iniciar sesión</a></p>

            <p><small>Te recomendamos cambiar tu contraseña después del primer inicio de sesión.</small></p>

            <hr>
            <p><em>Este mensaje fue generado automáticamente.</em></p>
                            """.strip()
            )
            mail.send(msg)
        except Exception as e:
            current_app.logger.error(f"Error al enviar email de bienvenida: {str(e)}")
            # No falla si el email no se envía, pero se registra igual

        flash('✅ ¡Gracias por suscribirte! Revisa tu email para tus credenciales.', 'success')

    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"Error al guardar suscriptor: {str(e)}")
        flash('❌ Hubo un error. Intenta más tarde.', 'danger')

    return redirect(request.referrer or url_for('routes.index'))

@routes.route('/asistentes')
@login_required
def mis_asistentes():
    if not current_user.is_professional:
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.index'))

    # Obtener TODOS los asistentes activos del profesional actual
    all_assistants = Assistant.query.filter_by(
        doctor_id=current_user.id,
        is_active=True
    ).all()

    # Agrupar: generales (sin clínica) y por clínica
    general_assistants = [a for a in all_assistants if a.clinic_id is None]
    assistants_by_clinic = {}
    for assistant in all_assistants:
        if assistant.clinic_id is not None:
            clinic = Clinic.query.get(assistant.clinic_id)
            if clinic:
                if clinic not in assistants_by_clinic:
                    assistants_by_clinic[clinic] = []
                assistants_by_clinic[clinic].append(assistant)

    # Obtener tareas asignadas a estos asistentes
    assistant_ids = [a.id for a in all_assistants]
    tasks = Task.query.options(
        db.joinedload(Task.assistant),
        db.joinedload(Task.creator)  # Relación con User
    ).filter(Task.assistant_id.in_(assistant_ids)).all()
    
    # Ordenar todas las tareas por fecha de creación (más reciente primero)
    all_tasks = sorted(tasks, key=lambda x: x.created_at or x.id, reverse=True)

    tasks_by_assistant = {}
    for task in tasks:
        if task.assistant_id not in tasks_by_assistant:
            tasks_by_assistant[task.assistant_id] = []
        tasks_by_assistant[task.assistant_id].append(task)

    # Invitaciones activas (para reenviar código)
    active_invite_map = {}
    if hasattr(current_user, 'sent_invites'):
        for invite in current_user.sent_invites:
            if not invite.is_used and invite.email:
                active_invite_map[invite.email] = invite

    today = date.today()

    return render_template(
        'asistentes.html',
        general_assistants=general_assistants,
        assistants_by_clinic=assistants_by_clinic,
        all_assistants=all_assistants,
        tasks_by_assistant=tasks_by_assistant,
        all_tasks=all_tasks,  # ✅ Nueva variable para la tabla unificada
        no_assistants=(len(all_assistants) == 0),
        today=today,
        active_invite_map=active_invite_map
    )

@routes.route('/asistente/nuevo', methods=['GET', 'POST'])
@login_required
def nuevo_asistente():
    doctor_id = None
    if session.get('active_role') == 'asistente':
        assistant_id = session.get('active_assistant_id')
        if assistant_id:
            assistant = Assistant.query.get(assistant_id)
            if assistant and assistant.doctor_id:
                doctor_id = assistant.doctor_id
    elif current_user.is_professional:
        doctor_id = current_user.id

    if not doctor_id:
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.index'))

    clinics = Clinic.query.filter_by(doctor_id=doctor_id, is_active=True).all()

    if request.method == 'POST':
        name = request.form.get('name', '').strip()
        email = request.form.get('email', '').strip().lower()
        whatsapp = request.form.get('whatsapp', '').strip()
        clinic_id = request.form.get('clinic_id')
        assistant_type = request.form.get('assistant_type')

        if not name or not assistant_type:
            flash('Nombre y tipo son obligatorios', 'error')
            return render_template('nuevo_asistente.html', clinics=clinics)

        if assistant_type == 'general' and not email:
            flash('Los asistentes senior requieren email', 'error')
            return render_template('nuevo_asistente.html', clinics=clinics)

        # Validar clinic_id
        clinic_id_value = None
        if clinic_id:
            clinic = Clinic.query.filter_by(id=clinic_id, doctor_id=doctor_id).first()
            if not clinic:
                flash('Ubicación no válida', 'error')
                return render_template('nuevo_asistente.html', clinics=clinics)
            clinic_id_value = clinic.id

        # Verificar duplicado
        existing = Assistant.query.filter_by(
            name=name,
            doctor_id=doctor_id,
            clinic_id=clinic_id_value
        ).first()
        if existing:
            lugar = f"en {Clinic.query.get(clinic_id_value).name}" if clinic_id_value else "sin ubicación"
            flash(f'Ya existe un asistente llamado "{name}" {lugar}', 'error')
            return render_template('nuevo_asistente.html', clinics=clinics)

        # Buscar o crear usuario
        user = User.query.filter_by(email=email).first() if email else None
        if assistant_type == 'general' and not user:
            # Crear usuario para Senior
            username_base = email.split('@')[0]
            username = username_base
            counter = 1
            while User.query.filter_by(username=username).first():
                username = f"{username_base}{counter}"
                counter += 1
            user = User(
                username=username,
                email=email,
                is_professional=False,
                role_id=3
            )
            user.set_password(os.getenv('DEFAULT_USER_PASSWORD', 'bioforge123'))
            db.session.add(user)
            db.session.flush()

        # Crear asistente
        assistant = Assistant(
            name=name,
            email=email or None,
            whatsapp=whatsapp or None,
            doctor_id=doctor_id,
            clinic_id=clinic_id_value,
            type=assistant_type,
            is_active=True,
            user_id=user.id if user else None
        )
        db.session.add(assistant)
        db.session.commit()

        flash(f'✅ Asistente {assistant_type} agregado correctamente', 'success')
        return redirect(url_for('routes.mis_asistentes'))

    return render_template('nuevo_asistente.html', clinics=clinics)

@routes.route('/consultorio/<int:clinic_id>/asistentes')
@login_required
def asistentes_por_consultorio(clinic_id):
    clinic = Clinic.query.get_or_404(clinic_id)
    
    if clinic.doctor_id != current_user.id:
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.mi_perfil'))

    assistants = Assistant.query.filter_by(clinic_id=clinic_id).all()
    return render_template('asistentes_por_consultorio.html', clinic=clinic, assistants=assistants)

@routes.route('/consultorio/<int:clinic_id>/asistente/nuevo', methods=['GET', 'POST'])
@login_required
def nuevo_asistente_en_consultorio(clinic_id):
    clinic = Clinic.query.get_or_404(clinic_id)
    
    if clinic.doctor_id != current_user.id:
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.mi_perfil'))

    if request.method == 'POST':
        name = request.form.get('name', '').strip()
        email = request.form.get('email', '').strip()
        whatsapp = request.form.get('whatsapp', '').strip()

        if not name:
            flash('El nombre es obligatorio', 'error')
        else:
            assistant = Assistant(
                name=name,
                email=email,
                whatsapp=whatsapp,
                clinic_id=clinic_id,
                doctor_id=current_user.id
            )
            db.session.add(assistant)
            db.session.commit()
            flash('✅ Asistente agregado al consultorio', 'success')
            return redirect(url_for('routes.asistentes_por_consultorio', clinic_id=clinic_id))

    return render_template('nuevo_asistente.html', clinic=clinic)

@routes.route('/asistente/<int:assistant_id>/editar', methods=['GET', 'POST'])
@login_required
def editar_asistente(assistant_id):
    assistant = Assistant.query.get_or_404(assistant_id)
    
    if assistant.doctor_id != current_user.id:
        flash('No puedes editar este asistente', 'danger')
        return redirect(url_for('routes.dashboard'))
    
    if request.method == 'POST':
        name = request.form.get('name', '').strip()
        email = request.form.get('email', '').strip()
        whatsapp = request.form.get('whatsapp', '').strip()
        clinic_id = request.form.get('clinic_id')
        assistant_type = request.form.get('assistant_type')  # Nuevo tipo

        if not name or not assistant_type:
            flash('Nombre y tipo son obligatorios', 'error')
        else:
            try:
                if clinic_id:
                    clinic = Clinic.query.filter_by(id=clinic_id, doctor_id=current_user.id).first()
                    if not clinic:
                        flash('Consultorio no válido', 'error')
                        return render_template('editar_asistente.html', assistant=assistant, clinics=Clinic.query.filter_by(doctor_id=current_user.id, is_active=True).all())
                
                existing = Assistant.query.filter(
                    Assistant.name == name,
                    Assistant.doctor_id == current_user.id,
                    Assistant.id != assistant_id
                )
                if clinic_id:
                    existing = existing.filter(Assistant.clinic_id == clinic_id)
                else:
                    existing = existing.filter(Assistant.clinic_id.is_(None))
                
                if existing.first():
                    flash(f'Ya existe un asistente llamado "{name}" en esta ubicación', 'error')
                else:
                    # Actualizar todos los campos
                    assistant.name = name
                    assistant.email = email
                    assistant.whatsapp = whatsapp
                    assistant.clinic_id = int(clinic_id) if clinic_id else None
                    assistant.type = assistant_type  # ✅ Actualiza el tipo

                    # Si ahora es general y tiene email, asegurar User
                    if assistant_type == 'general' and email and not assistant.user_id:
                        user = User.query.filter_by(email=email).first()
                        if not user:
                            username_base = email.split('@')[0]
                            username = username_base
                            counter = 1
                            while User.query.filter_by(username=username).first():
                                username = f"{username_base}{counter}"
                                counter += 1
                            new_user = User(username=username, email=email, role_name="senior_assistant")
                            new_user.set_password(os.getenv('DEFAULT_USER_PASSWORD', 'temporal123'))
                            db.session.add(new_user)
                            db.session.flush()
                            user = new_user
                        assistant.user_id = user.id

                    db.session.commit()
                    flash('✅ Asistente actualizado correctamente', 'success')
                    return redirect(url_for('routes.dashboard'))

            except Exception as e:
                db.session.rollback()
                flash('❌ Error al actualizar el asistente', 'danger')
                print(f"Error: {e}")

    clinics = Clinic.query.filter_by(doctor_id=current_user.id, is_active=True).all()
    return render_template('editar_asistente.html', assistant=assistant, clinics=clinics)

@routes.route('/asistente/<int:assistant_id>/eliminar', methods=['POST'])
@login_required
def eliminar_asistente(assistant_id):
    """Eliminar un asistente y todas sus tareas (en cascada)"""
    assistant = Assistant.query.get_or_404(assistant_id)
    
    # Verificar que pertenece al profesional actual
    if assistant.doctor_id != current_user.id:
        flash('No puedes eliminar este asistente', 'danger')
        return redirect(url_for('routes.dashboard'))
    
    try:
        # Si el assistant tiene un User vinculado, desvincular
        if assistant.user_id:
            user = User.query.get(assistant.user_id)
            if user:
                # ✅ Ahora verificamos si este Assistant está en la lista
                if assistant in user.assistant_accounts:
                    # No se elimina de la lista aquí, SQLAlchemy lo hace al borrar el Assistant
                    pass  # La relación se elimina automáticamente al borrar el Assistant

        # Eliminar el Assistant → las tareas se borran por cascade
        db.session.delete(assistant)
        db.session.commit()
        
        flash('🗑️ Asistente eliminado correctamente', 'info')
        current_app.logger.info(f"Asistente eliminado: ID={assistant.id}, Nombre='{assistant.name}', Doctor={current_user.id}")
        
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"Error al eliminar asistente {assistant_id}: {str(e)}", exc_info=True)
        flash('❌ Error al eliminar el asistente. Revisa los logs.', 'danger')

    return redirect(url_for('routes.dashboard'))

@routes.route('/perfil-asistente')
@login_required
def perfil_asistente():
    if not current_user.is_general_assistant:
        flash("Acceso denegado", "danger")
        return redirect(url_for('routes.index'))

    active_assistant_id = session.get('active_assistant_id')
    if not active_assistant_id:
        flash("No tienes un rol de asistente activo", "warning")
        return redirect(url_for('routes.seleccionar_perfil'))

    assistant = Assistant.query.get(active_assistant_id)
    if not assistant or assistant.user_id != current_user.id:
        flash("Asistente no válido", "danger")
        return redirect(url_for('routes.index'))

    # Tareas asignadas a mí
    tareas_recibidas = Task.query.filter_by(assistant_id=assistant.id).all()

    # Tareas que he asignado
    tareas_asignadas = Task.query.join(Assistant).filter(
        Task.created_by == current_user.id,
        Assistant.doctor_id == assistant.doctor_id
    ).all()

    return render_template(
        'perfil_asistente.html',
        assistant=assistant,
        tareas_recibidas=tareas_recibidas,
        tareas_asignadas=tareas_asignadas
    )

@routes.route('/tarea/nueva', methods=['GET', 'POST'])
@login_required
def nueva_tarea():
    # === Determinar rol activo ===
    active_assistant = None
    doctor_id = None

    if current_user.assistant_accounts:
        assistant_id = session.get('active_assistant_id')
        if assistant_id:
            active_assistant = Assistant.query.filter_by(
                id=assistant_id,
                user_id=current_user.id
            ).first()

    # Detectar si es asistente general activo
    is_asistente_general = False
    if active_assistant and active_assistant.type == 'general':
        is_asistente_general = True
        doctor_id = active_assistant.doctor_id
    elif current_user.is_professional:
        doctor_id = current_user.id
    else:
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.index'))

    # === Obtener asistentes disponibles ===
    if is_asistente_general:
        # Como asistente general: puedo asignar a otros (opcionalmente incluirme)
        assistants = Assistant.query.filter(
            Assistant.doctor_id == doctor_id,
            Assistant.is_active == True
        ).all()
        
        # Opcional: permitir auto-asignación
        # Si NO quieres auto-asignarte: 
        # assistants = [a for a in assistants if a.id != active_assistant.id]
    else:
        # Como dueño: todos los asistentes de mi equipo
        assistants = Assistant.query.filter_by(doctor_id=doctor_id).all()

    if not assistants:
        flash('No hay asistentes disponibles para asignar tareas', 'warning')
        return redirect(url_for('routes.ver_tareas'))

    form = TaskForm()

    # Rellenar el select dinámicamente
    form.assistant_id.choices = [
        (a.id, f"{a.name} ({'Senior' if a.type == 'general' else 'Común'})") 
        for a in assistants
    ]

    if form.validate_on_submit():
        # Verificar que el asistente destino pertenece al mismo doctor
        target_assistant = Assistant.query.get(form.assistant_id.data)
        if not target_assistant or target_assistant.doctor_id != doctor_id:
            flash('Asistente no válido', 'error')
            return render_template(
                'nueva_tarea.html', 
                form=form, 
                assistants=assistants,
                active_assistant=active_assistant
            )

        task = Task(
            title=form.title.data,
            description=form.description.data,
            due_date=form.due_date.data,
            assistant_id=form.assistant_id.data,
            status=form.status.data,
            created_by=current_user.id,
            doctor_id=doctor_id
        )
        db.session.add(task)
        db.session.commit()

        # 🔔 Notificaciones (Telegram / WhatsApp)
        assistant = target_assistant
        enviado_telegram = False

        if assistant.telegram_id:
            mensaje = (
                f"📋 *Nueva Tarea Asignada*\n\n"
                f"*Asistente:* {assistant.name}\n"
                f"*Título:* {task.title}\n"
                f"*Descripción:* {task.description or 'No especificada'}\n"
                f"*Fecha Límite:* {task.due_date.strftime('%d/%m/%Y') if task.due_date else 'Sin fecha límite'}\n"
                f"*Estado:* Pendiente\n"
                f"*Asignado por:* {current_user.username}"
            )
            try:
                enviar_notificacion_telegram(mensaje)
                flash('✅ Tarea creada y notificada por Telegram', 'success')
                enviado_telegram = True
            except Exception as e:
                current_app.logger.error(f"Error al enviar Telegram: {e}")
                pass

        if not enviado_telegram and assistant.whatsapp:
            from app.utils import crear_mensaje_whatsapp
            mensaje_url = crear_mensaje_whatsapp(assistant, task)
            # ✅ CORREGIDO: sin espacios extra en wa.me
            whatsapp_url = f"https://wa.me/{assistant.whatsapp}?text={mensaje_url}"
            
            # Guardar en sesión para mostrar en ver_tareas
            session['whatsapp_url'] = whatsapp_url
            flash('✅ Tarea creada. Haz clic en el botón para enviar por WhatsApp.', 'success')
            return redirect(url_for('routes.dashboard'))

        flash('✅ Tarea creada correctamente', 'success')
        return redirect(url_for('routes.dashboard'))

    return render_template(
        'nueva_tarea.html', 
        form=form, 
        assistants=assistants,
        active_assistant=active_assistant  # ✅ Pasamos al template
    )

@routes.route('/mi-trabajo')
@login_required
def mi_trabajo():
    if session.get('active_role') != 'asistente':
        flash("Acceso no permitido", "danger")
        return redirect(url_for('routes.dashboard'))

    assistant_id = session.get('active_assistant_id')
    if not assistant_id:
        flash("Asistente no válido", "danger")
        return redirect(url_for('routes.index'))

    assistant = Assistant.query.get_or_404(assistant_id)
    if assistant.user_id != current_user.id:
        flash("Acceso denegado", "danger")
        return redirect(url_for('routes.index'))

    # Mis tareas (asignadas a mí)
    mis_tareas = Task.query.filter_by(assistant_id=assistant.id).order_by(Task.due_date).all()

    # Tareas que asigné (solo si soy Senior)
    tareas_asignadas_por_mi = []
    if assistant.type == 'general':
        tareas_asignadas_por_mi = Task.query.filter_by(created_by=current_user.id).order_by(Task.created_at.desc()).all()

    return render_template(
        'dashboard/mi_trabajo.html',
        assistant=assistant,
        mis_tareas=mis_tareas,
        tareas_asignadas_por_mi=tareas_asignadas_por_mi
    )

@routes.route('/tarea/<int:task_id>/editar', methods=['GET', 'POST'])
@login_required
def editar_tarea(task_id):
    task = Task.query.get_or_404(task_id)
    assistant = Assistant.query.get(task.assistant_id)
    
    if not assistant:
        flash('Tarea no válida', 'danger')
        return redirect(url_for('routes.dashboard'))

    # ✅ Permiso: Dueño, Asistente Senior asignado, o creador original
    puede_editar = (
        current_user.id == assistant.doctor_id or
        (current_user.id == assistant.user_id and assistant.type == 'general') or
        task.created_by == current_user.id
    )

    if not puede_editar:
        flash('No tienes permiso para editar esta tarea', 'danger')
        return redirect(url_for('routes.dashboard'))

    # ✅ Cargar TODOS los asistentes del mismo doctor (equipo)
    doctor_id = task.doctor_id
    all_assistants = Assistant.query.filter_by(
        doctor_id=doctor_id,
        is_active=True
    ).all()

    form = TaskForm(obj=task)
    form.assistant_id.choices = [(a.id, a.name) for a in all_assistants]  # ←←← Esto es clave

    if form.validate_on_submit():
        task.title = form.title.data
        task.description = form.description.data
        task.due_date = form.due_date.data
        task.status = form.status.data
        task.assistant_id = form.assistant_id.data  # ←←← permite reasignar
        db.session.commit()

        # === Notificaciones (tu lógica original) ===
        new_assistant = Assistant.query.get(task.assistant_id)
        if new_assistant and new_assistant.telegram_id:
            try:
                mensaje_telegram = (
                    f"📋 *Tarea Actualizada*\n\n"
                    f"*Asistente:* {new_assistant.name}\n"
                    f"*Título:* {task.title}\n"
                    f"*Descripción:* {task.description or 'No especificada'}\n"
                    f"*Fecha Límite:* {task.due_date.strftime('%d/%m/%Y') if task.due_date else 'Sin fecha límite'}\n"
                    f"*Estado:* {task.status.replace('_', ' ').title()}\n"
                    f"*Profesional:* {current_user.username}"
                )
                enviar_notificacion_telegram(mensaje_telegram)
                flash('✅ Tarea actualizada y notificada por Telegram', 'success')
                return redirect(url_for('routes.dashboard'))
            except Exception as e:
                print(f"Error al enviar a Telegram: {e}")

        if new_assistant and new_assistant.whatsapp:
            try:
                clean_number = ''.join(c for c in new_assistant.whatsapp if c.isdigit())
                if not clean_number.startswith('54'):
                    clean_number = '54' + clean_number
                mensaje_whatsapp = (
                    f"Hola {new_assistant.name}, tienes una actualización en tu tarea:\n\n"
                    f"📌 *{task.title}*\n"
                    f"{task.description or 'Sin descripción'}\n"
                    f"📅 Fecha límite: {task.due_date.strftime('%d/%m/%Y') if task.due_date else 'No especificada'}\n"
                    f"✅ Estado: {task.status.replace('_', ' ').title()}\n\n"
                    f"Este mensaje fue generado automáticamente."
                )
                url_encoded = urllib.parse.quote(mensaje_whatsapp)
                whatsapp_url = f"https://wa.me/{clean_number}?text={url_encoded}"
                session['whatsapp_url'] = whatsapp_url
                flash('✅ Tarea actualizada. Haz clic en el botón para enviar por WhatsApp.', 'success')
                return redirect(url_for('routes.dashboard'))
            except Exception as e:
                print(f"Error al generar WhatsApp: {e}")

        flash('✅ Tarea actualizada', 'success')
        return redirect(url_for('routes.dashboard'))

    return render_template('editar_tarea.html', form=form, task=task, assistant=assistant)

@routes.route('/tarea/<int:task_id>/cambiar-estado', methods=['POST'])
@login_required
def cambiar_estado_tarea(task_id):
    task = Task.query.get_or_404(task_id)
    assistant = Assistant.query.filter_by(id=task.assistant_id).first()
    if not assistant or assistant.doctor_id != current_user.id:
        flash('No tienes permiso para modificar esta tarea', 'danger')
        return redirect(url_for('routes.dashboard'))
    nuevo_estado = request.form.get('nuevo_estado')
    if nuevo_estado in ['pending', 'in_progress', 'completed', 'cancelled']:
        task.status = nuevo_estado
        db.session.commit()
        flash(f'✅ Estado actualizado a "{nuevo_estado}"', 'success')
    else:
        flash('Estado no válido', 'error')
    return redirect(url_for('routes.dashboard'))

@routes.route('/tarea/<int:task_id>/actualizar-estado', methods=['POST'])
@login_required
def actualizar_estado_tarea(task_id):
    task = Task.query.get_or_404(task_id)
    
    # ¿Soy el asignado?
    if task.assistant and task.assistant.user_id == current_user.id:
        assistant = task.assistant
        nuevo_estado = request.form.get('status')
        if assistant.type == 'common':
            if nuevo_estado not in ['in_progress', 'completed']:
                flash('No podés cambiar a ese estado', 'error')
                return redirect(url_for('routes.ver_tareas'))
        # Senior puede cambiar cualquier estado
        task.status = nuevo_estado
        db.session.commit()
        return redirect(url_for('routes.ver_tareas'))

    # ¿Soy quien asignó la tarea? (Senior o Dueño)
    if task.created_by == current_user.id or task.doctor_id == current_user.id:
        task.status = request.form.get('status')
        db.session.commit()
        return redirect(url_for('routes.ver_tareas'))

    flash('No tenés permisos para esta acción', 'danger')
    return redirect(url_for('routes.index'))

@routes.route('/profiles/private/cambiar-pass', methods=['GET', 'POST'])
@login_required
def cambiar_pass():
    if request.method == 'POST':
        current_password = request.form.get('current_password')
        new_password = request.form.get('new_password')
        confirm_password = request.form.get('confirm_password')

        # Validar contraseña actual
        if not current_user.check_password(current_password):
            flash('❌ La contraseña actual es incorrecta', 'error')
            return render_template('cambiar_pass.html')

        # Validar nueva contraseña
        if len(new_password) < 6:
            flash('❌ La nueva contraseña debe tener al menos 6 caracteres', 'error')
            return render_template('cambiar_pass.html')

        if new_password != confirm_password:
            flash('❌ Las contraseñas no coinciden', 'error')
            return render_template('cambiar_pass.html')

        # Cambiar contraseña
        current_user.set_password(new_password)
        db.session.commit()
        
        # Opcional: cerrar sesión después del cambio
        # from flask_login import logout_user
        # logout_user()
        # flash('✅ Contraseña cambiada. Inicia sesión con tu nueva contraseña.', 'success')
        # return redirect(url_for('auth.login'))

        flash('✅ Contraseña actualizada correctamente', 'success')
        return redirect(url_for('routes.mi_perfil'))

    return render_template('/profiles/private/cambiar_pass.html')

@routes.route('/invitacion/<token>', methods=['GET', 'POST'])
def accept_invite(token):
    email = verify_invite_token(token)
    if not email:
        flash("Enlace de invitación inválido o expirado", "danger")
        return redirect(url_for('routes.index'))

    # Buscar el usuario creado previamente (inactivo)
    user = User.query.filter_by(email=email).first()
    if not user:
        flash("Usuario no encontrado para esta invitación", "danger")
        return redirect(url_for('routes.index'))

    # Form para setear contraseña
    form = RegistrationForm()
    if form.validate_on_submit():
        user.set_password(form.password.data)
        db.session.commit()
        flash("Tu cuenta ha sido activada. Ahora podes iniciar sesión.", "success")
        return redirect(url_for('auth.login'))  # ajustar nombre de ruta login

    return render_template('accept_invite.html', form=form, email=email)

@routes.route("/verify-email", methods=["GET"])
def verify_email():
    """Verifica el correo electrónico del usuario mediante un código de verificación."""
    code = request.args.get("code")
    current_app.logger.debug(f"Código recibido en el enlace: {code}")

    # Obtener el código almacenado en la sesión
    stored_code = session.get("verification_code")
    current_app.logger.debug(f"Código almacenado en la sesión: {stored_code}")
    if not stored_code:
        flash("⚠️ Tu sesión ha expirado. Registra tu cuenta nuevamente.", "warning")
        return redirect(url_for("auth.register"))

    if code != stored_code:
        flash("❌ El código de verificación no es válido.", "danger")
        return render_template("auth/verify_email.html")  # Muestra la página de verificación nuevamente

    # Obtener datos pendientes del usuario desde la sesión
    pending_user_data = session.get("pending_user_data")
    if not pending_user_data:
        flash("⚠️ No se encontraron datos pendientes para completar el registro.", "warning")
        return redirect(url_for("auth.register"))

    # Crear el usuario en la base de datos
    try:
        new_user = User(
            username=pending_user_data["username"],
            email=pending_user_data["email"],
            role_id=pending_user_data["role_id"],
            email_verified=True  # Marcar como verificado
        )
        new_user.set_password(pending_user_data["password"])  # Usar el método set_password
        db.session.add(new_user)
        db.session.commit()

        # Limpiar la sesión
        session.pop("verification_code", None)
        session.pop("pending_email", None)
        session.pop("pending_user_data", None)

        flash("🎉 Correo verificado exitosamente. Bienvenido a la plataforma.", "success")
        login_user(new_user)  # Iniciar sesión automáticamente
        return redirect(url_for("routes.seleccionar_perfil"))

    except Exception as e:
        current_app.logger.error(f"[verify_email] Error al crear usuario: {str(e)}", exc_info=True)
        flash("⚠️ Ocurrió un error al verificar tu correo.", "danger")
        return redirect(url_for("auth.login"))
    
# Ruta para limpiar la sesión de WhatsApp después de mostrar el botón
@routes.route('/_cleanup_whatsapp', methods=['POST'])
@login_required
def limpiar_whatsapp_session():
    """Limpia temporalmente la sesión de WhatsApp después de mostrar el botón"""
    if 'whatsapp_url' in session:
        session.pop('whatsapp_url', None)
    return '', 204  # No Content

# Ruta alternativa para crear asistentes con códigos
@routes.route('/asistente/nuevo-con-codigo', methods=['GET', 'POST'])
@login_required
def nuevo_asistente_con_codigo():
    if not current_user.is_professional:
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.index'))

    clinics = Clinic.query.filter_by(doctor_id=current_user.id, is_active=True).all()

    if request.method == 'POST':
        name = request.form.get('name', '').strip()
        email = request.form.get('email', '').strip().lower()
        whatsapp = request.form.get('whatsapp', '').strip()
        clinic_id = request.form.get('clinic_id')
        is_general = not clinic_id

        if not name:
            flash('El nombre es obligatorio', 'error')
            return render_template('nuevo_asistente_codigo.html', clinics=clinics)

        # Para asistentes generales, email es obligatorio
        if is_general and not email:
            flash('Para asistentes generales el email es obligatorio', 'error')
            return render_template('nuevo_asistente_codigo.html', clinics=clinics)

        # Validar si ya existe el User
        existing_user = User.query.filter_by(email=email).first() if email else None

        try:
            if is_general:
                # ✅ ASISTENTE GENERAL: Usar o crear User, pero siempre crear Assistant nuevo
                if existing_user:
                    # ✅ Reutilizar User existente
                    flash(f'✅ Usuario existente reutilizado: {email}', 'info')
                else:
                    # Crear nuevo User
                    username_base = email.split('@')[0]
                    username = username_base
                    counter = 1
                    while User.query.filter_by(username=username).first():
                        username = f"{username_base}{counter}"
                        counter += 1

                    new_user = User(
                        username=username,
                        email=email,
                        is_professional=False,
                        role="senior_assistant"
                    )
                    # Contraseña temporal (la establecerá al registrarse)
                    new_user.set_password(os.getenv('DEFAULT_USER_PASSWORD', 'temporal123'))
                    db.session.add(new_user)
                    db.session.flush()
                    existing_user = new_user

                # ✅ Generar código de invitación
                invite_code = generate_unique_invite_code()
                invite = CompanyInvite(
                    doctor_id=current_user.id,
                    invite_code=invite_code,
                    email=email,
                    name=name,
                    clinic_id=int(clinic_id) if clinic_id else None,
                    assistant_type='general',
                    expires_at=datetime.utcnow() + timedelta(days=7)
                )
                db.session.add(invite)
                db.session.commit()

                # ✅ Enviar email
                try:
                    send_company_invite(invite, current_user)
                    flash(f'📩 Invitación enviada a {email}. Código: {invite_code}', 'success')
                except Exception as e:
                    flash(f'🔑 Código generado: {invite_code} (fallo envío email)', 'warning')

            else:
                # ✅ ASISTENTE COMÚN: creación directa
                assistant = Assistant(
                    name=name,
                    email=email or None,
                    whatsapp=whatsapp or None,
                    doctor_id=current_user.id,
                    clinic_id=int(clinic_id) if clinic_id else None,
                    type='common'
                )
                db.session.add(assistant)
                db.session.commit()
                flash(f'✅ Asistente común creado: {name}', 'success')

            return redirect(url_for('routes.mis_asistentes'))

        except Exception as e:
            db.session.rollback()
            current_app.logger.error(f"Error en nuevo_asistente_con_codigo: {e}")
            flash('❌ Error al procesar la solicitud', 'danger')
            return render_template('nuevo_asistente_codigo.html', clinics=clinics)

    return render_template('nuevo_asistente_codigo.html', clinics=clinics)

@routes.route('/registro/<invite_code>', methods=['GET', 'POST'])
def registro_con_codigo(invite_code):
    invite = CompanyInvite.query.filter_by(invite_code=invite_code).first()
    
    if not invite or not invite.is_valid():
        flash('Código inválido o expirado', 'error')
        return redirect(url_for('routes.index'))

    user = User.query.filter_by(email=invite.email).first()

    if request.method == 'POST':
        if not user:
            # Crear nuevo usuario
            username = request.form.get('username')
            password = request.form.get('password')

            if not username or not password:
                flash('Completa todos los campos', 'error')
                return render_template('registro_con_codigo.html', invite=invite)

            if User.query.filter_by(username=username).first():
                flash('Nombre de usuario ya existe', 'error')
                return render_template('registro_con_codigo.html', invite=invite)

            try:
                user = User(
                    username=username,
                    email=invite.email,
                    is_professional=False,
                    role="senior_assistant"
                )
                user.set_password(password)
                db.session.add(user)
                db.session.flush()
            except Exception as e:
                db.session.rollback()
                current_app.logger.error(f"Error creando usuario: {e}")
                flash('❌ Error al crear el usuario', 'danger')
                return render_template('registro_con_codigo.html', invite=invite)
        # Si user ya existía, lo reutilizamos directamente

        try:
            # Verificar si ya es asistente de este doctor
            existing_assistant = Assistant.query.filter_by(
                user_id=user.id,
                doctor_id=invite.doctor_id
            ).first()

            if existing_assistant:
                flash(f'Ya eres asistente de este equipo', 'warning')
            else:
                # Crear nuevo Assistant
                assistant = Assistant(
                    name=invite.name,
                    email=invite.email,
                    doctor_id=invite.doctor_id,
                    clinic_id=invite.clinic_id,
                    type='general',
                    user_id=user.id  # ← ¡vinculación obligatoria!
                )
                db.session.add(assistant)
                db.session.flush()

                # Marcar invitación como usada
                invite.is_used = True
                invite.used_at = datetime.utcnow()

            db.session.commit()

            login_user(user)
            session['active_role'] = 'asistente'
            session['active_assistant_id'] = existing_assistant.id if existing_assistant else assistant.id
            return redirect(url_for('routes.ver_tareas'))

        except Exception as e:
            db.session.rollback()
            current_app.logger.error(f"Error en registro con código: {str(e)}", exc_info=True)
            flash('❌ Ocurrió un error. Intenta más tarde.', 'danger')

    return render_template('registro_con_codigo.html', invite=invite)

@routes.route('/invitaciones')
@login_required
def mis_invitaciones():
    if not current_user.is_professional:
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.index'))

    invitaciones = CompanyInvite.query.filter_by(doctor_id=current_user.id)\
                                      .order_by(CompanyInvite.created_at.desc()).all()
    return render_template('mis_invitaciones.html', invitaciones=invitaciones)

@routes.route('/invitacion/<int:invite_id>/reenviar', methods=['POST'])
@login_required
def reenviar_invitacion(invite_id):
    invite = CompanyInvite.query.get_or_404(invite_id)
    
    if invite.doctor_id != current_user.id or invite.is_used:
        flash('No se puede reenviar esta invitación', 'error')
        return redirect(url_for('routes.mis_invitaciones'))
    
    try:
        invite.expires_at = datetime.utcnow() + timedelta(days=7)
        db.session.commit()
        send_company_invite(invite, current_user)
        flash(f'Invitación reenviada a {invite.email}', 'success')
    except Exception as e:
        flash('Error al reenviar invitación', 'danger')
    
    return redirect(url_for('routes.mis_invitaciones'))

@routes.route('/registro-exitoso/<invite_code>')
@login_required
def registro_exitoso(invite_code):
    invite = CompanyInvite.query.filter_by(invite_code=invite_code, is_used=True).first()
    if not invite or invite.used_at is None:
        return redirect(url_for('routes.index'))
    return render_template('registro_exitoso.html', invite=invite)

@routes.route('/mis-equipos')
@login_required
def mis_equipos():
    # ✅ Verificar que tenga al menos un Assistant
    if not current_user.assistant_accounts:
        flash("Acceso denegado: no eres asistente en ningún equipo", "danger")
        return redirect(url_for('routes.index'))

    # Obtener todos los Assistant vinculados al User
    teams = Assistant.query.filter_by(user_id=current_user.id).all()

    if not teams:
        flash("No estás vinculado a ningún equipo", "info")
        return render_template(
            'mis_equipos.html',
            teams=[],
            tasks_by_assistant={},
            teams_count=0,
            pending_tasks=0,
            today=datetime.utcnow().date()
        )

    # Obtener todas las tareas de todos sus roles como asistente
    team_ids = [a.id for a in teams]
    all_tasks = Task.query.filter(Task.assistant_id.in_(team_ids)).all()

    # Agrupar tareas por assistant_id
    tasks_by_assistant = {}
    for task in all_tasks:
        if task.assistant_id not in tasks_by_assistant:
            tasks_by_assistant[task.assistant_id] = []
        tasks_by_assistant[task.assistant_id].append(task)

    # Calcular KPIs
    teams_count = len(teams)
    today = datetime.utcnow().date()
    pending_tasks = sum(
        1 for task in all_tasks
        if task.status in ['pending', 'in_progress']
        and (not task.due_date or task.due_date >= today)
    )

    return render_template(
        'mis_equipos.html',
        teams=teams,
        tasks_by_assistant=tasks_by_assistant,
        teams_count=teams_count,
        pending_tasks=pending_tasks,
        today=today
    )

# Nuevas rutas para dashboard General por roles independientes
@routes.route('/dashboard')
@login_required
def dashboard():
    # === Contexto del usuario ===
    active_assistant = None
    is_senior = False
    is_owner = False
    doctor_id = None

    if session.get('active_role') == 'asistente':
        assistant_id = session.get('active_assistant_id')
        if assistant_id:
            active_assistant = Assistant.query.filter_by(
                id=assistant_id,
                user_id=current_user.id,
                is_active=True
            ).first()
        if active_assistant and active_assistant.type == 'general':
            is_senior = True
            doctor_id = active_assistant.doctor_id
    elif current_user.is_professional:
        is_owner = True
        doctor_id = current_user.id

    if not doctor_id:
        flash("Acceso denegado", "danger")
        return redirect(url_for('routes.index'))

    # === Filtros ===
    assistant_filter = request.args.get("assistant", type=int)
    clinic_filter = request.args.get("clinic", type=int)
    status_filter = request.args.get("status")
    date_filter = request.args.get("date")
    solo_atrasadas = request.args.get("solo_atrasadas")

    # === Base query ===
    if is_owner:
        # Dueño: todas las tareas de su equipo
        query = Task.query.join(Assistant).filter(Assistant.doctor_id == doctor_id)
    elif is_senior:
        # Senior: solo tareas que él creó
        query = Task.query.filter(Task.created_by == current_user.id)
    else:
        # Junior: no debería llegar aquí, pero por seguridad
        flash("Acceso no permitido", "danger")
        return redirect(url_for('routes.index'))

    # === Aplicar filtros (solo para dueño; senior ya está filtrado por created_by) ===
    if is_owner:
        if assistant_filter:
            query = query.filter(Task.assistant_id == assistant_filter)
        if clinic_filter:
            query = query.filter(Task.clinic_id == clinic_filter)

    if status_filter:
        query = query.filter(Task.status == status_filter)
    if date_filter:
        try:
            date_obj = datetime.strptime(date_filter, "%Y-%m-%d").date()
            query = query.filter(Task.due_date == date_obj)
        except ValueError:
            pass
    if solo_atrasadas:
        today = date.today()
        query = query.filter(
            Task.due_date < today,
            Task.status.notin_(['completed', 'cancelled'])
        )

    tasks = query.all()

    # === Datos para filtros 
    # ✅ AHORA: Tanto Dueño como Senior ven los mismos asistentes y clínicas
    assistants = Assistant.query.filter_by(doctor_id=doctor_id, is_active=True).all()
    clinics = Clinic.query.filter_by(doctor_id=doctor_id).all()

    # === Agrupar tareas por asistente (para mostrar en tabla) ===
    tasks_by_assistant = {}
    for task in tasks:
        tasks_by_assistant.setdefault(task.assistant_id, []).append(task)

    # === Etiquetas de estado ===
    status_labels = {
        'pending': {'text': 'Pendiente', 'class': 'bg-warning text-dark'},
        'in_progress': {'text': 'En progreso', 'class': 'bg-info text-white'},
        'completed': {'text': 'Completada', 'class': 'bg-success'},
        'cancelled': {'text': 'Cancelada', 'class': 'bg-danger'}
    }

    # === KPIs ===
    pending_tasks = sum(1 for t in tasks if t.status in ['pending', 'in_progress'])
    completed_tasks = sum(1 for t in tasks if t.status == 'completed')
    total_assistants = len(assistants) if is_owner else 0

    # === Gráficos (últimos 30 días) ===
    today = date.today()
    last_30_days = [(today - timedelta(days=i)).strftime('%d/%m') for i in range(29, -1, -1)]
    task_data = defaultdict(lambda: {'Pendientes': 0, 'En progreso': 0, 'Completadas': 0})
    for task in tasks:
        if task.created_at:
            day_key = task.created_at.date()
            if day_key >= today - timedelta(days=29):
                day_str = day_key.strftime('%d/%m')
                if task.status == 'pending':
                    task_data[day_str]['Pendientes'] += 1
                elif task.status == 'in_progress':
                    task_data[day_str]['En progreso'] += 1
                elif task.status == 'completed':
                    task_data[day_str]['Completadas'] += 1

    data_evolucion = [{'name': d, **task_data[d]} for d in last_30_days]
    assistants_distribution = []
    if is_owner:
        for a in assistants:
            count = Task.query.filter_by(assistant_id=a.id).count()
            if count > 0:
                assistants_distribution.append({'name': a.name, 'task_count': count})

    # === Paginación ===
    total_tasks_count = len(tasks)
    page = request.args.get('page', 1, type=int)
    per_page = 10
    total_pages = ceil(total_tasks_count / per_page)
    start = (page - 1) * per_page
    end = start + per_page
    paginated_tasks = tasks[start:end]

    # === Precargar creadores para mostrar en el dashboard ===
    creator_ids = {task.created_by for task in tasks if task.created_by is not None}
    creators = {u.id: u for u in User.query.filter(User.id.in_(creator_ids)).all()}

    return render_template(
        'dashboard.html',
        is_owner=is_owner,
        is_senior=is_senior,
        active_assistant=active_assistant,
        can_manage_team=is_owner or is_senior,
        total_tasks=total_tasks_count,
        pending_tasks=pending_tasks,
        completed_tasks=completed_tasks,
        total_assistants=total_assistants,
        assistants=assistants,
        creators=creators,
        clinics=clinics,
        tasks=paginated_tasks,
        tasks_by_assistant=tasks_by_assistant,
        status_labels=status_labels,
        data_evolucion=data_evolucion,
        assistants_distribution=assistants_distribution,
        assistant_filter=assistant_filter,
        clinic_filter=clinic_filter,
        status_filter=status_filter,
        date_filter=date_filter,
        today=today,
        last_30_days=last_30_days,
        total_pages=total_pages,
        current_page=page,
    )

@routes.route('/seleccionar-perfil')
@login_required
def seleccionar_perfil():
    roles = []

    # Rol: Administrador
    if current_user.is_admin:
        roles.append({
            'tipo': 'admin',
            'nombre': 'Modo Administrador',
            'descripcion': 'Gestionar usuarios, roles y configuración del sitio'
        })

    # Rol: Profesional / Dueño - y como asistente si lo fuera 
    # clinics = Clinic.query.filter_by(doctor_id=current_user.id, is_active=True).all()
    if current_user.is_professional or current_user.role_id in PROFESSIONAL_ROLE_IDS:
        roles.append({
            'tipo': 'profesional',
            'nombre': f"Como Profesional: {current_user.username}",
            'descripcion': 'Gestionar tus ubicaciones, asistentes y tareas'
        })

    # Buscar asistentes activos vinculados al usuario - dueño o profesional
    asistentias = Assistant.query.filter_by(
        user_id=current_user.id,
        is_active=True
    ).all()
    
    for ass in asistentias:
        doctor_name = ass.doctor.username if ass.doctor else "Profesional"
        clinic_name = ass.clinic.name if ass.clinic else "Sin ubicación"
        roles.append({
            'tipo': 'asistente',
            'nombre': f"Como Asistente de {doctor_name}",
            'descripcion': f'Trabajas en {clinic_name}',
            'assistant_id': ass.id
        })

    # Si solo hay un rol, redirigir directamente
    if len(roles) == 1:
        rol = roles[0]
        if rol['tipo'] == 'admin':
            return redirect(url_for('routes.admin_dashboard'))
        elif rol['tipo'] == 'profesional':
            session['active_role'] = 'profesional'
            return redirect(url_for('routes.mi_perfil'))
        elif rol['tipo'] == 'asistente':
            session['active_role'] = 'asistente'
            session['active_assistant_id'] = rol['assistant_id']
            return redirect(url_for('routes.ver_tareas'))

    # Si hay múltiples roles, mostrar selector
    return render_template('seleccionar_perfil.html', roles=roles)

@routes.route('/iniciar-como')
@login_required
def iniciar_como():
    tipo = request.args.get('tipo')
    assistant_id = request.args.get('assistant_id', type=int)

    # Rol: Administrador
    if tipo == 'admin':
        if not current_user.is_admin:
            flash("❌ No tenés permisos de administrador.", "danger")
            return redirect(url_for('routes.seleccionar_perfil'))
        return redirect(url_for('routes.admin_dashboard'))

    # Rol: Profesional / Dueño
    elif tipo == 'profesional':
        if not current_user.is_professional:
            flash("❌ No sos un profesional registrado.", "danger")
            return redirect(url_for('routes.seleccionar_perfil'))
        session['active_role'] = 'profesional'
        return redirect(url_for('routes.mi_perfil'))

    # Rol: Asistente
    elif tipo == 'asistente':
        if not assistant_id:
            flash("❌ Asignación de asistente no válida.", "danger")
            return redirect(url_for('routes.seleccionar_perfil'))

        # Validar que el assistant_id pertenece al usuario actual
        from app.models import Assistant
        assistant = Assistant.query.filter_by(
            id=assistant_id,
            user_id=current_user.id,
            is_active=True
        ).first()

        if not assistant:
            flash("❌ No tenés permiso para acceder a esta asignación.", "danger")
            return redirect(url_for('routes.seleccionar_perfil'))

        session['active_role'] = 'asistente'
        session['active_assistant_id'] = assistant.id
        return redirect(url_for('routes.mi_trabajo'))

    # Tipo no reconocido
    else:
        flash("❌ Rol no válido.", "danger")
        return redirect(url_for('routes.seleccionar_perfil'))

@routes.route('/exportar-tareas-csv')
@login_required
def exportar_tareas_csv():
    # Determinar doctor_id (igual que en dashboard)
    doctor_id = None
    if session.get('active_role') == 'asistente':
        assistant_id = session.get('active_assistant_id')
        if assistant_id:
            active_assistant = Assistant.query.filter_by(id=assistant_id, user_id=current_user.id).first()
            if active_assistant:
                doctor_id = active_assistant.doctor_id
    elif current_user.is_professional:
        doctor_id = current_user.id
    if not doctor_id:
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.dashboard'))
    # Obtener tareas
    tasks = Task.query.join(Assistant).filter(Assistant.doctor_id == doctor_id).all()
    # Generar CSV
    si = StringIO()
    cw = csv.writer(si)
    cw.writerow(['ID', 'Título', 'Asistente', 'Fecha Límite', 'Estado', 'Creada'])
    for t in tasks:
        cw.writerow([
            t.id,
            t.title,
            t.assistant.name,
            t.due_date.strftime('%Y-%m-%d') if t.due_date else '',
            t.status,
            t.created_at.strftime('%Y-%m-%d %H:%M') if t.created_at else ''
        ])
    output = si.getvalue()
    si.close()
    # Enviar como descarga
    return Response(
        output,
        mimetype="text/csv",
        headers={"Content-Disposition": "attachment;filename=tareas_equipo.csv"}
    )

@routes.route('/dashboard/professional')
@login_required
def professional():
    locations = Clinic.query.filter_by(doctor_id=current_user.id).all()
    if not locations:
        flash("No tenés ubicaciones creadas todavía.", "warning")
        return render_template('dashboard/professional.html', 
                             locations=[], selected_location=None, 
                             assistants=[], tasks=[])
    
    selected_location_id = request.args.get('location', locations[0].id, type=int)
    selected_location = Clinic.query.get(selected_location_id)
    assistants = Assistant.query.filter_by(clinic_id=selected_location_id).all()
    tasks = Task.query.filter_by(clinic_id=selected_location_id).all()
    
    return render_template('dashboard/professional.html',
                         locations=locations,
                         selected_location=selected_location,
                         assistants=assistants,
                         tasks=tasks)

@routes.route('/dashboard/assistant')
@login_required
def assistant():
    my_assistant = Assistant.query.filter_by(user_id=current_user.id).first()
    if not my_assistant:
        flash("No tenés perfil de asistente activo.", "error")
        return redirect(url_for('main.home'))
    
    tasks = Task.query.filter_by(assistant_id=my_assistant.id).all()
    return render_template('dashboard/assistant.html',
                         assistant=my_assistant,
                         tasks=tasks)

# # En routes.py
# @routes.route('/init-db-render')
# def init_db_render():
#     from app import db
#     db.create_all()  # Crea SOLO las tablas que faltan
#     return "✅ Tabla 'visits' creada"

# ✅ Mover esta función fuera de cualquier ruta

# @routes.route('/admin/export-data')
# @login_required
# def export_data():
#     if not current_user.is_admin:
#         abort(403)

#     tables = {
#         'users': User,
#         'assistants': Assistant,
#         'clinic': Clinic,
#         'tasks': Task,
#         'notes': Note,
#         'publications': Publication,
#         'availability': Availability,
#         'appointments': Appointment,
#         'medical_records': MedicalRecord,
#         'schedules': Schedule,
#         'user_roles': UserRole,
#         'subscribers': Subscriber,
#         'company_invites': CompanyInvite,
#         'invitation_logs': InvitationLog,
#         'visits': Visit
#     }

#     table_name = request.args.get('table')
#     if not table_name or table_name not in tables:
#         links = "<h2>🔐 Exportar datos (solo admin)</h2><ul>"
#         for name in sorted(tables.keys()):
#             links += f'<li><a href="?table={name}">{name}</a></li>'
#         links += "</ul><p>⚠️ Elimina esta ruta después de usarla.</p>"
#         return links

#     model = tables[table_name]
#     columns = [col.name for col in model.__table__.columns]

#     output = StringIO()
#     writer = csv.writer(output)
#     writer.writerow(columns)

#     for row in model.query.all():
#         writer.writerow([
#             str(getattr(row, col)) if getattr(row, col) is not None else ''
#             for col in columns
#         ])

#     output.seek(0)
#     return Response(
#         output.getvalue(),
#         mimetype="text/csv",
#         headers={"Content-Disposition": f"attachment;filename={table_name}.csv"}
#     )
    
# @routes.route('/admin/import-data', methods=['GET', 'POST'])
# @login_required
# def import_data():
#     if not current_user.is_admin:
#         abort(403)

#     tables = {
#         'users': User,
#         'assistants': Assistant,
#         'clinic': Clinic,
#         'tasks': Task,
#         'notes': Note,
#         'publications': Publication,
#         'availability': Availability,
#         'appointments': Appointment,
#         'medical_records': MedicalRecord,
#         'schedules': Schedule,
#         'user_roles': UserRole,
#         'subscribers': Subscriber,
#         'company_invites': CompanyInvite,
#         'invitation_logs': InvitationLog,
#         'visits': Visit
#     }

#     if request.method == 'POST':
#         table = request.form.get('table')
#         csv_file = request.files.get('csv_file')
        
#         if not csv_file or table not in tables:
#             flash("❌ Tabla o archivo inválido", "danger")
#             return redirect(request.url)

#         model = tables[table]
#         try:
#             # Soporta UTF-8 con BOM (común en Excel)
#             stream = StringIO(csv_file.read().decode('utf-8-sig'))
#             reader = csv.DictReader(stream)
#         except Exception as e:
#             flash(f"❌ Error al leer CSV: {e}", "danger")
#             return redirect(request.url)

#         success_count = 0
#         try:
#             for row in reader:
#                 cleaned = {}
#                 for key, value in row.items():
#                     if value == '':
#                         cleaned[key] = None
#                     elif key in ['id', 'user_id', 'doctor_id', 'assistant_id', 'clinic_id', 'patient_id', 'role_id', 'created_by', 'approved_by']:
#                         cleaned[key] = int(value) if value.isdigit() else None
#                     elif key in ['is_active', 'is_admin', 'is_professional', 'is_used', 'success']:
#                         cleaned[key] = value.lower() in ('1', 'true', 't', 'yes', 'on')
#                     elif key in ['created_at', 'updated_at', 'due_date', 'published_at', 'expires_at', 'used_at', 'approved_at']:
#                         if value:
#                             try:
#                                 cleaned[key] = date_parser.parse(value)
#                             except:
#                                 cleaned[key] = None
#                         else:
#                             cleaned[key] = None
#                     else:
#                         cleaned[key] = value

#                 # Evitar duplicados por ID
#                 if 'id' in cleaned and cleaned['id']:
#                     existing = model.query.get(cleaned['id'])
#                     if existing:
#                         continue  # salta si ya existe

#                 obj = model(**cleaned)
#                 db.session.add(obj)
#                 success_count += 1

#             db.session.commit()
#             flash(f"✅ Importado: {success_count} registros en '{table}'", "success")
#         except Exception as e:
#             db.session.rollback()
#             flash(f"❌ Error al importar '{table}': {str(e)}", "danger")

#         return redirect(url_for('routes.import_data'))

#     # Mostrar formulario
#     options = "".join([f'<option value="{name}">{name}</option>' for name in sorted(tables.keys())])
#     return f'''
#     <!DOCTYPE html>
#     <html>
#     <head><title>Importar datos</title>
#     <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
#     </head>
#     <body class="bg-light">
#     <div class="container mt-5">
#         <div class="card">
#             <div class="card-header">
#                 <h4>📤 Importar datos a Render (solo admin)</h4>
#             </div>
#             <div class="card-body">
#                 <form method="post" enctype="multipart/form-data">
#                     <div class="mb-3">
#                         <label class="form-label">Tabla</label>
#                         <select name="table" class="form-select" required>{options}</select>
#                     </div>
#                     <div class="mb-3">
#                         <label class="form-label">Archivo CSV</label>
#                         <input type="file" name="csv_file" accept=".csv" class="form-control" required>
#                     </div>
#                     <button type="submit" class="btn btn-success">Importar</button>
#                     <a href="{{ url_for('routes.dashboard') }}" class="btn btn-secondary">Cancelar</a>
#                 </form>
#                 <div class="alert alert-warning mt-3">
#                     ⚠️ <strong>Advertencia:</strong> Esta ruta debe eliminarse después de usarla.
#                 </div>
#             </div>
#         </div>
#     </div>
#     </body>
#     </html>
#     '''

# === TIENDA PÚBLICA ===
@routes.route('/tienda/<string:url_slug>')
def tienda_publica(url_slug):
    from app.models import User, Product, ProductCategory
    from datetime import datetime
    import json

    professional = User.query.filter_by(url_slug=url_slug, is_professional=True).first_or_404()
    
    # Productos visibles y con stock (o servicios)
    products = Product.query.filter_by(
        doctor_id=professional.id,
        is_visible=True
    ).filter(
        (Product.is_service == True) |
        (Product.stock > 0) |
        ((Product.stock == 0) & (Product.hide_if_out_of_stock == False))
    ).all()
    
    # Categorías activas
    categories = (
        ProductCategory.query
        .filter_by(doctor_id=professional.id, is_active=True)
        .order_by(ProductCategory.name)
        .all()
    )

    # ✅ Convertir preferences a diccionario si es string
    preferences_dict = {}
    if professional.preferences:
        if isinstance(professional.preferences, str):
            try:
                preferences_dict = json.loads(professional.preferences)
            except (json.JSONDecodeError, TypeError):
                preferences_dict = {}
        else:
            preferences_dict = professional.preferences

    # ✅ Obtener el tema de la tienda desde preferences
    theme = preferences_dict.get('store_theme', 'default')
    print("Tema leído de BD:", theme)

    return render_template(
        'ecommerce/tienda_publica.html',
        professional=professional,
        products=products,
        categories=categories,
        now=datetime.now,
        theme=theme
    )

@routes.route('/guardar-tema/<string:theme>', methods=['POST'])
def guardar_tema(theme):
    from flask import jsonify
    from app import db
    from app.models import User
    import json

    print("Tema recibido:", theme)

    # Verificar que el usuario esté autenticado
    if not current_user.is_authenticated:
        return jsonify({"error": "No autenticado"}), 403

    # Verificar que sea un profesional
    if not current_user.is_professional:
        return jsonify({"error": "No tienes permisos"}), 403

    # ✅ Verificar que el tema sea válido - AGREGADO 'amarillo'
    temas_validos = ['default', 'azul', 'verde', 'morado', 'negro', 'amarillo']
    if theme not in temas_validos:
        return jsonify({"error": "Tema no válido"}), 400

    # ✅ Cargar el objeto fresh de la base de datos
    user = db.session.query(User).filter(User.id == current_user.id).first()

    # ✅ Asegurar que sea un diccionario
    if user.preferences:
        if isinstance(user.preferences, str):
            try:
                current_prefs = json.loads(user.preferences)
            except (json.JSONDecodeError, TypeError):
                current_prefs = {}
        else:
            current_prefs = user.preferences.copy()  # ✅ Hacer copia para evitar problemas
    else:
        current_prefs = {}

    # ✅ Actualizar el tema
    current_prefs['store_theme'] = theme

    # ✅ Reemplazar completamente el objeto para que SQLAlchemy detecte el cambio
    user.preferences = current_prefs

    # ✅ Forzar el marcado de cambio (importante para JSON)
    from sqlalchemy.orm.attributes import flag_modified
    flag_modified(user, 'preferences')

    # ✅ Guardar y confirmar
    db.session.commit()

    print("Tema guardado en BD:", user.preferences)

    return jsonify({"success": True})

# === PRODUCTOS ===
@routes.route('/<int:doctor_id>/productos')
@login_required
def gestion_productos(doctor_id):
    if not check_access(doctor_id):
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.mi_perfil'))
    products = Product.query.filter_by(doctor_id=doctor_id).order_by(Product.created_at.desc()).all()
    return render_template('ecommerce/gestion_productos.html', 
                            products=products, 
                            doctor_id=doctor_id, 
                            now=datetime.now
                            )

@routes.route('/<int:doctor_id>/producto/nuevo', methods=['GET', 'POST'])
@login_required
def crear_producto(doctor_id):
    if not check_access(doctor_id):
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.mi_perfil'))

    from app.models import ProductCategory
    categories = ProductCategory.query.filter_by(
        doctor_id=doctor_id,
        is_active=True
    ).order_by(ProductCategory.name).all()

    if request.method == 'POST':
        try:
            # 🧠 Validación de servicio y stock
            is_service = 'is_service' in request.form
            raw_stock = request.form.get('stock', '0').strip()
            stock = 0 if is_service else max(0, int(raw_stock)) if raw_stock.isdigit() else 0

            # 🧠 Datos de precios
            base_price = float(request.form.get('base_price', 0) or 0)
            tax_rate = float(request.form.get('tax_rate', 0) or 0)
            has_tax_included = 'has_tax_included' in request.form

            # 🧠 Promoción
            is_on_promotion = 'is_on_promotion' in request.form
            promotion_discount = float(request.form.get('promotion_discount', 0) or 0)
            promotion_end_date = None
            if is_on_promotion and request.form.get('promotion_end_date'):
                try:
                    promotion_end_date = datetime.strptime(request.form['promotion_end_date'], '%Y-%m-%d')
                except ValueError:
                    promotion_end_date = None

            # 🧠 Imágenes (JSON seguro)
            import json
            image_urls = []
            if request.form.get('image_urls'):
                try:
                    urls = json.loads(request.form['image_urls'])
                    if isinstance(urls, list):
                        image_urls = urls[:3]
                except json.JSONDecodeError:
                    pass

            # 🧠 Categoría válida
            category_id = None
            cat_form = request.form.get('category_id')
            if cat_form and cat_form.isdigit():
                category = ProductCategory.query.filter_by(
                    id=int(cat_form),
                    doctor_id=doctor_id,
                    is_active=True
                ).first()
                category_id = category.id if category else None

            # 🧠 Crear producto
            product = Product(
                name=request.form['name'].strip(),
                description=request.form.get('description', '').strip(),
                base_price=base_price,
                tax_rate=tax_rate,
                has_tax_included=has_tax_included,
                is_on_promotion=is_on_promotion,
                promotion_discount=promotion_discount,
                promotion_end_date=promotion_end_date,
                image_urls=image_urls,
                is_service=is_service,
                stock=stock,
                is_visible='is_visible' in request.form,
                hide_if_out_of_stock='hide_if_out_of_stock' in request.form,
                category_id=category_id,
                doctor_id=doctor_id,
                created_by=current_user.id,
                updated_by=current_user.id
            )

            db.session.add(product)
            db.session.commit()
            flash('✅ Producto creado exitosamente', 'success')
            return redirect(url_for('routes.gestion_productos', doctor_id=doctor_id))

        except Exception as e:
            db.session.rollback()
            import traceback
            print("🚨 ERROR en crear_producto:")
            traceback.print_exc()
            flash(f'❌ Error interno al crear el producto: {e}', 'danger')

    return render_template(
        'ecommerce/form_producto.html',
        doctor_id=doctor_id,
        product=None,
        categories=categories,
        now=datetime.now
    )

@routes.route('/detalle-producto/<int:product_id>', methods=['GET'])
def detalle_producto(product_id):
    # Obtener el producto por ID
    product = Product.query.get_or_404(product_id)

    # Renderizar la plantilla con los detalles del producto
    return render_template('ecommerce/detalle_producto.html', product=product)

@routes.route('/producto/<int:product_id>/editar', methods=['GET', 'POST'])
@login_required
def editar_producto(product_id):
    product = Product.query.get_or_404(product_id)
    if not check_access(product.doctor_id):
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.mi_perfil'))

    from app.models import ProductCategory
    categories = ProductCategory.query.filter_by(
        doctor_id=product.doctor_id,
        is_active=True
    ).order_by(ProductCategory.name).all()

    if request.method == 'POST':
        try:
            # 🧠 Datos generales
            product.name = request.form['name'].strip()
            product.description = request.form.get('description', '').strip()

            # 🧠 Precios
            product.base_price = float(request.form.get('base_price', 0) or 0)
            product.tax_rate = float(request.form.get('tax_rate', 0) or 0)
            product.has_tax_included = 'has_tax_included' in request.form

            # 🧠 Promoción
            product.is_on_promotion = 'is_on_promotion' in request.form
            product.promotion_discount = float(request.form.get('promotion_discount', 0) or 0) if product.is_on_promotion else 0.0
            product.promotion_end_date = None
            if product.is_on_promotion and request.form.get('promotion_end_date'):
                try:
                    product.promotion_end_date = datetime.strptime(request.form['promotion_end_date'], '%Y-%m-%d')
                except ValueError:
                    product.promotion_end_date = None

            # 🧠 Servicio / stock
            product.is_service = 'is_service' in request.form
            raw_stock = request.form.get('stock', '0').strip()
            product.stock = 0 if product.is_service else max(0, int(raw_stock)) if raw_stock.isdigit() else 0

            # 🧠 Categoría
            cat_id = request.form.get('category_id')
            if cat_id and cat_id.isdigit():
                category = ProductCategory.query.filter_by(
                    id=int(cat_id),
                    doctor_id=product.doctor_id,
                    is_active=True
                ).first()
                product.category_id = category.id if category else None
            else:
                product.category_id = None

            # 🧠 Visibilidad
            product.is_visible = 'is_visible' in request.form
            product.hide_if_out_of_stock = 'hide_if_out_of_stock' in request.form
            product.updated_by = current_user.id

            # 🧠 Mantener imágenes existentes desde formulario
            image_urls = request.form.getlist('image_urls[]')
            if image_urls:
                product.image_urls = image_urls

            # 🧠 Confirmar cambios
            db.session.commit()
            flash('✅ Producto actualizado', 'success')
            return redirect(url_for('routes.gestion_productos', doctor_id=product.doctor_id))

        except Exception as e:
            db.session.rollback()
            import traceback
            print("🚨 ERROR en editar_producto:")
            traceback.print_exc()
            flash(f'❌ Error al actualizar producto: {e}', 'danger')

    return render_template(
        'ecommerce/form_producto.html',
        doctor_id=product.doctor_id,
        product=product,
        categories=categories,
        now=datetime.now
    )

@routes.route('/producto/<int:product_id>/subir-imagen', methods=['POST'])
@login_required
def subir_imagen_producto(product_id):
    product = Product.query.get_or_404(product_id)
    if not check_access(product.doctor_id):
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.mi_perfil'))
    
    if 'image' not in request.files:
        flash('❌ No se seleccionó ninguna imagen.', 'danger')
        return redirect(url_for('routes.editar_producto', product_id=product_id))
    
    image_file = request.files['image']
    if image_file.filename == '':
        flash('❌ El archivo no tiene nombre.', 'danger')
        return redirect(url_for('routes.editar_producto', product_id=product_id))
    
    try:
        upload_result = cloudinary.uploader.upload(
            image_file,
            folder=f"bioforge/productos/{product.doctor_id}",
            public_id=f"producto_{product.id}_{len(product.image_urls) + 1}",
            overwrite=False,
            resource_type="image"
        )
        
        if len(product.image_urls) < 3:
            # ✅ Hacer una copia para evitar problemas de mutabilidad
            new_urls = product.image_urls.copy()
            new_urls.append(upload_result['secure_url'])
            
            # ✅ Asignar la nueva lista
            product.image_urls = new_urls
            
            # ✅ ¡Notificar a SQLAlchemy que el campo cambió!
            flag_modified(product, "image_urls")
            
            db.session.commit()
            flash('✅ Imagen subida correctamente', 'success')
        else:
            flash('⚠️ Máximo 3 imágenes permitidas.', 'warning')
            
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"Error Cloudinary: {str(e)}")
        flash('❌ Error al subir la imagen.', 'danger')
    
    return redirect(url_for('routes.editar_producto', product_id=product_id))

@routes.route('/producto/<int:product_id>/imagen/<int:index>/eliminar', methods=['POST'])
@login_required
def eliminar_imagen_producto(product_id, index):
    product = Product.query.get_or_404(product_id)
    if not check_access(product.doctor_id):
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.mi_perfil'))

    if not product.image_urls or index < 0 or index >= len(product.image_urls):
        flash('❌ Índice de imagen inválido.', 'danger')
        return redirect(url_for('routes.editar_producto', product_id=product_id))

    try:
        # Eliminar imagen de la lista localmente
        removed_url = product.image_urls.pop(index)
        flag_modified(product, "image_urls")
        db.session.commit()

        # Intentar borrar de Cloudinary
        public_id = extract_public_id_from_url(removed_url)
        if public_id:
            try:
                cloudinary.uploader.destroy(public_id)
            except Exception as e:
                current_app.logger.warning(f"No se pudo eliminar de Cloudinary: {e}")

        flash('✅ Imagen eliminada correctamente', 'success')
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"Error al eliminar imagen: {e}")
        flash('❌ Error al eliminar la imagen.', 'danger')

    return redirect(url_for('routes.editar_producto', product_id=product_id))

# ==== CARRITO DE COMPRAS ====
# ---------- Ver carrito y checkout ----------
@routes.route('/carrito', methods=['GET', 'POST'])
@login_required
def carrito():
    cart = session.get('cart', {})
    product_ids = list(cart.keys())
    products = Product.query.filter(Product.id.in_(product_ids)).all() if product_ids else []

    cart_items = []
    total = Decimal('0.00')
    stock_issue = False
    tienda = products[0].doctor if products and products[0].doctor else None
    store_name = getattr(tienda, 'username', 'Tienda desconocida')
    tienda_slug = getattr(tienda, 'url_slug', None)
    owner_email = getattr(tienda, 'email', None)
    owner_photo = getattr(tienda, 'profile_photo', None)

    # Obtener instrucciones de pago del profesional
    payment_instructions = getattr(tienda, 'payment_instructions', 
                                   "Por favor, comunícate con el vendedor para coordinar el pago y la entrega del producto.")

    for p in products:
        qty = cart.get(str(p.id), 0)

        # Verificar stock
        if not p.is_service and qty > p.stock:
            qty = p.stock
            stock_issue = True
            cart[str(p.id)] = qty

        price = Decimal(str(p.final_price or 0)).quantize(Decimal('0.01'), rounding=ROUND_HALF_UP)
        subtotal = price * qty
        total += subtotal

        # Obtener la URL de la primera imagen o usar una imagen predeterminada
        product_image_url = p.image_urls[0] if p.image_urls else url_for('static', filename='images/default-product.png')

        cart_items.append({
            'product': p,
            'quantity': qty,
            'subtotal': subtotal,
            'price': price,
            'image_url': product_image_url  # Añadir la URL de la imagen al carrito
        })

    session['cart'] = cart
    session.modified = True

    if request.method == 'POST' and 'checkout' in request.form:
        customer_name = request.form.get('customer_name', '').strip()
        customer_email = request.form.get('customer_email', '').strip()
        customer_phone = request.form.get('customer_phone', '').strip()
        payment_method = request.form.get('payment_method', 'Sin especificar')

        if not customer_name or not customer_email:
            flash("❌ Nombre y email del cliente son obligatorios", "danger")
            return redirect(url_for('routes.carrito'))

        # Enviar mail al dueño de la tienda
        if owner_email:
            try:
                msg = Message(
                    subject="Nueva compra en tu tienda - BioForge",
                    sender=current_app.config['MAIL_DEFAULT_SENDER'],
                    recipients=[owner_email],
                    body=f"Cliente: {customer_name}\nEmail: {customer_email}\nTeléfono: {customer_phone}\nTotal: ${total:.2f}\nForma de pago: {payment_method}\nProductos:\n" +
                         "\n".join([f"{item['quantity']} x {item['product'].name} (${item['price']:.2f})" for item in cart_items])
                )
                current_app.mail.send(msg)
            except Exception as e:
                print("Error enviando correo al dueño de la tienda:", e)

        # Enviar mail al administrador
        try:
            admin_email = current_app.config['ADMIN_EMAIL']
            msg_admin = Message(
                subject="[BioForge] Compra realizada",
                sender=current_app.config['MAIL_DEFAULT_SENDER'],
                recipients=[admin_email],
                body=f"Compra realizada por {customer_name} ({customer_email}). Total: ${total:.2f}\nProductos:\n" +
                     "\n".join([f"{item['quantity']} x {item['product'].name} (${item['price']:.2f})" for item in cart_items])
            )
            current_app.mail.send(msg_admin)
        except Exception as e:
            print("Error enviando correo al admin:", e)

        # Vaciar carrito
        session.pop('cart', None)
        flash("✅ Compra completada. El dueño de la tienda y el administrador fueron notificados.", "success")

        # Redirigir a la tienda
        return redirect(url_for('routes.tienda_publica', url_slug=tienda_slug) if tienda_slug else url_for('routes.index'))

    return render_template(
        'ecommerce/carrito.html',
        cart_items=cart_items,
        total=total,
        stock_issue=stock_issue,
        store_name=store_name,
        tienda_slug=tienda_slug,
        owner_photo=owner_photo,
        payment_instructions=payment_instructions  # Pasar las instrucciones de pago al template
    )

# Agregar al carrito
@routes.route('/agregar_al_carrito/<int:product_id>', methods=['POST'])
@login_required
def agregar_al_carrito(product_id):
    product = Product.query.get_or_404(product_id)

    # Cantidad solicitada
    qty = int(request.form.get('quantity', 1))
    if qty < 1:
        qty = 1

    # Verificar stock
    if not product.is_service and product.stock < qty:
        flash("❌ No hay suficiente stock disponible.", "danger")
        return redirect(request.referrer or url_for('routes.tienda_publica', url_slug=product.doctor.url_slug))

    cart = session.get('cart', {})

    # Si ya está en el carrito, sumamos
    current_qty = int(cart.get(str(product_id), 0))
    new_qty = current_qty + qty

    # No permitir superar el stock
    if not product.is_service and new_qty > product.stock:
        new_qty = product.stock
        flash(f"⚠️ Solo hay {product.stock} unidades disponibles.", "warning")

    cart[str(product_id)] = new_qty
    session['cart'] = cart
    session.modified = True

    flash(f"✅ {product.name} agregado al carrito.", "success")
    return redirect(request.referrer or url_for('routes.tienda_publica', url_slug=product.doctor.url_slug))

# actualizar contador carrito
@routes.route('/cart_count')
def cart_count():
    cart = session.get('cart', [])
    return jsonify({'count': len(cart)})

# Actualizar carrito
@routes.route('/actualizar_carrito', methods=['POST'])
def actualizar_carrito():
    data = request.get_json()
    cart = session.get('cart', [])
    for item in cart:
        pid = str(item['id'])
        if pid in data:
            item['cantidad'] = int(data[pid])
    session['cart'] = cart
    total = sum(i['precio'] * i['cantidad'] for i in cart)
    return jsonify({'success': True, 'total': total})


# Vaciar carrito
@routes.route('/vaciar_carrito/<url_slug>', methods=['POST'])
def vaciar_carrito(url_slug):
    session.pop('cart', None)
    # Devuelve un JSON indicando éxito y la URL a la que redirigir
    return jsonify({'success': True, 'redirect_url': url_for('routes.tienda_publica', url_slug=url_slug)})

@routes.route("/add_to_cart", methods=["POST"])
def add_to_cart():
    data = request.get_json()
    product_id = data.get("id")
    product_name = data.get("name")

    if "cart" not in session:
        session["cart"] = []

    session["cart"].append({"id": product_id, "name": product_name})
    session.modified = True  # importante para que Flask guarde cambios en session

    return jsonify(success=True, cart_count=len(session["cart"]))

@routes.route('/checkout', methods=['POST'])
def checkout():
    data = request.form
    cart = session.get('cart', [])

    if not cart:
        return jsonify({'success': False, 'message': 'El carrito está vacío'})

    total = sum(item['precio'] * item['cantidad'] for item in cart)

    # 🔸 Simulación de creación de orden (sin BD)
    # order = Order(
    #     customer_name=data.get('customer_name'),
    #     customer_email=data.get('customer_email'),
    #     customer_phone=data.get('customer_phone'),
    #     payment_method=data.get('payment_method'),
    #     total=total
    # )
    # db.session.add(order)
    # db.session.commit()

    # 🔸 Guardar los ítems (simulado)
    # for item in cart:
    #     order_item = OrderItem(
    #         order_id=order.id,
    #         product_id=item['id'],
    #         quantity=item['cantidad'],
    #         price=item['precio']
    #     )
    #     db.session.add(order_item)
    # db.session.commit()

    # 🔸 Simulación de número de orden
    import uuid
    order_id = str(uuid.uuid4())[:8]

    # Limpiar carrito
    session.pop('cart', None)

    return jsonify({
        'success': True,
        'message': f'Compra #{order_id} registrada con éxito (simulada)',
        'order_id': order_id,
        'total': total
    })

# === GESTION de EVENTOS ===
@routes.route('/profesional/<url_slug>')
def view_professional(url_slug):
    # Buscar el usuario/profesional por su URL slug
    user = User.query.filter_by(url_slug=url_slug, is_professional=True).first_or_404()

    # Obtener el número máximo de eventos a mostrar (opcional)
    max_events = request.args.get('max_events', None, type=int)

    # Filtrar los eventos del usuario/profesional
    if max_events:
        events = user.events.order_by(Event.start_datetime.asc()).limit(max_events).all()
    else:
        events = user.events.order_by(Event.start_datetime.asc()).all()

    # Renderizar el template con el usuario y sus eventos
    return render_template(
        'professional_profile.html',
        user=user,  # Pasar el objeto user en lugar de professional
        events=events
    )

@routes.route('/<int:doctor_id>/eventos')
@login_required
def gestion_eventos(doctor_id):
    if not check_access(doctor_id):
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.mi_perfil'))
    
    events = Event.query.filter_by(doctor_id=doctor_id).order_by(Event.start_datetime.asc()).all()
    return render_template('ecommerce/gestion_eventos.html', events=events, doctor_id=doctor_id)

# === CALENDARIO PÚBLICO ===
@routes.route('/eventos/<string:url_slug>')
def eventos_publicos(url_slug):
    professional = User.query.filter_by(url_slug=url_slug, is_professional=True).first_or_404()
    now = datetime.utcnow()

    # Obtener eventos públicos directos
    events = Event.query.filter_by(
        doctor_id=professional.id,
        is_public=True
    ).filter(Event.end_datetime >= now).order_by(Event.start_datetime).all()

    # Obtener publicaciones asociadas a eventos
    publications = Publication.query.filter_by(
        user_id=professional.id,
        is_published=True
    ).join(Event, Publication.event).filter(Event.end_datetime >= now).all()

    return render_template('ecommerce/eventos_publicos.html', professional=professional, events=events, publications=publications)

# === EVENTOS ===
@routes.route('/<int:doctor_id>/evento/nuevo', methods=['GET', 'POST'])
@login_required
def crear_evento(doctor_id):
    # Verificar acceso
    if current_user.id != doctor_id or not current_user.is_professional:
        flash('Acceso denegado. Solo los profesionales pueden crear eventos.', 'danger')
        return redirect(url_for('routes.mi_perfil'))
    
    # Obtener consultorios activos del profesional
    clinics = Clinic.query.filter_by(doctor_id=doctor_id, is_active=True).all()
    professional = User.query.get_or_404(doctor_id)

    # Crear el formulario
    form = EventForm()
    form.clinic_id.choices = [(c.id, c.name) for c in clinics] if clinics else [(-1, "Sin consultorios disponibles")]

    if form.validate_on_submit():
        # Subir imagen a Cloudinary
        image_url = None
        if form.image.data and form.image.data.filename:
            file = form.image.data
            upload_result = cloudinary.uploader.upload(file)
            image_url = upload_result['secure_url']

        # Crear el evento
        event = Event(
            title=form.title.data.strip(),
            description=form.description.data.strip(),
            start_datetime=form.start_datetime.data,
            end_datetime=form.end_datetime.data,
            location=form.location.data.strip() if form.location.data else None,
            clinic_id=form.clinic_id.data if form.clinic_id.data != -1 else None,  # Manejar caso sin consultorios
            is_public=form.is_public.data,
            max_attendees=form.max_attendees.data or None,
            doctor_id=doctor_id,
            created_by=current_user.id,
            image_url=image_url  # Guardar la URL de la imagen
        )
        db.session.add(event)
        db.session.commit()
        
        flash('✅ Evento creado exitosamente.', 'success')
        return redirect(url_for('routes.mi_perfil'))
    
    return render_template(
        'ecommerce/form_evento.html', 
        form=form, 
        doctor_id=doctor_id, 
        clinics=clinics, 
        professional=professional,
        event=None  # Asegúrate de pasar `event=None` explícitamente
    )


@routes.route('/editar-evento/<int:event_id>', methods=['GET', 'POST'])
@login_required
def editar_evento(event_id):
    # Obtener el evento
    event = Event.query.get_or_404(event_id)
    if not check_access(event.doctor_id):
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.mi_perfil'))

    # Obtener la dirección del consultorio si existe
    clinic_address = None
    if event.clinic_id:
        clinic = Clinic.query.get(event.clinic_id)
        if clinic:
            clinic_address = f"{clinic.address}"

    # Obtener las coordenadas de la ubicación si existe
    location_coords = None
    if event.location:
        try:
            import requests
            response = requests.get(f"https://nominatim.openstreetmap.org/search?format=json&q={event.location}")
            data = response.json()
            if data:
                location_coords = {
                    "lat": float(data[0]["lat"]),
                    "lon": float(data[0]["lon"])
                }
        except Exception as e:
            print("Error obteniendo coordenadas:", str(e))

    # Obtener consultorios activos del profesional
    clinics = Clinic.query.filter_by(doctor_id=event.doctor_id, is_active=True).all()

    # Crear el formulario con los datos actuales del evento
    form = EventForm(obj=event)
    form.clinic_id.choices = [(c.id, c.name) for c in clinics] if clinics else [(-1, "Sin consultorios disponibles")]
    if form.clinic_id.data is None:
        form.clinic_id.data = -1  # Asegurarse de que el valor por defecto sea válido

    if form.validate_on_submit():
        # Subir imagen a Cloudinary si se proporciona una nueva
        if form.image.data and form.image.data.filename:
            file = form.image.data
            upload_result = cloudinary.uploader.upload(file)
            event.image_url = upload_result['secure_url']

        # Actualizar los datos del evento
        event.title = form.title.data.strip()
        event.description = form.description.data.strip()
        event.start_datetime = form.start_datetime.data
        event.end_datetime = form.end_datetime.data
        event.location = form.location.data.strip() if form.location.data else None
        event.clinic_id = form.clinic_id.data if form.clinic_id.data != -1 else None  # Manejar caso sin consultorios
        event.is_public = form.is_public.data
        event.max_attendees = form.max_attendees.data or None

        db.session.commit()
        flash('Evento actualizado exitosamente.', 'success')
        return redirect(url_for('routes.gestion_eventos', doctor_id=event.doctor_id))
    else:
        print(form.errors)  # Imprime los errores del formulario para depurar

    return render_template(
        'ecommerce/form_evento.html',
        form=form,
        professional=current_user,
        event=event,
        location_coords=location_coords,
        clinic_address=clinic_address  # Pasar la dirección del consultorio al template
    )


@routes.route('/eliminar-evento/<int:event_id>', methods=['POST'])
@login_required
def eliminar_evento(event_id):
    event = Event.query.get_or_404(event_id)
    if not check_access(event.doctor_id):
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.mi_perfil'))

    db.session.delete(event)
    db.session.commit()
    flash('Evento eliminado exitosamente.', 'success')
    return redirect(url_for('routes.gestion_eventos', doctor_id=event.doctor_id))

@routes.route('/evento/<int:event_id>/publicar', methods=['POST'])
@login_required
def publicar_evento(event_id):
    # Solo los administradores pueden autorizar la publicación
    if not current_user.is_admin:
        flash('Acceso denegado. Solo los administradores pueden publicar eventos.', 'danger')
        return redirect(url_for('routes.home'))

    event = Event.query.get_or_404(event_id)

    # Crear una nueva publicación asociada al evento
    publication = Publication(
        title=event.title,
        content=event.description,
        excerpt=event.description[:200],
        is_published=True,
        user_id=event.doctor_id,  # La publicación pertenece al profesional
        image_url=event.image_url  # Usar la misma imagen del evento
    )
    db.session.add(publication)
    db.session.commit()

    # Asociar la publicación con el evento
    event.publication_id = publication.id
    db.session.commit()

    flash('Evento publicado exitosamente.', 'success')
    return redirect(url_for('routes.gestion_eventos', doctor_id=event.doctor_id))

@routes.route('/evento/<int:event_id>')
def view_event(event_id):
    # Buscar el evento por su ID
    event = Event.query.get_or_404(event_id)

    return render_template(
        'ecommerce/event_details.html', 
        event=event
    )

# === GESTION CATEGORÍAS DE PRODUCTOS ===
@routes.route('/<int:doctor_id>/categorias')
@login_required
def gestion_categorias(doctor_id):
    if not check_access(doctor_id):
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.mi_perfil'))
    
    categories = ProductCategory.query.filter_by(
        doctor_id=doctor_id, 
        parent_id=None
    ).order_by(ProductCategory.name).all()
    
    return render_template('ecommerce/gestion_categorias.html', doctor_id=doctor_id, categories=categories)

@routes.route('/<int:doctor_id>/categoria/nueva', methods=['GET', 'POST'])
@login_required
def crear_categoria(doctor_id):
    if not check_access(doctor_id):
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.mi_perfil'))
    
    if request.method == 'POST':
        try:
            name = request.form['name'].strip()
            if not name:
                flash('El nombre de la categoría es obligatorio.', 'danger')
                return redirect(request.url)
            
            parent_id = request.form.get('parent_id')
            parent_id = int(parent_id) if parent_id and parent_id.isdigit() else None
            
            # Verificar que la categoría padre pertenezca al mismo profesional
            if parent_id:
                parent = ProductCategory.query.filter_by(
                    id=parent_id,
                    doctor_id=doctor_id
                ).first()
                if not parent:
                    flash('Categoría padre inválida.', 'danger')
                    return redirect(request.url)
            
            category = ProductCategory(
                name=name,
                description=request.form.get('description', '').strip(),
                parent_id=parent_id,
                doctor_id=doctor_id,
                is_active=True  # Nueva categoría siempre activa
            )
            db.session.add(category)
            db.session.commit()
            flash('✅ Categoría creada exitosamente', 'success')
            return redirect(url_for('routes.gestion_categorias', doctor_id=doctor_id))
        
        except Exception as e:
            db.session.rollback()
            print("🧨 Error al crear categoría:", e)
            import traceback
            traceback.print_exc()
            flash(f'❌ Error al crear la categoría: {str(e)}', 'danger')
    
    # Cargar solo categorías raíz (sin padre) y activas del profesional
    root_categories = ProductCategory.query.filter_by(
        doctor_id=doctor_id,
        parent_id=None,
        is_active=True
    ).order_by(ProductCategory.name).all()
    
    return render_template(
        'ecommerce/form_categoria.html',
        doctor_id=doctor_id,
        category=None,
        root_categories=root_categories
    )

@routes.route('/categoria/<int:category_id>/editar', methods=['GET', 'POST'])
@login_required
def editar_categoria(category_id):
    category = ProductCategory.query.get_or_404(category_id)
    if not check_access(category.doctor_id):
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.mi_perfil'))
    
    if request.method == 'POST':
        category.name = request.form['name'].strip()
        category.description = request.form.get('description', '').strip()
        
        parent_id = request.form.get('parent_id')
        category.parent_id = int(parent_id) if parent_id and parent_id.isdigit() else None
        
        db.session.commit()
        flash('✅ Categoría actualizada', 'success')
        return redirect(url_for('routes.gestion_categorias', doctor_id=category.doctor_id))
    
    root_categories = ProductCategory.query.filter_by(
        doctor_id=category.doctor_id, 
        parent_id=None
    ).filter(ProductCategory.id != category_id).order_by(ProductCategory.name).all()
    
    return render_template('ecommerce/form_categoria.html', doctor_id=category.doctor_id, category=category, root_categories=root_categories)

@routes.route('/categoria/<int:category_id>/toggle-estado', methods=['POST'])
@login_required
def toggle_categoria_estado(category_id):
    category = ProductCategory.query.get_or_404(category_id)
    
    if not check_access(category.doctor_id):
        flash('Acceso denegado', 'danger')
        return redirect(url_for('routes.mi_perfil'))
    
    # Alternar estado
    category.is_active = not category.is_active
    db.session.commit()
    
    estado = "activada" if category.is_active else "desactivada"
    flash(f'✅ Categoría "{category.name}" {estado} correctamente.', 'success')
    
    return redirect(url_for('routes.gestion_categorias', doctor_id=category.doctor_id))

@routes.route("/admin/import-data", methods=['GET', 'POST'])
def import_data():
    try:
        import_csv_to_render_db()
        return jsonify({"message": "Datos importados exitosamente."}), 200
    except Exception as e:
        current_app.logger.error(f"Error al importar datos: {e}")
        return jsonify({"error": f"Error al importar datos: {str(e)}"}), 500
    
# === RUTAS ADMINISTRADOR ===
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

@routes.context_processor
def inject_active_assistant():
    """Inyecta el asistente activo en todas las plantillas"""
    if current_user.is_authenticated and session.get('active_role') == 'asistente':
        assistant_id = session.get('active_assistant_id')
        if assistant_id:
            assistant = Assistant.query.get(assistant_id)
            return {'active_assistant': assistant}
    return {'active_assistant': None}

