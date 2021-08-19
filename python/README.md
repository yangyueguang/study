# PythonLib
1. [pywin32](https://github.com/mhammond/pywin32) Python for Windows (pywin32) Extensions
2. [xlwings](https://github.com/xlwings/xlwings) Excel Python 项目调用
3. [python-docx](https://github.com/python-openxml/python-docx) 处理docx文件
4. [python-pptx](https://github.com/scanny/python-pptx) 处理pptx文件
5. [pdfminer](https://github.com/euske/pdfminer) 从pdf中抽取文本
6. [textract](https://github.com/deanmalmgren/textract) 从任意文件中抽取文本 text = textract.process("path/to/file.extension")
7. [pyecharts](https://github.com/pyecharts/pyecharts) 绘图数据分析
8. [pygal](https://github.com/Kozea/pygal)[使用说明](http://www.pygal.org/en/stable/documentation/index.html) 绘图数据分析
4. [schedule](https://github.com/dbader/schedule) python的定时执行。
7. [jieba](https://github.com/fxsjy/jieba) 中文分词组件
8. [unp](https://github.com/mitsuhiko/unp) 解压缩所有文件
9. [pypinyin](https://github.com/mozillazg/python-pinyin) 汉字拼音转换工具
10. [python-box](https://github.com/cdgriffith/Box) 把字典转换成可以用点语法调用的方式。
11. [pywebview](https://github.com/r0x0r/pywebview/) [使用说明](https://pywebview.flowrl.com/examples/) 用python构建web界面。
12. [wechatpy](https://github.com/wechatpy/wechatpy)微信开发包

```python
import asyncio
loop = asyncio.get_event_loop()
async def do_find_one():
    pass
loop.run_until_complete(do_find_one())
```


```bash
rabbitmq:
    image: rabbitmq:management
    container_name: myrabbitmq
    hostname: myrabbitmq
    restart: always
    ports:
      - 5672:5672
      - 15672:15672
    volumes:
      - /var/docker/rabbitmq/data:/var/lib/rabbitmq
    environment:
      - RABBITMQ_DEFAULT_USER=admin
      - RABBITMQ_DEFAULT_PASS=123456
 ```

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



## 1. 制作镜像
### install paddle
```shell
# paddle默认从~/.paddleocr/内寻找模型
FROM python:3.8
#paddlepaddle/paddle:latest
#paddlepaddle/paddle:latest-gpu-cuda11.0-cudnn8
MAINTAINER Super
USER root
ENV PATH=$PATH:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ADD app /app
WORKDIR /app
ENV data_det https://paddleocr.bj.bcebos.com/20-09-22/server/det/ch_ppocr_server_v1.1_det_infer.tar
#            https://paddleocr.bj.bcebos.com/20-09-22/mobile/det/ch_ppocr_mobile_v1.1_det_infer.tar
ENV data_cls https://paddleocr.bj.bcebos.com/20-09-22/cls/ch_ppocr_mobile_v1.1_cls_infer.tar
#            https://paddleocr.bj.bcebos.com/20-09-22/cls/ch_ppocr_mobile_v1.1_cls_infer.tar
ENV data_rec https://paddleocr.bj.bcebos.com/20-09-22/server/rec/ch_ppocr_server_v1.1_rec_infer.tar
#            https://paddleocr.bj.bcebos.com/20-09-22/mobile/rec/ch_ppocr_mobile_v1.1_rec_infer.tar
ADD ${data_det} .
ADD ${data_cls} .
ADD ${data_rec} .
RUN mkdir -p ~/.paddleocr/rec
RUN tar xf ${data_det##*/} && echo ${data_det##*/}|sed "s/.tar//g"|xargs -I {} mv {} ~/.paddleocr/det
RUN tar xf ${data_cls##*/} && echo ${data_cls##*/}|sed "s/.tar//g"|xargs -I {} mv {} ~/.paddleocr/cls
RUN tar xf ${data_rec##*/} && echo ${data_rec##*/}|sed "s/.tar//g"|xargs -I {} mv {} ~/.paddleocr/rec/ch
RUN rm -f ${data_det##*/} ${data_cls##*/} ${data_rec##*/}
RUN pip3 install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com --upgrade pip
RUN ln -s /usr/bin/pip3 /usr/bin/pip
RUN pip install Cython --install-option="--no-cython-compile" --ignore-installed --no-deps
RUN pip install -r require.txt
RUN pip install paddlepaddle -i https://mirror.baidu.com/pypi/simple
RUN pip install paddlehub --upgrade -i https://pypi.tuna.tsinghua.edu.cn/simple
EXPOSE 8866
CMD ["/bin/bash","-c","hub install deploy/hubserving/ocr_system/ && hub serving start -m ocr_system"]
```
```shell
#上传pip：必须用setup的名
python3 setup.py sdist upload
twine upload dist/*
# 打包为so
python3 pack.py
```

## 2.启动Docker容器
1. CPU 版本 `sudo docker run -dp 8866:8866 --name paddle_ocr paddleocr:cpu`
2. GPU 版本 `sudo nvidia-docker run -dp 8866:8866 --name paddle_ocr paddleocr:gpu`
3. GPU 版本 (Docker 19.03以上版本)`sudo docker run -dp 8866:8866 --gpus all --name paddle_ocr paddleocr:gpu`
4. 检查服务运行情况 `docker logs -f paddle_ocr`
5. 接口测试 `curl -H "Content-Type:application/json" -X POST --data "{\"images\": [\"填入图片Base64编码(需要删除'data:image/jpg;base64,'）\"]}" http://localhost:8866/predict/ocr_system`

## 3. 项目依赖
```text
shapely
imgaug
pyclipper
lmdb
tqdm
numpy
opencv-python==4.2.0.32
gevent==20.9.0
bottle==0.12.19
click==7.1.2
psutil==5.7.3
python-docx
paddlepaddle
paddleocr
```

## 4. 接口调用
```python
import requests
import base64
import cv2
import json
data = cv2.imencode('.jpg', cv2.imread('abc.pdf'))[1]
img = base64.b64encode(data.tostring()).decode('utf8')
url = "http://127.0.0.1:8866/predict/ocr_system"
r = requests.post(url=url, headers={"Content-type": "application/json"}, data=json.dumps({'images': [img]}))
print(r.json()["results"])
```
## 4.发布代码
MANIFEST.in里面写的代码是为了能上传所有文件类型到pypi
修改setup.py里面的版本号，然后执行produce.sh即可
