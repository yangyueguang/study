# coding: utf-8
import json
from flask import Blueprint
from flask import jsonify
from flask import request
from app.models import Model, Query
from flask.wrappers import Response
server = Blueprint("services", __name__)


def api(rule, methods=None, defaults=None, **kws):
    def wrapper(func):
        @server.route(rule, methods=methods or ['GET', 'POST'], defaults=defaults or {}, **kws)
        def action(**kwargs):
            res = func(request.body, **kwargs)
            if isinstance(res, Model) or isinstance(res, Query):
                res = res.json()
            if not isinstance(res, Response):
                res = {'code': 200, 'msg': 'OK', 'data': res}
            return res
        return action
    return wrapper


from . import service
