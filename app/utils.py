# app/utils.py
import os
import requests
import cloudinary
import cloudinary.uploader
import urllib.parse
from itsdangerous import URLSafeTimedSerializer
from flask import current_app, url_for
from flask_mail import Message
from app import mail  # si usás Flask-Mail y lo iniciaste en app/__init__.py
from app import db

from flask import current_app, request

# subir imagenes a cloudinary
def upload_to_cloudinary(file_path, folder="bioforge"):
    """
    Sube una imagen a Cloudinary.
    :param file_path: Ruta del archivo local
    :param folder: Carpeta en Cloudinary
    :return: URL segura o None
    """
    try:
        response = cloudinary.uploader.upload(
            file_path,
            folder=folder,
            transformation=[
                {'width': 1200, 'height': 800, 'crop': 'limit'},
                {'quality': 'auto:good'}
            ]
        )
        return response['secure_url']
    except Exception as e:
        print(f"❌ Error subiendo a Cloudinary: {str(e)}")
        return None
    
# enviar mensajes a telegram    
def enviar_mensaje_telegram(chat_id, text):
    """
    Envía un mensaje directamente a un usuario de Telegram
    """
    try:
        token = current_app.config['TELEGRAM_BOT_TOKEN']
        url = f"https://api.telegram.org/bot{token}/sendMessage"
        payload = {
            'chat_id': chat_id,
            'text': text,
            'parse_mode': 'Markdown',
            'disable_web_page_preview': True
        }
        requests.post(url, data=payload, timeout=10)
    except Exception as e:
        print(f"❌ Error al enviar mensaje a Telegram: {e}")

def crear_mensaje_whatsapp(assistant, task, action="asignada"):
    """Genera un mensaje predefinido para WhatsApp"""
    nombre = assistant.name.split()[0]  # Solo el primer nombre
    status_map = {
        'pending': 'Pendiente',
        'in_progress': 'En progreso',
        'completed': 'Completada',
        'cancelled': 'Cancelada'
    }
    estado = status_map.get(task.status, 'Actualizada')

    mensaje = f"""
        Hola {nombre}, tienes una actualización en tu tarea:

        📌 *{task.title}*
        {task.description or 'Sin descripción'}

        📅 Fecha límite: {task.due_date.strftime('%d/%m/%Y') if task.due_date else 'No especificada'}
        ✅ Estado: {estado}

        Este mensaje fue generado automáticamente desde tu sistema de gestión.
            """.strip()
    return urllib.parse.quote(mensaje)

# endpoint para invitaciones por email
def generate_invite_token(email):
    s = URLSafeTimedSerializer(current_app.config['SECRET_KEY'])
    return s.dumps({'email': email}, salt='invite-salt')

def verify_invite_token(token, max_age=60*60*24*7):
    s = URLSafeTimedSerializer(current_app.config['SECRET_KEY'])
    try:
        data = s.loads(token, salt='invite-salt', max_age=max_age)
        return data.get('email')
    except Exception:
        return None

def send_invite_email(recipient_email, invite_token, assistant_name, inviter_name):
    invite_url = url_for('routes.accept_invite', token=invite_token, _external=True)
    subject = f"Invitación para crear cuenta de Asistente — {current_app.config.get('APP_NAME','App')}"
    body = f"""Hola {assistant_name},

Has sido invitado(a) por {inviter_name} a registrarte como Asistente en {current_app.config.get('APP_NAME','la plataforma')}.
Por favor, completa tu registro y define tu contraseña en este enlace:

{invite_url}

Este enlace expira en 7 días.

Si no esperabas este correo, por favor ignóralo.
"""
    # Si tenés Flask-Mail
    if hasattr(current_app, 'mail') and mail:
        msg = Message(subject=subject, recipients=[recipient_email], body=body)
        mail.send(msg)
    else:
        # Fallback: loguear (o implementar otra integración)
        current_app.logger.info(f"INVITE EMAIL to {recipient_email}:\n{body}")

def can_manage_tasks(user, doctor_id):
    """
    Verifica si un usuario puede gestionar tareas del equipo.
    """
    if not user or not user.is_active:
        return False
    if user.is_professional and user.id == doctor_id:
        return True
    if user.is_general_assistant and user.doctor_id == doctor_id:
        return True
    if hasattr(user, 'role') and user.role == 'admin':
        return True
    return False

# invitaciones para empresas
from app.models import CompanyInvite
def generate_unique_invite_code():
    import secrets
    import string
    while True:
        code = ''.join(secrets.choice(string.ascii_uppercase + string.digits) for _ in range(8))
        if not CompanyInvite.query.filter_by(invite_code=code).first():
            return code

def send_company_invite(invite, doctor_user):
    """
    Genera un enlace de registro para un asistente general.
    Devuelve datos para compartir por WhatsApp o manualmente.
    No lanza excepciones; las maneja internamente.
    """
    from urllib.parse import quote
    from datetime import datetime
    from flask import url_for, current_app
    from app import db  # Asegura que db esté disponible

    try:
        invite_url = url_for('routes.registro_con_codigo', invite_code=invite.invite_code, _external=True)
        
        message = f"""
            Hola {invite.name},

            {doctor_user.username} te ha invitado como Asistente General.

            🔑 Código: {invite.invite_code}
            🌐 Regístrate aquí: {invite_url}

            Este código expira el {invite.expires_at.strftime('%d/%m/%Y a las %H:%M')}.

            ¡Bienvenido al equipo!
        """.strip()

        whatsapp_link = None
        if invite.whatsapp:
            # Limpiar número de teléfono
            phone = ''.join(c for c in invite.whatsapp if c.isdigit())
            if not phone.startswith('54'):  # 🇦🇷 Ajusta según tu país base
                phone = '54' + phone
            
            # Codificar mensaje
            whatsapp_text = quote(message)
            # ✅ Corrección: sin espacios extra en el dominio
            whatsapp_link = f"https://wa.me/{phone}?text={whatsapp_text}"

        return {
            "code": invite.invite_code,
            "url": invite_url,
            "whatsapp_link": whatsapp_link,
            "whatsapp_available": bool(whatsapp_link),
            "message": message
        }

    except Exception as e:
        current_app.logger.error(f"[send_company_invite] Error al procesar invitación {invite.invite_code}: {str(e)}", exc_info=True)
        # Igual devuelve datos básicos
        return {
            "code": invite.invite_code,
            "url": "",
            "whatsapp_link": None,
            "whatsapp_available": False,
            "message": ""
        }
    
def get_assistant_for_doctor(user, doctor_id):
    """Obtiene el Assistant activo del usuario en una empresa específica"""
    return next((a for a in user.assistant_accounts if a.doctor_id == doctor_id), None)
