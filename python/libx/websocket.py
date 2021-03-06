# coding:utf-8
import re
import time
import socket
from multiprocessing import Process


def make_socket():
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind(("", 9090))
    server_socket.listen(128)
    client_socket, client_address = server_socket.accept()
    print("一个新客户端已经链接。。。。")
    date = client_socket.recv(1024)
    print("接收到的数据：", date.decode(encoding="utf-8"))
    client_socket.send("世界之巅".encode(encoding="utf-8"))
    client_socket.close()


def say_haha(env, start_response):
    return "hello haha"


class Application(object):
    def __init__(self, urls, static_dir="static"):
        self.urls = urls
        self.static_dir = static_dir

    def __call__(self, env, start_response):
        path = env.get("PATH_INFO", "/")
        if path.startswith("/static"):
            file_name = path[7:]
            file = open(self.static_dir + file_name, "rb")
            file_data = file.read()
            file.close()
            status = "200 OK"
            start_response(status, [])
            return file_data.decode("utf-8")
        for url, handler in self.urls:
            if path == url:
                return handler(env, start_response)
        return "not found"


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


class SocketServer():

    connections = []

    def __init__(self, addr):
        self.addr = addr

    def get_connection(self):
        sock = socket(AF_INET, SOCK_STREAM)
        sock.bind(self.addr)
        sock.listen(10)
        while True:
            conn, addr = sock.accept()
            Thread(target=self.on_open_before, args=(conn, addr)).start()

    def on_open_before(self, conn, addr):

        byte_msg_type = ""
        while True:
            byte_data = conn.recv(1024)
            byte_msg_type += byte_data.decode('utf8')
            if byte_msg_type.endswith('\n'):
                break
        msg = json.loads(byte_msg_type.replace('\r\n', ''))
        self.on_open(msg, conn, addr)

    def on_open(self, msg, conn, addr):
        pass
    def on_close(self):
        pass
    def start(self):
        Thread(target=self.get_connection , args=()).start()
        
        
if __name__ == "__main__":
    app = Application([("/", say_haha)], './html')
    http_server = HTTPServer(app)
    http_server.bind(8000)
    http_server.start()
    
    
### test
from socket import *
import json
ADDR = ("192.168.2.173", 8887)
sock = socket(AF_INET, SOCK_STREAM)
sock.connect(ADDR)
sock.send(json.dumps({"symbol": "audusd@FXALL"}).encode('utf-8'))
while True:
    res = sock.recv(1024)
    print(res, '#######33')

