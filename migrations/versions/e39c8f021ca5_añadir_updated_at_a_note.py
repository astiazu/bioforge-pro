"""Añadir updated_at a Note

Revision ID: e39c8f021ca5
Revises: 57932ebef702
Create Date: 2025-04-05 00:00:00.000000

"""
from alembic import op
import sqlalchemy as sa

# revision identifiers
revision = 'e39c8f021ca5'
down_revision = '57932ebef702'
branch_labels = None
depends_on = None

def upgrade():
    # === Añadir updated_at como nullable primero ===
    with op.batch_alter_table('notes', schema=None) as batch_op:
        batch_op.add_column(sa.Column('updated_at', sa.DateTime(), nullable=True))

    # === Rellenar valores NULL con created_at ===
    op.execute("UPDATE notes SET updated_at = created_at WHERE updated_at IS NULL")

    # === Hacer updated_at NOT NULL (fuera de batch) ===
    with op.batch_alter_table('notes', schema=None) as batch_op:
        batch_op.alter_column('updated_at', nullable=False, existing_type=sa.DateTime(), existing_nullable=True)

    # ✅ No se toca users → evitamos el error de constraint


def downgrade():
    # Revertir en orden inverso
    with op.batch_alter_table('notes', schema=None) as batch_op:
        batch_op.drop_column('updated_at')