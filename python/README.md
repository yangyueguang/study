# PythonLib
## 常用库的使用方法
### 自有库
1. xdict 把字典转换成可以用点语法调用的方式。
### 网络与爬虫框架
1. Django
2. Django-celery
3. Flask
4. Flask-RESTful
5. Flask-SQLAlchemy
6. Tornado
7. Scrapy
8. scrapy-redis
### 数据库与数据操作
1. redis
2. pymongo
3. PyMySQL
4. PyYAML
5. numpy
6. pandas
7. dataclasses: 类的装饰器自动实现初始化方法 
```
@dataclass
class Student:
    name: str
    age: int = 0
stu = Student('小明', 23)
```
### 网络请求与多线程
1. requests
2. retry
3. vthread
4. selenium
### 办公
1. openpyxl
2. [xlwings](https://github.com/xlwings/xlwings) Excel Python 项目调用
3. [python-docx](https://github.com/python-openxml/python-docx) 处理docx文件
4. [python-pptx](https://github.com/scanny/python-pptx) 处理pptx文件
5. [pdfminer](https://github.com/euske/pdfminer) 从pdf中抽取文本
6. [textract](https://github.com/deanmalmgren/textract) 从任意文件中抽取文本 text = textract.process("path/to/file.extension")
7. [pyecharts](https://github.com/pyecharts/pyecharts) 绘图数据分析
8. [pygal](https://github.com/Kozea/pygal)[使用说明](http://www.pygal.org/en/stable/documentation/index.html) 绘图数据分析
### 工具类
1. itchat
2. celery
3. celery-with-redis
4. [schedule](https://github.com/dbader/schedule) python的定时执行。
5. Pillow
6. PyQRCode
7. [jieba](https://github.com/fxsjy/jieba) 中文分词组件
8. [unp](https://github.com/mitsuhiko/unp) 解压缩所有文件
9. [pypinyin](https://github.com/mozillazg/python-pinyin) 汉字拼音转换工具
10. [python-box](https://github.com/cdgriffith/Box) 把字典转换成可以用点语法调用的方式。
11. [pywebview](https://github.com/r0x0r/pywebview/) [使用说明](https://pywebview.flowrl.com/examples/) 用python构建web界面。
### 其他库
1. pip
2. py2app
3. [pyinstaller](https://github.com/pyinstaller/pyinstaller) 将python代码打包成可执行文件，包括windows和mac平台应用。
- 使用的时候pip3 install pyinstaller
- 找到pyinstaller的安装地址，比如//python3.7/bin/pyinstaller 或者brew install pyinstaller
- 修改alias，指定命令从这里执行，然后pyinstaller -F -w a.py
4. [Django-shop](https://github.com/awesto/django-shop) 可以用Django结合VUE开发购物网站。
5. [pywin32](https://github.com/mhammond/pywin32) Python for Windows (pywin32) Extensions
### 系统自带的库
1. [difflib] 比较字符相似度
2. [Python3.8](https://github.com/python/cpython/tree/3.8/Lib) python库说明文档。



