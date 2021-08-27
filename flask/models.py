# coding: utf-8
import datetime
from flask_sqlalchemy import SQLAlchemy, BaseQuery


class Query(BaseQuery):
    def __init__(self, entities, session=None):
        super(Query, self).__init__(entities, session)

    def all(self):
        return super().all()

    def json(self):
        return [i.json() for i in self]


db = SQLAlchemy(query_class=Query)


class Model(db.Model):
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


# 模型文件
class LogModel(Model):
    __tablename__ = 'logs'
    __table_args__ = ({"comment": "日志表"}, )
    type = db.Column(db.INTEGER, default=0)
    server = db.Column(db.String(255), nullable=False)
    code = db.Column(db.INTEGER, nullable=False, default=500)
    message = db.Column(db.String(255))
    statistics = db.Column(db.JSON, default={}, doc='统计信息')
