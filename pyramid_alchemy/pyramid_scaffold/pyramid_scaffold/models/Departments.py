from sqlalchemy import (
    Index,
    Integer,
    Text,
    Sequence,
)

from .meta import Base

from sqlathanor import Column, AttributeConfiguration, relationship


class Departments(Base):
    __tablename__ = 'Departments'

    __serialization__ = [AttributeConfiguration(name='id',
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
                         AttributeConfiguration(name='rooms',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=(False, True),
                                                on_serialize=None,
                                                on_deserialize=None)]

    id = Column(Integer, Sequence('Departments_id_seq'),
                primary_key=True, autoincrement=True)
    name = Column(Text, nullable=False)
    rooms = relationship('Rooms', back_populates="department")
