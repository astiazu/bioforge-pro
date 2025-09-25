"""add whatsapp to company_invites

Revision ID: df3c70bc952a
Revises: 
Create Date: 2025-09-24 20:00:00.000000

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.engine import reflection

# ✅ VARIABLES OBLIGATORIAS PARA ALEMBIC
revision = 'df3c70bc952a'
down_revision = None
branch_labels = None
depends_on = None

def column_exists(table, column):
    conn = op.get_bind()
    inspector = reflection.Inspector.from_engine(conn)
    cols = inspector.get_columns(table)
    return column in [col['name'] for col in cols]

def upgrade():
    if not column_exists('company_invites', 'whatsapp'):
        with op.batch_alter_table('company_invites', schema=None) as batch_op:
            batch_op.add_column(sa.Column('whatsapp', sa.String(length=20), nullable=True))

def downgrade():
    with op.batch_alter_table('company_invites', schema=None) as batch_op:
        batch_op.drop_column('whatsapp')