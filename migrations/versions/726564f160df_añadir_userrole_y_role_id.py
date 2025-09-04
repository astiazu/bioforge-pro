"""Añadir UserRole y role_id

Revision ID: 726564f160df
Revises: 
Create Date: 2025-04-05 00:00:00.000000

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import sqlite

# revision identifiers
revision = '726564f160df'
down_revision = None
branch_labels = None
depends_on = None

def upgrade():
    # 1. Verificar si la tabla user_roles ya existe
    conn = op.get_bind()
    inspector = sa.inspect(conn)
    tables = inspector.get_table_names()

    if 'user_roles' not in tables:
        # Crear tabla user_roles solo si no existe
        op.create_table('user_roles',
            sa.Column('id', sa.Integer(), nullable=False),
            sa.Column('name', sa.String(50), nullable=False),
            sa.Column('description', sa.Text(), nullable=True),
            sa.Column('is_active', sa.Boolean(), nullable=True),
            sa.Column('created_at', sa.DateTime(), nullable=True),
            sa.PrimaryKeyConstraint('id'),
            sa.UniqueConstraint('name')
        )

    # 2. Añadir columna role_id a users (sin FK primero)
    with op.batch_alter_table('users', schema=None) as batch_op:
        batch_op.add_column(sa.Column('role_id', sa.Integer(), nullable=True))

    # 3. Crear FK con nombre explícito
    op.create_foreign_key(
        constraint_name='fk_users_role_id',
        source_table='users',
        referent_table='user_roles',
        local_cols=['role_id'],
        remote_cols=['id'],
        ondelete='SET NULL'
    )

def downgrade():
    # 1. Eliminar FK
    op.drop_constraint('fk_users_role_id', 'users', type_='foreignkey')
    
    # 2. Eliminar columna role_id
    with op.batch_alter_table('users', schema=None) as batch_op:
        batch_op.drop_column('role_id')
    
    # 3. Eliminar tabla user_roles
    op.drop_table('user_roles')
