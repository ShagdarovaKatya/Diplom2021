from sqlalchemy import (
    Index,
    Integer,
    Text,
    Sequence,
)

from sqlathanor import Column, AttributeConfiguration

from .meta import Base


class Templates(Base):
    __tablename__ = 'Templates'

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
                         AttributeConfiguration(name='content',
                                                supports_csv=False,
                                                supports_json=True,
                                                supports_yaml=True,
                                                supports_dict=True,
                                                on_serialize=None,
                                                on_deserialize=None),
                         AttributeConfiguration(name='html',
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
                                                on_deserialize=None)]

    id = Column(Integer, Sequence('Templates_id_seq'), primary_key=True, autoincrement=True)
    name = Column(Text, nullable=False)
    content = Column(Text)
    html = Column(Text)
    comments = Column(Text)
