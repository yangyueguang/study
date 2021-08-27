from . import api, server
from app.models import LogModel


@server.route('/list', methods=['GET'])
def get_list():
    return {'list': 'OK'}


# 自定义
@api('/index', methods=['GET', 'POST'])
def get_something(body):
    ds = LogModel(server='dd', message='ddddssss')
    ds.save()
    res = LogModel.query
    return res

