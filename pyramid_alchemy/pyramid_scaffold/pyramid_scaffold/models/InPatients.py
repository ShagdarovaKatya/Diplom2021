from sqlalchemy import (
    Index,
    Integer,
    Text,
    Sequence,
    ForeignKey,
    Boolean,
)

from sqlathanor import Column, AttributeConfiguration, relationship

from ..models import Rooms
from ..models import Physicians
from ..models import Patients
from ..models import Departments
from .meta import Base


class InPatients(Base):
    __tablename__ = 'InPatients'

    __serialization__ = [AttributeConfiguration(name='id',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='patientId',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='patient',
                                                supports_json=(False, True),
                                                supports_yaml=(False, True),
                                                supports_dict=(False, True),
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='departmentId',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='department',
                                                supports_csv=False,
                                                supports_json=(False, True),
                                                supports_yaml=(False, True),
                                                supports_dict=(False, True),
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='roomId',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='room',
                                                supports_csv=False,
                                                supports_json=(False, True),
                                                supports_yaml=(False, True),
                                                supports_dict=(False, True),
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='admission',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='orders',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='problems',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='physicianId',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='physician',
                                                supports_csv=False,
                                                supports_json=(False, True),
                                                supports_yaml=(False, True),
                                                supports_dict=(False, True),
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='discharged',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='status',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None)]

    id = Column(Integer, Sequence('InPatients_id_seq'),
                primary_key=True, autoincrement=True)
    patientId = Column(Integer, ForeignKey("Patients.id"), nullable=False)
    patient = relationship("Patients")
    departmentId = Column(Integer, ForeignKey("Departments.id"))
    department = relationship("Departments")
    roomId = Column(Integer, ForeignKey("Rooms.id"))
    room = relationship("Rooms")
    admission = Column(Text)
    orders = Column(Text)
    problems = Column(Text)
    physicianId = Column(Integer, ForeignKey("Physicians.id"))
    physician = relationship("Physicians")
    discharged = Column(Boolean)
    status = Column(Text)
