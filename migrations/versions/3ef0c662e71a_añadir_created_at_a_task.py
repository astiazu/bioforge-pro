"""Añadir created_at a Task

Revision ID: 3ef0c662e71a
Revises: 471259db0e38
Create Date: 2025-09-17 00:07:09.544571

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '3ef0c662e71a'
down_revision = '471259db0e38'
branch_labels = None
depends_on = None


def upgrade():
    # Primero: añadir la columna como nullable=True
    with op.batch_alter_table('tasks', schema=None) as batch_op:
        batch_op.add_column(sa.Column('created_at', sa.DateTime(), nullable=True))

    # Segundo: llenar la columna con valores por defecto
    op.execute("UPDATE tasks SET created_at = datetime('2025-09-01') WHERE created_at IS NULL")

    # Tercero: cambiar a NOT NULL
    with op.batch_alter_table('tasks', schema=None) as batch_op:
        batch_op.alter_column('created_at', existing_type=sa.DateTime(), nullable=False)
        
    # ### end Alembic commands ###
