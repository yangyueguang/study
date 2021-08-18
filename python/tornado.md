## Tornado
```
import tornado.web
import tornado.ioloop
import tornado.httpserver
import tornado.options # 新导入的options模块
tornado.options.define("port", default=8000, type=int, help="run server on the given port.") # 定义服务器监听端口选项
tornado.options.define("itcast", default=[], type=str, multiple=True, help="itcast subjects.") # 无意义，演示多值情况
class IndexHandler(tornado.web.RequestHandler):
    """主路由处理类"""
    def get(self):
        """对应http的get请求方式"""
        self.write("Hello Itcast!")
if __name__ == "__main__":
    tornado.options.parse_command_line()
    print tornado.options.options.itcast # 输出多值选项
    app = tornado.web.Application([
        (r"/", IndexHandler),
    ])
    http_server = tornado.httpserver.HTTPServer(app)
    http_server.listen(tornado.options.options.port)
    tornado.ioloop.IOLoop.current().start()
执行如下命令开启程序：
$ python opt.py --port=9000 --itcast=python,c++,java,php,ios
```
