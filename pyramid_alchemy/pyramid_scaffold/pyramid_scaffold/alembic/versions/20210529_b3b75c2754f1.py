"""initial commit

Revision ID: b3b75c2754f1
Revises: 
Create Date: 2021-05-29 22:30:01.737962

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'b3b75c2754f1'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('InPatients',
    sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
    sa.Column('patientId', sa.Integer(), nullable=False),
    sa.Column('patient', sa.Integer(), nullable=True),
    sa.Column('departmentId', sa.Integer(), nullable=True),
    sa.Column('roomId', sa.Integer(), nullable=True),
    sa.Column('admission', sa.Text(), nullable=True),
    sa.Column('orders', sa.Text(), nullable=True),
    sa.Column('problems', sa.Text(), nullable=True),
    sa.Column('physicianId', sa.Integer(), nullable=True),
    sa.Column('discharged', sa.Boolean(), nullable=True),
    sa.Column('status', sa.Text(), nullable=True),
    sa.ForeignKeyConstraint(['departmentId'], ['Departments.id'], name=op.f('fk_InPatients_departmentId_Departments')),
    sa.ForeignKeyConstraint(['patient'], ['Patients.id'], name=op.f('fk_InPatients_patient_Patients')),
    sa.ForeignKeyConstraint(['patientId'], ['Patients.id'], name=op.f('fk_InPatients_patientId_Patients')),
    sa.ForeignKeyConstraint(['physicianId'], ['Physicians.id'], name=op.f('fk_InPatients_physicianId_Physicians')),
    sa.ForeignKeyConstraint(['roomId'], ['Rooms.id'], name=op.f('fk_InPatients_roomId_Rooms')),
    sa.PrimaryKeyConstraint('id', name=op.f('pk_InPatients'))
    )
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('InPatients')
    # ### end Alembic commands ###
