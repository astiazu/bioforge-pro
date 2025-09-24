"""Set default value for assistants.type and make it NOT NULL

Revision ID: xxxxxxxx
Revises: 07edbb2d5bbd
Create Date: 2025-09-19
"""
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = 'xxxxxxxx'
down_revision = '07edbb2d5bbd'
branch_labels = None
depends_on = None


def upgrade():
    # Paso 1: asegurarnos que todos los registros tienen un valor
    op.execute("UPDATE assistants SET type='general' WHERE type IS NULL;")

    # Paso 2: modificar la columna para que sea NOT NULL con default
    with op.batch_alter_table("assistants", schema=None) as batch_op:
        batch_op.alter_column(
            "type",
            existing_type=sa.String(length=20),
            nullable=False,
            server_default="general"
        )


def downgrade():
    with op.batch_alter_table("assistants", schema=None) as batch_op:
        batch_op.alter_column(
            "type",
            existing_type=sa.String(length=20),
            nullable=True,
            server_default=None
        )