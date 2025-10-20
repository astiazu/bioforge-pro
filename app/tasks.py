# app/tasks.py
from celery import Celery
from flask_mail import Message
from flask import current_app

# Configura Celery
def make_celery(app=None):
    app = app or current_app
    celery = Celery(
        app.import_name,
        backend=app.config['result_backend'],  # Usa el nombre nuevo
        broker=app.config['broker_url'],       # Usa el nombre nuevo
        imports=app.config['imports']          # Usa el nombre nuevo
    )
    celery.conf.update(app.config)

    class ContextTask(celery.Task):
        def __call__(self, *args, **kwargs):
            with app.app_context():
                return self.run(*args, **kwargs)

    celery.Task = ContextTask
    return celery

# Exporta la instancia de Celery
celery = make_celery()

# Tarea para enviar correos
@celery.task
def send_async_email(email_data):
    msg = Message(
        email_data['subject'],
        sender=email_data['sender'],
        recipients=email_data['recipients']
    )
    msg.body = email_data['body']

    # Usa current_app para acceder a la instancia de Flask-Mail
    mail = current_app.extensions['mail']
    mail.send(msg)