# coding=utf-8
import logging
import colorama
import threading
import logging.handlers
LOG_PATH = 'root.log'
IS_DEBUG = True


class LogFormatter(logging.Formatter):
    def __init__(self):
        logging.Formatter.__init__(self, fmt='%(message)s', datefmt='%Y-%m-%d %H:%M:%S')

    def format(self, record):
        fmt = '\r%(color)s[%(asctime)s %(module)s.%(funcName)s:%(lineno)d]%(end_color)s %(message)s'
        color_config = {
            logging.DEBUG: colorama.Fore.BLUE,
            logging.INFO: colorama.Fore.GREEN,
            logging.WARNING: colorama.Fore.YELLOW,
            logging.ERROR: colorama.Fore.RED
        }
        message = record.getMessage()
        fmt = f'\r{fmt}' if message.startswith('\r') else f'{fmt}\n'
        record.message = message.strip('\r')
        record.asctime = self.formatTime(record, self.datefmt)
        record.color = color_config.get(record.levelno, colorama.Fore.GREEN)
        record.end_color = colorama.Fore.LIGHTGREEN_EX
        formatted = fmt % record.__dict__
        if record.exc_info and not record.exc_text:
            record.exc_text = self.formatException(record.exc_info)
        if record.exc_text:
            formatted += record.exc_text
        return formatted


class Dlog(logging.RootLogger):
    _instance_lock = threading.Lock()
    _instance = None

    def __new__(cls, *args, **kwargs):
        if not Dlog._instance:
            with Dlog._instance_lock:
                handler = logging.handlers.TimedRotatingFileHandler(filename=LOG_PATH, when="D", backupCount=100)
                handler.suffix = "%Y-%m-%d.log"
                fmt = LogFormatter()
                handler.setFormatter(fmt)
                handler.terminator = ''
                log = logging.getLogger()
                log.setLevel(logging.INFO)
                log.addHandler(handler)
                if IS_DEBUG:
                    console = logging.StreamHandler()
                    console.setFormatter(fmt)
                    console.terminator = ''
                    log.addHandler(console)
                Dlog._instance = log
        return Dlog._instance


logger_obj = Dlog()


def dlog_percent(message, percent=1, *args, **kwargs):
    a = int(min(percent, 1) * 100)
    message = f"\r[{'=' * a}>{'.' * (100 - a)}] {str(a)}% {message}"
    logger_obj.info(message, *args, **kwargs)


def dlog(message, is_error=False, *args, **kwargs):
    if is_error:
        logger_obj.error(message, *args, **kwargs)
    else:
        logger_obj.info(message, *args, **kwargs)

