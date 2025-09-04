"""Añadir featured_image y view_count a Note

Revision ID: 57932ebef702
Revises: 726564f160df
Create Date: 2025-04-05 00:00:00.000000

"""
from alembic import op
import sqlalchemy as sa

# revision identifiers
revision = '57932ebef702'
down_revision = '726564f160df'
branch_labels = None
depends_on = None

def upgrade():
    # === Paso 1: Añadir featured_image (nullable primero) ===
    with op.batch_alter_table('notes', schema=None) as batch_op:
        batch_op.add_column(sa.Column('featured_image', sa.String(200), nullable=True))

    # === Paso 2: Añadir view_count como nullable ===
    with op.batch_alter_table('notes', schema=None) as batch_op:
        batch_op.add_column(sa.Column('view_count', sa.Integer(), nullable=True))

    # === Paso 3: Rellenar valores NULL con 0 ===
    op.execute("UPDATE notes SET view_count = 0 WHERE view_count IS NULL")

    # === Paso 4: Hacer view_count NOT NULL (fuera de batch) ===
    # SQLite no permite cambiar nullable en batch si hay datos, así que usamos ALTER TABLE
    # Pero como ya llenamos con 0, ahora sí podemos
    with op.batch_alter_table('notes', schema=None) as batch_op:
        batch_op.alter_column('view_count', nullable=False, existing_type=sa.Integer(), existing_nullable=True)

    # ✅ No se toca la tabla users → evitamos el error de constraint


def downgrade():
    # Revertir en orden inverso
    with op.batch_alter_table('notes', schema=None) as batch_op:
        batch_op.drop_column('view_count')
        batch_op.drop_column('featured_image')