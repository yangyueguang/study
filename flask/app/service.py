from . import api, server
from .models import User


@server.route('/list', methods=['GET'])
def get_list():
    return {'list': 'OK'}


# 自定义
@api('/index', methods=['GET', 'POST'])
def get_something(body):
    user = User(name="super", phone="188")
    user.save()
    return {'data': [(i.name, i.phone) for i in User.objects.all()]}
