# app/admin/data_migration.py
import os
import csv
from io import StringIO
from dateutil import parser as date_parser
import json
from flask import current_app
from app import db
from app.models import (
    UserRole, User, Clinic, ProductCategory, Assistant, Availability,
    Appointment, MedicalRecord, Schedule, Note, Publication, Task,
    CompanyInvite, InvitationLog, Subscriber, Product, Event, Anuncio, Visit
)

# Orden de importación (respetando dependencias)
IMPORT_ORDER = [
    ('user_roles', UserRole),
    ('users', User),
    ('clinic', Clinic),
    ('product_category', ProductCategory),
    ('assistants', Assistant),
    ('availability', Availability),
    ('appointments', Appointment),
    ('medical_records', MedicalRecord),
    ('schedules', Schedule),
    ('notes', Note),
    ('publications', Publication),
    ('tasks', Task),
    ('company_invites', CompanyInvite),
    ('invitation_logs', InvitationLog),
    ('subscribers', Subscriber),
    ('product', Product),
    ('event', Event),
    ('anuncios', Anuncio),
    ('visits', Visit),
]

def safe_boolean(value):
    if value is None:
        return False
    if isinstance(value, str):
        v = value.strip().lower()
        if v in ('1', 'true', 't', 'yes', 'on'):
            return True
        if v in ('0', 'false', 'f', 'no', 'off', ''):
            return False
    return bool(value)

def parse_value(key, value, model_class):
    if value == '':
        return None
    elif key in ['id', 'user_id', 'doctor_id', 'assistant_id', 'clinic_id', 'patient_id', 'role_id', 'created_by', 'approved_by', 'updated_by', 'appointment_id', 'publication_id', 'profesional_id', 'category_id', 'parent_id']:
        return int(value) if value and value.isdigit() else None
    elif key in ['is_active', 'is_admin', 'is_professional', 'is_used', 'success', 'store_enabled', 'email_verified', 'has_tax_included', 'is_on_promotion', 'is_service', 'is_visible', 'hide_if_out_of_stock', 'es_destacado']:
        return safe_boolean(value)
    elif key in ['created_at', 'updated_at', 'due_date', 'published_at', 'expires_at', 'used_at', 'approved_at', 'creado_en', 'expira_en', 'start_datetime', 'end_datetime']:
        if value:
            try:
                return date_parser.parse(value)
            except:
                return None
        return None
    elif key in ['preferences', 'image_urls', 'skills']:
        if value and value.strip():
            try:
                return json.loads(value)
            except:
                return {} if key == 'preferences' else []
        return {} if key == 'preferences' else []
    else:
        return value

def clear_all_tables():
    """Vacía todas las tablas en orden inverso de dependencias."""
    models_to_clear = [
        Visit, InvitationLog, CompanyInvite, Subscriber,
        MedicalRecord, Appointment, Availability, Schedule,
        Task, Assistant, Publication, Note,
        Event, Product, ProductCategory, Anuncio, Clinic, User, UserRole
    ]
    for model in models_to_clear:
        model.query.delete()
    db.session.commit()

def import_csv_to_model(table_name, model_class, csv_content):
    stream = StringIO(csv_content.decode('utf-8-sig'))
    reader = csv.DictReader(stream)
    success_count = 0

    for row in reader:
        cleaned = {}
        for key, value in row.items():
            cleaned[key] = parse_value(key, value, model_class)

        # Evitar duplicados por ID
        if 'id' in cleaned and cleaned['id']:
            existing = model_class.query.get(cleaned['id'])
            if existing:
                continue

        obj = model_class(**cleaned)
        db.session.add(obj)
        success_count += 1

    db.session.commit()
    current_app.logger.info(f"✅ Importado: {success_count} registros en '{table_name}'")
    return success_count

def run_data_migration(csv_files_dict):
    """
    Ejecuta la migración completa.
    :param csv_files_dict: dict con {table_name: csv_file_bytes}
    """
    try:
        # Paso 1: Vaciar todas las tablas
        clear_all_tables()
        current_app.logger.info("✅ Todas las tablas han sido vaciadas.")

        # Paso 2: Importar en orden
        for table_name, model_class in IMPORT_ORDER:
            if table_name in csv_files_dict:
                csv_bytes = csv_files_dict[table_name]
                import_csv_to_model(table_name, model_class, csv_bytes)
            else:
                current_app.logger.warning(f"⚠️  CSV no encontrado para '{table_name}'")

        current_app.logger.info("🎉 Migración de datos completada con éxito.")
        return True
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"❌ Error durante la migración: {str(e)}")
        raise

__all__ = ['run_data_migration', 'clear_all_tables']