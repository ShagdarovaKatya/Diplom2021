from sqlalchemy import (
    Index,
    Integer,
    Text,
    Sequence,
)

from sqlathanor import Column, AttributeConfiguration

from .meta import Base


class Configs(Base):
    __tablename__ = 'Configs'

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
                         AttributeConfiguration(name='value',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None)]

    id = Column(Integer, Sequence('Configs_id_seq'),
                primary_key=True, autoincrement=True)
    name = Column(Text, nullable=False)
    value = Column(Text)
