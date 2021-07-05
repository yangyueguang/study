# coding:utf-8
import re
import time
import socket
from multiprocessing import Process


class Application(object):
    def __init__(self, urls, static_dir="static"):
        self.urls = urls
        self.static_dir = static_dir

    def __call__(self, env, start_response):
        path = env.get("PATH_INFO", "/")
        if path.startswith("/static"):
            file_name = path[7:]
            try:
                file = open(self.static_dir + file_name, "rb")
            except IOError:
                status = "404 Not Found"
                headers = []
                start_response(status, headers)
                return "not found"
            else:
                file_data = file.read()
                file.close()
                status = "200 OK"
                headers = []
                start_response(status, headers)
                return file_data.decode("utf-8")

        for url, handler in self.urls:
            if path == url:
                return handler(env, start_response)
        status = "404 Not Found"
        headers = []
        start_response(status, headers)
        return "not found"


def show_ctime(env, start_response):
    status = "200 OK"
    headers = [
        ("Content-Type", "text/plain")
    ]
    start_response(status, headers)
    return time.ctime()


def say_hello(env, start_response):
    status = "200 OK"
    headers = [
        ("Content-Type", "text/plain")
    ]
    start_response(status, headers)
    return "hello itcast"

def say_haha(env, start_response):
    status = "200 OK"
    headers = [
        ("Content-Type", "text/plain")
    ]
    start_response(status, headers)
    return "hello haha"

class HTTPServer(object):
    def __init__(self, application):
        self.server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.app = application

    def start(self):
        self.server_socket.listen(128)
        while True:
            client_socket, client_address = self.server_socket.accept()
            print("[%s, %s]用户连接上了" % client_address)
            handle_client_process = Process(target=self.handle_client, args=(client_socket,))
            handle_client_process.start()
            client_socket.close()

    def start_response(self, status, headers):
        response_headers = "HTTP/1.1 " + status + "\r\n"
        for header in headers:
            response_headers += "%s: %s\r\n" % header
        self.response_headers = response_headers

    def handle_client(self, client_socket):
        request_data = client_socket.recv(1024)
        print("request data:", request_data)
        request_lines = request_data.splitlines()
        for line in request_lines:
            print(line)
        request_start_line = request_lines[0]
        print("*" * 10)
        print(request_start_line.decode("utf-8"))
        file_name = re.match(r"\w+ +(/[^ ]*) ", request_start_line.decode("utf-8")).group(1)
        method = re.match(r"(\w+) +/[^ ]* ", request_start_line.decode("utf-8")).group(1)
        env = {
            "PATH_INFO": file_name,
            "METHOD": method
        }
        response_body = self.app(env, self.start_response)
        response = self.response_headers + "\r\n" + response_body
        client_socket.send(bytes(response, "utf-8"))
        client_socket.close()

    def bind(self, port):
        self.server_socket.bind(("", port))


def main():
    urls = [
            ("/", show_ctime),
            ("/ctime", show_ctime),
            ("/sayhello", say_hello),
            ("/sayhaha", say_haha),
        ]
    app = Application(urls, './html')
    http_server = HTTPServer(app)
    http_server.bind(8000)
    http_server.start()


if __name__ == "__main__":
    main()


