from sqlalchemy import (
    Index,
    Integer,
    Text,
    Sequence,
    Enum,
    Date,
    Boolean,
)

from sqlathanor import Column, AttributeConfiguration, relationship

import enum

from .meta import Base
from ..models import Examinations


class GenderEnum(str, enum.Enum):
    male = 'MALE'
    female = 'FEMALE'


class Patients(Base):
    __tablename__ = 'Patients'

    __serialization__ = [AttributeConfiguration(name='id',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='family',
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
                         AttributeConfiguration(name='thirdName',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='gender',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='birthdate',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='address',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='phone',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='diagnosos',
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
                         AttributeConfiguration(name='comments',
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

    id = Column(Integer, Sequence("Patients_id_seq"), primary_key=True, autoincrement=True)
    family = Column(Text, nullable=False)
    name = Column(Text, nullable=False)
    thirdName = Column(Text)
    gender = Column('value', Enum(GenderEnum), nullable=False)
    birthdate = Column(Date, nullable=False)
    address = Column(Text)
    phone = Column(Text)
    diagnosos = Column(Text)
    tags = Column(Text)
    comments = Column(Text)
    # patient = relationship('Examinations')
    deleted = Column(Boolean)
