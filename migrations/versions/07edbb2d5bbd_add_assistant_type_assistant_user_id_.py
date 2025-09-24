"""Add assistant.type (nullable), assistant.user_id, task.created_by

Revision ID: 07edbb2d5bbd
Revises: 3ef0c662e71a
Create Date: 2025-09-19 15:53:01.377419

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '07edbb2d5bbd'
down_revision = '3ef0c662e71a'
branch_labels = None
depends_on = None


def upgrade():
    # assistants
    with op.batch_alter_table('assistants', schema=None) as batch_op:
        batch_op.add_column(sa.Column('type', sa.String(length=20), nullable=True))
        batch_op.add_column(sa.Column('user_id', sa.Integer(), nullable=True))
        batch_op.create_index(batch_op.f('ix_assistants_user_id'), ['user_id'], unique=False)
        batch_op.create_foreign_key('fk_assistants_user_id', 'users', ['user_id'], ['id'])

    # tasks
    with op.batch_alter_table('tasks', schema=None) as batch_op:
        batch_op.add_column(sa.Column('created_by', sa.Integer(), nullable=True))
        batch_op.create_index(batch_op.f('ix_tasks_created_by'), ['created_by'], unique=False)
        batch_op.create_foreign_key('fk_tasks_created_by', 'users', ['created_by'], ['id'])


def downgrade():
    # tasks
    with op.batch_alter_table('tasks', schema=None) as batch_op:
        batch_op.drop_constraint('fk_tasks_created_by', type_='foreignkey')
        batch_op.drop_index(batch_op.f('ix_tasks_created_by'))
        batch_op.drop_column('created_by')

    # assistants
    with op.batch_alter_table('assistants', schema=None) as batch_op:
        batch_op.drop_constraint('fk_assistants_user_id', type_='foreignkey')
        batch_op.drop_index(batch_op.f('ix_assistants_user_id'))
        batch_op.drop_column('user_id')
        batch_op.drop_column('type')
