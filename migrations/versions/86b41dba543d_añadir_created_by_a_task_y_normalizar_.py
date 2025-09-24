"""Añadir created_by a Task y normalizar clinic_id en Assistant

Revision ID: 86b41dba543d
Revises: df3c70bc952a
Create Date: 2025-09-21 17:42:55.444948

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '86b41dba543d'
down_revision = 'df3c70bc952a'
branch_labels = None
depends_on = None


def upgrade():
    with op.batch_alter_table('assistants', schema=None) as batch_op:
        batch_op.add_column(sa.Column('created_by_user_id', sa.Integer(), nullable=True))
        # ✅ Nombre explícito para la FK
        batch_op.create_foreign_key(
            'fk_assistants_created_by_user_id',  # Nombre único
            'users', 
            ['created_by_user_id'], 
            ['id']
        )

def downgrade():
    with op.batch_alter_table('assistants', schema=None) as batch_op:
        # ✅ Eliminar con el nombre correcto
        batch_op.drop_constraint('fk_assistants_created_by_user_id', type_='foreignkey')
        batch_op.drop_column('created_by_user_id')