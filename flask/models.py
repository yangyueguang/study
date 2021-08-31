# coding: utf-8
# flask 框架推荐的orm，弃用，采用django的orm
import datetime
from sqlalchemy import Column, DateTime
from flask_sqlalchemy import SQLAlchemy, BaseQuery, Model


class BaseModel(Model):
    create_at = Column(DateTime, default=datetime.datetime.now)

    def to_dict(self):
        columns = self.__table__.columns.keys()
        return {key: getattr(self, key) for key in columns}


class Query(BaseQuery):
    def __init__(self, entities, session=None):
        super(Query, self).__init__(entities, session)

    def all(self):
        return super().all()

    def json(self):
        return [i.json() for i in self]


db = SQLAlchemy(query_class=Query, model_class=BaseModel)


class BaseMixin(object):
    @classmethod
    def create(cls, **kw):
        session = db.session
        if 'id' in kw:
            obj = session.query(cls).get(kw['id'])
            if obj:
                return obj
        obj = cls(**kw)
        session.add(obj)
        session.commit()
        return obj

    def __eq__(self, other):
        return getattr(self, 'id') == getattr(other, 'id')


class Model(BaseMixin, db.Model):
    __abstract__ = True
    id = db.Column(db.INTEGER, autoincrement=True, primary_key=True)
    active = db.Column(db.BOOLEAN, default=True, nullable=False)
    ct = db.Column(db.DateTime, default=datetime.datetime.now, comment="修改时间")
    ut = db.Column(db.DateTime, default=datetime.datetime.now, onupdate=datetime.datetime.now, comment="最近修改时间", index=True)

    def save(self):
        db.session.add(self)
        try:
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            print(e)

    def json(self):
        res = {}
        for key in self.__table__.c.keys():
            i = getattr(self, key)
            i = i.strftime("%Y-%m-%d %H:%M:%S") if isinstance(i, datetime.datetime) else i
            res[key] = i
        return res


# app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:12345678@127.0.0.1:3306/super'
# app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = True
# db.init_app(app)


# 模型文件
class LogModel(Model):
    __tablename__ = 'logs'
    __table_args__ = ({"comment": "日志表"}, )
    type = db.Column(db.INTEGER, default=0)
    server = db.Column(db.String(255), nullable=False)
    code = db.Column(db.INTEGER, nullable=False, default=500)
    message = db.Column(db.String(255))
    statistics = db.Column(db.JSON, default={}, doc='统计信息')


