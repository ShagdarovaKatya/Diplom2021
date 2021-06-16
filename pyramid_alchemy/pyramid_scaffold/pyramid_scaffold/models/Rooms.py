from sqlalchemy import (
    Index,
    Integer,
    Text,
    Sequence,
    ForeignKey,
)


from ..models import Departments
from .meta import Base

from sqlathanor import Column, AttributeConfiguration, relationship


class Rooms(Base):
    __tablename__ = 'Rooms'

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
                         AttributeConfiguration(name='department',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=False,
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='departmentId',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None)]

    id = Column(Integer, Sequence('Rooms_id_seq'),
                primary_key=True, autoincrement=True)
    name = Column(Text, nullable=False)
    departmentId = Column(Integer, ForeignKey("Departments.id"))
    department = relationship("Departments", back_populates="rooms")
