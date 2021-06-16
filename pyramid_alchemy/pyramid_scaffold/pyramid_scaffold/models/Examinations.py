from ..models import Patients, Physicians
from sqlalchemy import (
    Index,
    Integer,
    Text,
    Sequence,
    ForeignKey,
    DateTime,
    Boolean,
)

from sqlathanor import Column, AttributeConfiguration, relationship

from .meta import Base


class Examinations(Base):
    __tablename__ = 'Examinations'

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
                                                supports_json=(True, False),
                                                supports_yaml=(True, True),
                                                supports_dict=(True),
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='examinationDate',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='name',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='contents',
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
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='comments',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='tags',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='deleted',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None)]

    id = Column(Integer, Sequence('Examinations_id_seq'), primary_key=True, autoincrement=True)
    patientId = Column(Integer, ForeignKey("Patients.id"), nullable=False)
    patient = relationship("Patients",
                           backref = 'Examinations')
    examinationDate = Column(DateTime, nullable=False)
    name = Column(Text)
    contents = Column(Text)
    physicianId = Column(Integer, ForeignKey("Physicians.id"))
    physician = relationship("Physicians")
    comments = Column(Text)
    tags = Column(Text)
    deleted = Column(Boolean)
