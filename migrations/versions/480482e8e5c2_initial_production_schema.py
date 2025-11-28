"""initial production schema

Revision ID: 480482e8e5c2
Revises: 
Create Date: 2025-11-28 15:48:06.159680

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = '480482e8e5c2'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    # users
    op.create_table('users',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('username', sa.String(length=100), nullable=False),
        sa.Column('email', sa.String(length=150), nullable=False),
        sa.Column('password_hash', sa.String(length=200), nullable=False),
        sa.Column('is_admin', sa.Boolean(), nullable=False),
        sa.Column('is_professional', sa.Boolean(), nullable=False),
        sa.Column('created_at', sa.DateTime(), nullable=False),
        sa.Column('updated_at', sa.DateTime(), nullable=False),
        sa.Column('url_slug', sa.String(length=100), nullable=True),
        sa.Column('store_enabled', sa.Boolean(), nullable=False),
        sa.Column('preferences', postgresql.JSON(astext_type=sa.Text()), nullable=True),
        sa.Column('email_verified', sa.Boolean(), nullable=False),
        sa.Column('professional_category', sa.String(length=50), nullable=True),
        sa.Column('specialty', sa.String(length=100), nullable=True),
        sa.Column('bio', sa.Text(), nullable=True),
        sa.Column('years_experience', sa.Integer(), nullable=True),
        sa.Column('profile_photo', sa.String(length=200), nullable=True),
        sa.Column('license_number', sa.String(length=100), nullable=True),
        sa.Column('services', sa.Text(), nullable=True),
        sa.Column('skills', sa.Text(), nullable=True),
        sa.Column('role_name', sa.String(length=50), nullable=True),
        sa.Column('role_id', sa.Integer(), nullable=True),
        sa.Column('logo_profesional', sa.String(length=500), nullable=True),
        sa.Column('banner_anuncio', sa.String(length=500), nullable=True),
        sa.Column('es_destacado', sa.Boolean(), nullable=False),
        sa.Column('prioridad_anuncio', sa.Integer(), nullable=False),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('email'),
        sa.UniqueConstraint('username'),
        sa.UniqueConstraint('url_slug')
    )

    # user_roles
    op.create_table('user_roles',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('name', sa.String(length=50), nullable=False),
        sa.Column('description', sa.Text(), nullable=True),
        sa.Column('is_active', sa.Boolean(), nullable=False),
        sa.Column('created_at', sa.DateTime(), nullable=False),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('name')
    )

    # notes
    op.create_table('notes',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('title', sa.String(length=200), nullable=False),
        sa.Column('content', sa.Text(), nullable=False),
        sa.Column('status', sa.String(length=20), nullable=False),
        sa.Column('user_id', sa.Integer(), nullable=False),
        sa.Column('patient_id', sa.Integer(), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=False),
        sa.Column('approved_by', sa.Integer(), nullable=True),
        sa.Column('approved_at', sa.DateTime(), nullable=True),
        sa.Column('updated_at', sa.DateTime(), nullable=False),
        sa.Column('featured_image', sa.String(length=200), nullable=True),
        sa.Column('view_count', sa.Integer(), nullable=False),
        sa.ForeignKeyConstraint(['approved_by'], ['users.id'], ),
        sa.ForeignKeyConstraint(['patient_id'], ['users.id'], ),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ),
        sa.PrimaryKeyConstraint('id')
    )

    # publications
    op.create_table('publications',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('slug', sa.String(length=200), nullable=True),
        sa.Column('type', sa.String(length=50), nullable=False),
        sa.Column('title', sa.String(length=200), nullable=False),
        sa.Column('content', sa.Text(), nullable=False),
        sa.Column('excerpt', sa.String(length=500), nullable=True),
        sa.Column('is_published', sa.Boolean(), nullable=False),
        sa.Column('user_id', sa.Integer(), nullable=False),
        sa.Column('tags', sa.String(length=200), nullable=True),
        sa.Column('read_time', sa.Integer(), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=False),
        sa.Column('updated_at', sa.DateTime(), nullable=False),
        sa.Column('published_at', sa.DateTime(), nullable=True),
        sa.Column('image_url', sa.String(length=300), nullable=True),
        sa.Column('view_count', sa.Integer(), nullable=False),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('slug')
    )

    # clinic
    op.create_table('clinic',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('name', sa.String(length=100), nullable=False),
        sa.Column('address', sa.String(length=200), nullable=False),
        sa.Column('phone', sa.String(length=20), nullable=True),
        sa.Column('specialty', sa.String(length=50), nullable=True),
        sa.Column('doctor_id', sa.Integer(), nullable=False),
        sa.Column('is_active', sa.Boolean(), nullable=False),
        sa.ForeignKeyConstraint(['doctor_id'], ['users.id'], ),
        sa.PrimaryKeyConstraint('id')
    )

    # availability
    op.create_table('availability',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('clinic_id', sa.Integer(), nullable=False),
        sa.Column('date', sa.Date(), nullable=False),
        sa.Column('time', sa.Time(), nullable=False),
        sa.Column('is_booked', sa.Boolean(), nullable=False),
        sa.ForeignKeyConstraint(['clinic_id'], ['clinic.id'], ),
        sa.PrimaryKeyConstraint('id')
    )

    # appointments
    op.create_table('appointments',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('availability_id', sa.Integer(), nullable=False),
        sa.Column('patient_id', sa.Integer(), nullable=False),
        sa.Column('status', sa.String(length=20), nullable=False),
        sa.Column('created_at', sa.DateTime(), nullable=False),
        sa.ForeignKeyConstraint(['availability_id'], ['availability.id'], ),
        sa.ForeignKeyConstraint(['patient_id'], ['users.id'], ),
        sa.PrimaryKeyConstraint('id')
    )

    # medical_records
    op.create_table('medical_records',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('patient_id', sa.Integer(), nullable=False),
        sa.Column('doctor_id', sa.Integer(), nullable=False),
        sa.Column('appointment_id', sa.Integer(), nullable=True),
        sa.Column('title', sa.String(length=100), nullable=False),
        sa.Column('notes', sa.Text(), nullable=False),
        sa.Column('created_at', sa.DateTime(), nullable=False),
        sa.Column('updated_at', sa.DateTime(), nullable=False),
        sa.ForeignKeyConstraint(['appointment_id'], ['appointments.id'], ),
        sa.ForeignKeyConstraint(['doctor_id'], ['users.id'], ),
        sa.ForeignKeyConstraint(['patient_id'], ['users.id'], ),
        sa.PrimaryKeyConstraint('id')
    )

    # schedules
    op.create_table('schedules',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('doctor_id', sa.Integer(), nullable=False),
        sa.Column('clinic_id', sa.Integer(), nullable=False),
        sa.Column('day_of_week', sa.Integer(), nullable=False),
        sa.Column('start_time', sa.Time(), nullable=False),
        sa.Column('end_time', sa.Time(), nullable=False),
        sa.Column('is_active', sa.Boolean(), nullable=False),
        sa.ForeignKeyConstraint(['clinic_id'], ['clinic.id'], ),
        sa.ForeignKeyConstraint(['doctor_id'], ['users.id'], ),
        sa.PrimaryKeyConstraint('id')
    )

    # subscribers
    op.create_table('subscribers',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('email', sa.String(length=150), nullable=False),
        sa.Column('subscribed_at', sa.DateTime(), nullable=False),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('email')
    )

    # assistants
    op.create_table('assistants',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('name', sa.String(length=100), nullable=False),
        sa.Column('email', sa.String(length=120), nullable=True),
        sa.Column('whatsapp', sa.String(length=20), nullable=True),
        sa.Column('is_active', sa.Boolean(), nullable=False),
        sa.Column('created_at', sa.DateTime(), nullable=False),
        sa.Column('clinic_id', sa.Integer(), nullable=True),
        sa.Column('doctor_id', sa.Integer(), nullable=False),
        sa.Column('telegram_id', sa.String(length=50), nullable=True),
        sa.Column('type', sa.String(length=20), nullable=False),
        sa.Column('user_id', sa.Integer(), nullable=True),
        sa.Column('created_by_user_id', sa.Integer(), nullable=True),
        sa.CheckConstraint("type IN ('common', 'general')", name='valid_assistant_type'),
        sa.ForeignKeyConstraint(['clinic_id'], ['clinic.id'], ),
        sa.ForeignKeyConstraint(['doctor_id'], ['users.id'], ),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ),
        sa.ForeignKeyConstraint(['created_by_user_id'], ['users.id'], ),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('clinic_id', 'name', name='uq_assistant_clinic_name')
    )

    # tasks
    op.create_table('tasks',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('title', sa.String(length=150), nullable=False),
        sa.Column('description', sa.Text(), nullable=True),
        sa.Column('due_date', sa.Date(), nullable=True),
        sa.Column('status', sa.String(length=20), nullable=False),
        sa.Column('doctor_id', sa.Integer(), nullable=False),
        sa.Column('assistant_id', sa.Integer(), nullable=False),
        sa.Column('clinic_id', sa.Integer(), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=False),
        sa.Column('created_by', sa.Integer(), nullable=True),
        sa.ForeignKeyConstraint(['assistant_id'], ['assistants.id'], ),
        sa.ForeignKeyConstraint(['clinic_id'], ['clinic.id'], ),
        sa.ForeignKeyConstraint(['created_by'], ['users.id'], ),
        sa.ForeignKeyConstraint(['doctor_id'], ['users.id'], ),
        sa.PrimaryKeyConstraint('id')
    )

    # company_invites
    op.create_table('company_invites',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('doctor_id', sa.Integer(), nullable=False),
        sa.Column('invite_code', sa.String(length=20), nullable=False),
        sa.Column('email', sa.String(length=150), nullable=False),
        sa.Column('name', sa.String(length=100), nullable=False),
        sa.Column('clinic_id', sa.Integer(), nullable=True),
        sa.Column('whatsapp', sa.String(length=20), nullable=True),
        sa.Column('assistant_type', sa.String(length=20), nullable=False),
        sa.Column('is_used', sa.Boolean(), nullable=False),
        sa.Column('created_at', sa.DateTime(), nullable=False),
        sa.Column('expires_at', sa.DateTime(), nullable=False),
        sa.Column('used_at', sa.DateTime(), nullable=True),
        sa.ForeignKeyConstraint(['clinic_id'], ['clinic.id'], ),
        sa.ForeignKeyConstraint(['doctor_id'], ['users.id'], ),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('invite_code')
    )

    # invitation_logs
    op.create_table('invitation_logs',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('invite_code', sa.String(length=20), nullable=False),
        sa.Column('email', sa.String(length=150), nullable=False),
        sa.Column('method', sa.String(length=20), nullable=True),
        sa.Column('success', sa.Boolean(), nullable=False),
        sa.Column('error_message', sa.Text(), nullable=True),
        sa.Column('sent_at', sa.DateTime(), nullable=False),
        sa.Column('doctor_id', sa.Integer(), nullable=False),
        sa.Column('assistant_name', sa.String(length=100), nullable=True),
        sa.ForeignKeyConstraint(['doctor_id'], ['users.id'], ),
        sa.PrimaryKeyConstraint('id')
    )

    # product_category
    op.create_table('product_category',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('name', sa.String(length=100), nullable=False),
        sa.Column('description', sa.Text(), nullable=True),
        sa.Column('parent_id', sa.Integer(), nullable=True),
        sa.Column('is_active', sa.Boolean(), nullable=False),
        sa.Column('doctor_id', sa.Integer(), nullable=False),
        sa.ForeignKeyConstraint(['doctor_id'], ['users.id'], ),
        sa.ForeignKeyConstraint(['parent_id'], ['product_category.id'], ),
        sa.PrimaryKeyConstraint('id')
    )

    # product
    op.create_table('product',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('name', sa.String(length=100), nullable=False),
        sa.Column('description', sa.Text(), nullable=True),
        sa.Column('base_price', sa.Numeric(precision=10, scale=2), nullable=False),
        sa.Column('tax_rate', sa.Numeric(precision=5, scale=2), nullable=False),
        sa.Column('has_tax_included', sa.Boolean(), nullable=False),
        sa.Column('is_on_promotion', sa.Boolean(), nullable=False),
        sa.Column('promotion_discount', sa.Numeric(precision=5, scale=2), nullable=False),
        sa.Column('promotion_end_date', sa.DateTime(), nullable=True),
        sa.Column('image_urls', postgresql.JSON(astext_type=sa.Text()), nullable=False),
        sa.Column('is_service', sa.Boolean(), nullable=False),
        sa.Column('stock', sa.Integer(), nullable=False),
        sa.Column('is_visible', sa.Boolean(), nullable=False),
        sa.Column('hide_if_out_of_stock', sa.Boolean(), nullable=False),
        sa.Column('category_id', sa.Integer(), nullable=True),
        sa.Column('doctor_id', sa.Integer(), nullable=False),
        sa.Column('created_by', sa.Integer(), nullable=False),
        sa.Column('updated_by', sa.Integer(), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=False),
        sa.Column('updated_at', sa.DateTime(), nullable=False),
        sa.ForeignKeyConstraint(['category_id'], ['product_category.id'], ),
        sa.ForeignKeyConstraint(['created_by'], ['users.id'], ),
        sa.ForeignKeyConstraint(['doctor_id'], ['users.id'], ),
        sa.ForeignKeyConstraint(['updated_by'], ['users.id'], ),
        sa.PrimaryKeyConstraint('id')
    )

    # event
    op.create_table('event',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('title', sa.String(length=100), nullable=False),
        sa.Column('description', sa.Text(), nullable=True),
        sa.Column('start_datetime', sa.DateTime(), nullable=False),
        sa.Column('end_datetime', sa.DateTime(), nullable=False),
        sa.Column('location', sa.String(length=150), nullable=True),
        sa.Column('clinic_id', sa.Integer(), nullable=True),
        sa.Column('is_public', sa.Boolean(), nullable=False),
        sa.Column('max_attendees', sa.Integer(), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=False),
        sa.Column('updated_at', sa.DateTime(), nullable=False),
        sa.Column('doctor_id', sa.Integer(), nullable=False),
        sa.Column('created_by', sa.Integer(), nullable=False),
        sa.Column('updated_by', sa.Integer(), nullable=True),
        sa.Column('image_url', sa.String(length=300), nullable=True),
        sa.Column('publication_id', sa.Integer(), nullable=True),
        sa.ForeignKeyConstraint(['clinic_id'], ['clinic.id'], ),
        sa.ForeignKeyConstraint(['doctor_id'], ['users.id'], ),
        sa.ForeignKeyConstraint(['created_by'], ['users.id'], ),
        sa.ForeignKeyConstraint(['publication_id'], ['publications.id'], ),
        sa.ForeignKeyConstraint(['updated_by'], ['users.id'], ),
        sa.PrimaryKeyConstraint('id')
    )

    # anuncios
    op.create_table('anuncios',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('profesional_id', sa.Integer(), nullable=False),
        sa.Column('imagen_url', sa.String(length=500), nullable=False),
        sa.Column('titulo', sa.String(length=200), nullable=False),
        sa.Column('descripcion', sa.Text(), nullable=True),
        sa.Column('url_destino', sa.String(length=500), nullable=True),
        sa.Column('esta_activo', sa.Boolean(), nullable=False),
        sa.Column('posicion', sa.String(length=50), nullable=True),
        sa.Column('orden_visualizacion', sa.Integer(), nullable=False),
        sa.Column('contador_clics', sa.Integer(), nullable=False),
        sa.Column('contador_impresiones', sa.Integer(), nullable=False),
        sa.Column('creado_en', sa.DateTime(), nullable=False),
        sa.Column('expira_en', sa.DateTime(), nullable=True),
        sa.ForeignKeyConstraint(['profesional_id'], ['users.id'], ),
        sa.PrimaryKeyConstraint('id')
    )

    # visits
    op.create_table('visits',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('ip_address', sa.String(length=45), nullable=True),
        sa.Column('user_agent', sa.Text(), nullable=True),
        sa.Column('path', sa.String(length=255), nullable=False),
        sa.Column('created_at', sa.DateTime(), nullable=False),
        sa.PrimaryKeyConstraint('id')
    )

def downgrade():
    op.drop_table('visits')
    op.drop_table('anuncios')
    op.drop_table('event')
    op.drop_table('product')
    op.drop_table('product_category')
    op.drop_table('invitation_logs')
    op.drop_table('company_invites')
    op.drop_table('tasks')
    op.drop_table('assistants')
    op.drop_table('subscribers')
    op.drop_table('schedules')
    op.drop_table('medical_records')
    op.drop_table('appointments')
    op.drop_table('availability')
    op.drop_table('clinic')
    op.drop_table('publications')
    op.drop_table('notes')
    op.drop_table('user_roles')
    op.drop_table('users')


def downgrade():
    pass
