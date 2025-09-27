# app/utils.py
import os
import requests
import cloudinary
import cloudinary.uploader
import urllib.parse
from itsdangerous import URLSafeTimedSerializer
from flask import current_app, url_for, request
from flask_mail import Message
from app import mail, db
from datetime import datetime
import secrets
import string

# === FUNCIONES DE NOTIFICACIÓN (con nombres correctos para routes.py) ===

def send_telegram_message(message, chat_id=None):
    """
    Envía un mensaje a Telegram.
    Compatible con la importación en routes.py
    """
    try:
        token = current_app.config.get('TELEGRAM_BOT_TOKEN')
        if not token:
            current_app.logger.warning("TELEGRAM_BOT_TOKEN no configurado")
            return False
            
        chat_id = chat_id or current_app.config.get('TELEGRAM_CHAT_ID')
        if not chat_id:
            current_app.logger.warning("TELEGRAM_CHAT_ID no configurado")
            return False

        # ✅ Corrección: eliminar espacios en la URL
        url = f"https://api.telegram.org/bot{token}/sendMessage"
        payload = {
            'chat_id': chat_id,
            'text': message,
            'parse_mode': 'Markdown',
            'disable_web_page_preview': True
        }
        response = requests.post(url, data=payload, timeout=10)
        return response.status_code == 200
        
    except Exception as e:
        current_app.logger.error(f"Error enviando mensaje a Telegram: {str(e)}")
        return False

def send_whatsapp_message(to, message):
    """
    Envía un mensaje por WhatsApp (versión simplificada para desarrollo).
    Compatible con la importación en routes.py
    """
    try:
        # Para desarrollo local, solo logueamos
        current_app.logger.info(f"WhatsApp simulado a {to}: {message}")
        
        # Si quieres implementar Twilio en el futuro, descomenta esto:
        # from twilio.rest import Client
        # account_sid = os.environ.get('TWILIO_ACCOUNT_SID')
        # auth_token = os.environ.get('TWILIO_AUTH_TOKEN')
        # if account_sid and auth_token:
        #     client = Client(account_sid, auth_token)
        #     whatsapp_from = os.environ.get('TWILIO_WHATSAPP_NUMBER')
        #     client.messages.create(
        #         body=message,
        #         from_=f'whatsapp:+{whatsapp_from}',
        #         to=f'whatsapp:+{to}'
        #     )
        #     return True
        
        return True  # Simula éxito en desarrollo
        
    except Exception as e:
        current_app.logger.error(f"Error en WhatsApp: {str(e)}")
        return False

# === FUNCIONES EXISTENTES (mejoradas) ===

def upload_to_cloudinary(file_path, folder="bioforge"):
    """Sube una imagen a Cloudinary."""
    try:
        if not hasattr(cloudinary, 'config'):
            current_app.logger.warning("Cloudinary no configurado")
            return None
            
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
        current_app.logger.error(f"Error subiendo a Cloudinary: {str(e)}")
        return None

def crear_mensaje_whatsapp(assistant, task, action="asignada"):
    """Genera un mensaje predefinido para WhatsApp"""
    nombre = assistant.name.split()[0] if assistant.name else "Asistente"
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

# === FUNCIONES DE INVITACIÓN ===

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
    try:
        if mail:
            msg = Message(subject=subject, recipients=[recipient_email], body=body)
            mail.send(msg)
        else:
            current_app.logger.info(f"INVITE EMAIL to {recipient_email}:\n{body}")
    except Exception as e:
        current_app.logger.error(f"Error enviando email de invitación: {str(e)}")

def can_manage_tasks(user, doctor_id):
    """Verifica si un usuario puede gestionar tareas del equipo."""
    if not user or not user.is_active:
        return False
    if user.is_professional and user.id == doctor_id:
        return True
    if user.is_general_assistant and any(a.doctor_id == doctor_id for a in user.assistant_accounts):
        return True
    if user.is_admin:
        return True
    return False

# === INVITACIONES PARA EMPRESAS ===

def generate_unique_invite_code():
    from app.models import CompanyInvite
    while True:
        code = ''.join(secrets.choice(string.ascii_uppercase + string.digits) for _ in range(8))
        if not CompanyInvite.query.filter_by(invite_code=code).first():
            return code

def send_company_invite(invite, doctor_user):
    """Genera un enlace de registro para un asistente general."""
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
            if phone and not phone.startswith('54'):  # 🇦🇷 Ajusta según tu país
                phone = '54' + phone
            
            if phone:
                whatsapp_text = urllib.parse.quote(message)
                # ✅ Corrección: URL sin espacios
                whatsapp_link = f"https://wa.me/{phone}?text={whatsapp_text}"

        return {
            "code": invite.invite_code,
            "url": invite_url,
            "whatsapp_link": whatsapp_link,
            "whatsapp_available": bool(whatsapp_link),
            "message": message
        }

    except Exception as e:
        current_app.logger.error(f"[send_company_invite] Error: {str(e)}", exc_info=True)
        return {
            "code": invite.invite_code,
            "url": "",
            "whatsapp_link": None,
            "whatsapp_available": False,
            "message": ""
        }

def get_assistant_for_doctor(user, doctor_id):
    """Obtiene el Assistant activo del usuario en una empresa específica"""
    from app.models import Assistant
    return next((a for a in user.assistant_accounts if a.doctor_id == doctor_id), None)

