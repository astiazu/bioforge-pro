# app/utils.py
import os
import requests
import cloudinary
import cloudinary.uploader
import urllib.parse
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