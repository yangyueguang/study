import traceback
import threading
import logging
import json
import datetime
import logging.handlers
import colorama
from logging import RootLogger
from requests.sessions import Session
from concurrent.futures import ThreadPoolExecutor


class SingletonType(type):
    _instance_lock = threading.Lock()

    def __call__(cls, *args, **kwargs):
        if not hasattr(cls, "_instance"):
            with SingletonType._instance_lock:
                cls._instance = super(SingletonType, cls).__call__(*args, **kwargs)
        return cls._instance


# demo
# class Foo(metaclass=SingletonType):
#     def __init__(self, name):
#         self.name = name


class Dict(dict):
    def __init__(self, sdict=None):
        super(dict, self).__init__()
        if sdict is not None:
            for sk, sv in sdict.items():
                if isinstance(sv, dict):
                    self[sk] = Dict(sv)
                else:
                    self[sk] = sv

    def __getattr__(self, name):
        try:
            return None if name not in self else self[name]
        except KeyError:
            return None


def request(method, url, params=None, data=None, retry=1, message="", timeout=60 * 10, **kwargs):
    dlog(f'start request: {url}')
    dlog(params)
    res = None
    while retry > 0:
        try:
            with Session() as session:
                res = session.request(method=method, url=url, params=params, data=data, timeout=timeout, **kwargs)
            if res.status_code == 200:
                break
        except Exception as e:
            dlog(e, True)
            dlog(traceback.format_exc(), True)
        finally:
            retry += 1
    if res and res.status_code == 200:
        dlog(res.json())
    else:
        dlog(message, True)
    return res


def get(url, params, **kwargs):
    url += '&'.join([f'{k}={v}' for k, v in params]) if params else ''
    return request('GET', url, **kwargs)


def post(url, data=None, **kwargs):
    return request('POST', url, data=data, **kwargs)


def request_all(method, url, param_list, thread=5, **kwargs):
    with ThreadPoolExecutor(thread) as executor:
        for p in param_list:
            executor.submit(request, method, url, p, **kwargs)


# Response(json.dumps(self.value, cls=DateTimeEncoder),
class DateTimeEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, datetime.datetime):
            return o.isoformat()
        elif isinstance(o, bytes):
            return o.decode('utf-8')
        return json.JSONEncoder.default(self, o)


class LogFormatter(logging.Formatter):
    def __init__(self):
        logging.Formatter.__init__(self, fmt='%(message)s', datefmt='%Y-%m-%d %H:%M:%S')

    def format(self, record):
        fmt = '%(color)s[%(asctime)s %(module)s.%(funcName)s:%(lineno)d]%(end_color)s %(message)s'
        color_config = {
            logging.DEBUG: colorama.Fore.BLUE,
            logging.INFO: colorama.Fore.GREEN,
            logging.WARNING: colorama.Fore.YELLOW,
            logging.ERROR: colorama.Fore.RED
        }
        record.message = record.getMessage()
        record.asctime = self.formatTime(record, self.datefmt)
        record.color = color_config.get(record.levelno, colorama.Fore.GREEN)
        record.end_color = colorama.Fore.LIGHTGREEN_EX
        formatted = fmt % record.__dict__
        if record.exc_info and not record.exc_text:
            record.exc_text = self.formatException(record.exc_info)
        if record.exc_text:
            formatted += record.exc_text
        return formatted


class Dlog(RootLogger):
    _instance_lock = threading.Lock()
    _instance = None

    def __new__(cls, *args, **kwargs):
        if not Dlog._instance:
            with Dlog._instance_lock:
                handler = logging.handlers.TimedRotatingFileHandler(filename='data/root.log', when="D", backupCount=100)
                handler.suffix = "%Y-%m-%d.log"
                fmt = LogFormatter()
                handler.setFormatter(fmt)
                log = logging.getLogger()
                log.setLevel(logging.INFO)
                log.addHandler(handler)
                if True:
                    console = logging.StreamHandler()
                    console.setFormatter(fmt)
                    log.addHandler(console)
                Dlog._instance = log
        return Dlog._instance


logger_obj = Dlog()


def dlog(message, is_error=False, *args, **kwargs):
    if is_error:
        logger_obj.error(message, *args, **kwargs)
    else:
        logger_obj.info(message, *args, **kwargs)

