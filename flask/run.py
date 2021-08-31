# coding: utf-8
import os
import json
from flask import Flask, jsonify
from flask_cors import CORS
from tools import dlog, Dict
from app import server
from flask.wrappers import Request, Response
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "settings")
from django.core.wsgi import get_wsgi_application
get_wsgi_application()


class ApiFlask(Flask):
    def make_response(self, rv):
        if isinstance(rv, dict):
            if 'r' not in rv:
                rv['r'] = 0
            rv = ResponseMid(rv)
        if isinstance(rv, ResponseMid):
            return rv.to_response()
        return Flask.make_response(self, rv)


class Abort(Exception):
    def __init__(self, msg='', code=502):
        self.msg = msg
        self.code = code


class RequestMid(Request):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.body = Dict(self.json or self.form or self.args or self.get_json() or {})
        dlog(self.base_url)
        dlog(self.body)


class ResponseMid(Response):
    def __init__(self, response=None, status=None, headers=None, mimetype=None, **kwargs) -> None:
        dlog(response)
        super(ResponseMid, self).__init__(response, status, headers, mimetype, **kwargs)


def load_conf(app: Flask):
    app.debug = True
    app.config['ROOT_DIR'] = '.'
    app.config['BASE_DIR'] = '.'
    app.config['TZ'] = 'Asia/Shanghai'
    app.config["JWT_ACCESS_TOKEN_EXPIRES"] = 60 * 60 * 24
    app.config["JWT_REFRESH_TOKEN_EXPIRES"] = 30
    app.config["SSO_LOGIGN"] = True  # 是否支持单点登录
    app.config["SECRET_KEY"] = "secret$%^&*key!@#$%^774ST$%^&*(you#!!@%never!@#$%^&guess"
    app.config["JWT_SECRET_KEY"] = "secret$%^&*key!@#$%^774@@$%^&*(you#!!@%never!@#$%^&guess"
    app.request_class = RequestMid
    app.response_class = ResponseMid
    CORS(app)
    return app


def register_handlers(app):
    @app.errorhandler(500)
    def server_error_handler(e):
        return jsonify({'code': 500, 'message': str(e)}), 500

    @app.errorhandler(404)
    def not_found_handler(e):
        return jsonify({'code': 404, 'message': str(e)}), 404

    @app.errorhandler(Exception)
    def base_handler(e):
        return jsonify({'code': 501, 'message': str(e)}), 501

    @app.errorhandler(Abort)
    def no_auth_response(error: Abort):
        return jsonify({'code': error.code, 'message': error.msg}), error.code

    @app.before_first_request
    def first_request():
        dlog('首次调用')

    @app.before_request
    def jwt_auth():
        ...
        # try:
            # verify_jwt_in_request()
            # identifier = get_jwt_identity()
            # print(identifier)
        # except Exception as e:
        #     print('error')

    @app.after_request
    def after_req(response):
        response.headers.add('Access-Control-Allow-Origin', '*')
        response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
        response.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE')
        return response

    @app.teardown_request
    def request_over(exec):
        print(exec)


def register_endpoints(flask_app):
    flask_app.register_blueprint(server, url_prefix='/api')


def create_app():
    app = ApiFlask(__name__, template_folder='data/template', static_folder="data/static", static_url_path='/static')
    load_conf(app)
    register_handlers(app)
    register_endpoints(app)
    return app


app = create_app()


if __name__ == '__main__':
    app.run(port=8000, debug=True)


