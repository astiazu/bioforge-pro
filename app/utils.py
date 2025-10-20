# app/utils.py
import os
import requests
import cloudinary.uploader
import urllib.parse
from itsdangerous import URLSafeTimedSerializer
from flask import current_app, url_for
from flask_mail import Message
from email_validator import validate_email, EmailNotValidError
from datetime import datetime
import secrets
import string


# === FUNCIONES DE NOTIFICACIÓN ===

def send_telegram_message(message: str, chat_id: str | None = None) -> bool:
    """Envía un mensaje a Telegram usando el bot configurado."""
    try:
        token = current_app.config.get("TELEGRAM_BOT_TOKEN")
        if not token:
            current_app.logger.warning("⚠️ TELEGRAM_BOT_TOKEN no configurado")
            return False

        chat_id = chat_id or current_app.config.get("TELEGRAM_CHAT_ID")
        if not chat_id:
            current_app.logger.warning("⚠️ TELEGRAM_CHAT_ID no configurado")
            return False

        url = f"https://api.telegram.org/bot{token}/sendMessage"
        payload = {
            "chat_id": chat_id,
            "text": message,
            "parse_mode": "Markdown",
            "disable_web_page_preview": True
        }

        response = requests.post(url, data=payload, timeout=10)
        if response.status_code != 200:
            current_app.logger.error(f"Telegram error {response.status_code}: {response.text}")
        return response.status_code == 200

    except Exception as e:
        current_app.logger.error(f"[send_telegram_message] Error: {str(e)}", exc_info=True)
        return False


def send_whatsapp_message(to: str, message: str) -> bool:
    """Envía un mensaje por WhatsApp (simulado para desarrollo)."""
    try:
        current_app.logger.info(f"📱 WhatsApp simulado a {to}: {message}")
        return True
    except Exception as e:
        current_app.logger.error(f"[send_whatsapp_message] Error: {str(e)}", exc_info=True)
        return False


# === FUNCIONES DE ARCHIVOS ===

def upload_to_cloudinary(file_path: str, folder: str = "bioforge") -> str | None:
    """Sube una imagen a Cloudinary y devuelve la URL segura."""
    try:
        if not file_path:
            raise ValueError("Ruta de archivo no proporcionada para subir a Cloudinary.")

        response = cloudinary.uploader.upload(
            file_path,
            folder=folder,
            transformation=[
                {"width": 1200, "height": 800, "crop": "limit"},
                {"quality": "auto:good"}
            ]
        )
        return response.get("secure_url")

    except Exception as e:
        current_app.logger.error(f"[upload_to_cloudinary] Error: {str(e)}", exc_info=True)
        return None


# === FUNCIONES DE MENSAJES ===

def crear_mensaje_whatsapp(assistant, task, action: str = "asignada") -> str:
    """Genera un mensaje predefinido y URL-encoded para WhatsApp."""
    nombre = assistant.name.split()[0] if assistant.name else "Asistente"
    status_map = {
        "pending": "Pendiente",
        "in_progress": "En progreso",
        "completed": "Completada",
        "cancelled": "Cancelada"
    }
    estado = status_map.get(task.status, "Actualizada")

    mensaje = f"""
Hola {nombre}, tienes una actualización en tu tarea:

📌 *{task.title}*
{task.description or 'Sin descripción'}

📅 Fecha límite: {task.due_date.strftime('%d/%m/%Y') if task.due_date else 'No especificada'}
✅ Estado: {estado}

Este mensaje fue generado automáticamente desde tu sistema de gestión.
""".strip()
    return urllib.parse.quote(mensaje)


# === FUNCIONES DE INVITACIÓN Y EMAIL ===

def generate_invite_token(email: str) -> str:
    s = URLSafeTimedSerializer(current_app.config["SECRET_KEY"])
    return s.dumps({"email": email}, salt="invite-salt")


def verify_invite_token(token: str, max_age: int = 60 * 60 * 24 * 7) -> str | None:
    s = URLSafeTimedSerializer(current_app.config["SECRET_KEY"])
    try:
        data = s.loads(token, salt="invite-salt", max_age=max_age)
        return data.get("email")
    except Exception:
        return None


def send_invite_email(recipient_email: str, invite_token: str, assistant_name: str, inviter_name: str) -> None:
    """Envía un correo electrónico con el enlace de invitación."""
    try:
        invite_url = url_for("routes.accept_invite", token=invite_token, _external=True)
        subject = f"Invitación para crear cuenta de Asistente — {current_app.config.get('APP_NAME', 'BioForge')}"
        body = f"""Hola {assistant_name},

Has sido invitado(a) por {inviter_name} a registrarte como Asistente en {current_app.config.get('APP_NAME', 'la plataforma')}.
Por favor, completa tu registro y define tu contraseña en este enlace:

{invite_url}

Este enlace expira en 7 días.

Si no esperabas este correo, por favor ignóralo.
"""

        mail = current_app.extensions.get("mail")
        if not mail:
            raise RuntimeError("La extensión Flask-Mail no está inicializada.")
        msg = Message(subject=subject, recipients=[recipient_email], body=body)
        mail.send(msg)

    except Exception as e:
        current_app.logger.error(f"[send_invite_email] Error enviando email: {str(e)}", exc_info=True)


# === OTROS ===

def can_manage_tasks(user, doctor_id: int) -> bool:
    """Verifica si un usuario tiene permisos para gestionar tareas."""
    if not user or not user.is_active:
        return False
    if user.is_admin:
        return True
    if user.is_professional and user.id == doctor_id:
        return True
    if user.is_general_assistant and any(a.doctor_id == doctor_id for a in user.assistant_accounts):
        return True
    return False


def generate_unique_invite_code() -> str:
    """Genera un código único de invitación."""
    from app.models import CompanyInvite
    while True:
        code = "".join(secrets.choice(string.ascii_uppercase + string.digits) for _ in range(8))
        if not CompanyInvite.query.filter_by(invite_code=code).first():
            return code


def send_company_invite(invite, doctor_user) -> dict:
    """Genera un enlace de registro y mensaje de invitación (con WhatsApp opcional)."""
    try:
        invite_url = url_for("routes.registro_con_codigo", invite_code=invite.invite_code, _external=True)
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
            phone = "".join(c for c in invite.whatsapp if c.isdigit())
            if phone and not phone.startswith("54"):  # 🇦🇷 Ajusta según tu país
                phone = "54" + phone

            if phone:
                whatsapp_text = urllib.parse.quote(message)
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
            "code": getattr(invite, "invite_code", ""),
            "url": "",
            "whatsapp_link": None,
            "whatsapp_available": False,
            "message": ""
        }


def is_valid_email(email: str) -> bool:
    """Valida formato y dominio del correo electrónico."""
    try:
        validate_email(email)
        return True
    except EmailNotValidError:
        return False


def generate_verification_code() -> str:
    """Genera un código de verificación único de 6 caracteres."""
    return secrets.token_hex(3)


def format_date(value, format: str = "%d/%m/%Y") -> str:
    """Formatea una fecha según el formato especificado."""
    if not value:
        return ""
    if isinstance(value, str):
        try:
            value = datetime.fromisoformat(value)
        except ValueError:
            return value
    return value.strftime(format)

def send_verification_email(email, verification_code):
    """Envía un correo de verificación usando el email y el código."""
    try:
        verify_url = url_for("auth.verify_email", code=verification_code, _external=True)

        subject = f"Verificá tu cuenta — {current_app.config.get('APP_NAME', 'BioForge')}"
        body = f"""Hola,

Gracias por registrarte en {current_app.config.get('APP_NAME', 'nuestra plataforma')}.

Para activar tu cuenta, haz clic en el siguiente enlace:

{verify_url}

Este enlace expira en 24 horas.

Si no creaste esta cuenta, ignora este mensaje.
"""

        mail = current_app.extensions.get("mail")
        if not mail:
            raise RuntimeError("Flask-Mail no está inicializado.")

        msg = Message(subject=subject, recipients=[email], body=body)
        mail.send(msg)
        current_app.logger.info(f"📧 Correo de verificación enviado a {email}")
        return True

    except Exception as e:
        current_app.logger.error(f"[send_verification_email] Error: {str(e)}", exc_info=True)
        return False