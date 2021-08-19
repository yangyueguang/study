# coding=utf-8
import io
import os
import re
import sys
import cv2
import pika
import json
import dlog
import uuid
import time
import xmind
import gzip
import shutil
import base64
import traceback
import gevent
import requests
import getopt
import aiohttp
import numpy as np
import pandas as pd
from PIL import Image
from queue import Queue
from zipfile import ZipFile
from pathlib import Path
from pymongo import MongoClient
from bottle import HTTPResponse
from contextlib import closing
import matplotlib.pyplot as plt
from multiprocessing import Pool, Process, Manager, cpu_count
from concurrent.futures import ThreadPoolExecutor, wait


def sys_params():
    argv = sys.argv

    def print_help():
        print('usage:\n\t{} -c <container> -m <message>\n\tsuport regex'.format(os.path.split(argv[0])[1]))
        print('usage:\n\t{} -f <file> -m <message>\n\tsuport regex'.format(os.path.split(argv[0])[1]))

    try:
        opts, args = getopt.getopt(argv[1:], "hc:f:m:", ["help", "container=", "file=", "message="])
    except getopt.GetoptError:
        print_help()
        exit(2)
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print_help()
            exit(0)
        elif opt in ("-c", "--container"):
            print('container', arg)
        elif opt in ("-f", "--file"):
            print('file', arg)
        elif opt in ("-m", "--message"):
            print('message', arg)


'''test
f = open("root.log","w+")
try:
    while True:
        time.sleep(2)
        f.seek(0, 2)
        f.write("2020-02-05 15:35:43,376 - ERROR - web.py:1467 - _execute() - doc_prob: 0.5\n")
finally:
    f.close()
'''
def tail(file_name, func=sys.stdout.write, s=1):
    if not os.access(file_name, os.F_OK):
        raise Exception(f'File {file_name} does not exist')
    if not os.access(file_name, os.R_OK):
        raise Exception(f'File {file_name} not readable')
    if os.path.isdir(file_name):
        raise Exception(f'File {file_name} is a directory')
    with open(file_name) as f:
        f.seek(0, 2)
        while True:
            curr_position = f.tell()
            line = f.readline()
            if not line:
                f.seek(curr_position)
                time.sleep(s)
            else:
                func(line)


def make_archive(base_dir, file_name):
    import zipfile
    with zipfile.ZipFile(file_name, 'w', compression=zipfile.ZIP_DEFLATED) as zf:
        base_dir = os.path.normpath(base_dir)
        for dir_path, dir_names, filenames in os.walk(base_dir):
            for name in sorted(dir_names) + filenames:
                if name[0] == '.':
                    continue
                path = os.path.normpath(os.path.join(dir_path, name))
                zf.write(path, path[len(base_dir) + 1:])


def response(file_name):
    body = open(file_name, 'rb') or gzip.open(file_name, 'rb')
    headers = {
        'Content-Encoding': 'gzip',
        'Content-Type': 'application/zip'
    }
    return HTTPResponse(body=body, status=200, headers=headers)


def gzip_body(out, charset='utf-8'):
    with io.BytesIO() as buf:
        with gzip.GzipFile(fileobj=buf, mode='wb') as f:
            for data in out:
                f.write(data.encode(charset) if isinstance(data, str) else data)
        return buf.getvalue()


def get_exception_message():
    with io.StringIO() as fp:
        traceback.print_exc(file=fp)
        return fp.getvalue()


def file_to_base64(file_data: bytes):
    return base64.b64encode(file_data).decode('utf-8')


def base64_to_data(content: bytes):
    return base64.b64decode(content)


# 验证代理IP是否可用
def verify_proxy(proxy):
    with aiohttp.ClientSession(connector=aiohttp.TCPConnector(verify_ssl=False)) as session:
        res = session.get('http://www.baidu.com', proxy=f'http://{proxy}', timeout=15, allow_redirects=False)
        return res.status == 200


# 素描
def sketch(pic_path, out_path):
    a = np.asarray(Image.open(pic_path).convert('L')).astype('float')
    grad_x, grad_y = np.gradient(a)
    grad_x = grad_x * 10 / 100.
    grad_y = grad_y * 10 / 100.
    A = np.sqrt(grad_x ** 2 + grad_y ** 2 + 1.)
    vec_el = np.pi / 2.2
    vec_az = np.pi / 4.
    b = 255 * (np.cos(vec_el) * np.cos(vec_az) * grad_x / A + np.cos(vec_el) * np.sin(vec_az) * grad_y / A + np.sin(
        vec_el) * 1. / A)
    im = Image.fromarray(b.clip(0, 255).astype('uint8'))
    im.save(out_path)
    print("保存成功查看")


def mongo():
    client = MongoClient('localhost', 27017)
    # client = MongoClient('mongodb://localhost:27017')
    # client = MongoClient('mongodb://username:password@localhost:27017/dbname')
    db = client.zfdb
    test = db.test
    n = db.test_collection.count_documents({'name': {'$gt': 1000}})
    document = db.test_collection.find_one({'name': 'zone'})
    print(document)
    person = {'name': 'zone', 'sex': 'boy'}
    res = test.insert_one(person)
    persons = [{'name': 'zone', 'sex': 'boy'}, {'name': 'zone1', 'sex': 'boy1'}]
    res = test.insert_many(persons)
    res = test.delete_one({'name': 'zone'})
    res = test.delete_many({'name': 'zone'})
    res = test.update_one({'name': 'zone'}, {'$set': {'sex': 'girl girl'}})
    print(res.matched_count)
    test.update_many({'name': 'zone'}, {'$set': {'sex': 'girl girl'}})
    print(test.find())
    print(test.find({"sex": "boy"}).sort("name"))
    # 聚合查找
    aggs = [
        {"$match": {"$or": [{"field1": {"$regex": "regex_str"}}, {"field2": {"$regex": "regex_str"}}]}},  # 正则匹配字段
        {"$project": {"field3": 1, "field4": 1}},  # 筛选字段
        {"$group": {"_id": {"field3": "$field3", "field4": "$field4"}, "count": {"$sum": 1}}},  # 聚合操作
    ]
    result = test.aggregate(pipeline=aggs)
    print(result)


def codes_image(img_name, out='res.jpg'):
    table = "$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\|()1{}[]?-_+~<>i!lI;:,\"^`'. "
    maps = dict([(str(k), v) for k, v in enumerate(table)])
    scale = 20
    img = cv2.imread(img_name)
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    w, h = gray.shape
    tar = np.zeros((w // scale + 1, h // scale + 1), dtype=np.uint8)
    tarImg = np.ones(gray.shape) * 255
    cv2.imwrite(out, tarImg)
    img = cv2.imread(out)
    w, h = tar.shape
    for i in range(h):
        for j in range(w):
            d = gray[i * scale:(i + 1) * scale, j * scale:(j + 1) * scale].mean() / 256 * len(table)
            tar[i, j] = int(d)
            cv2.putText(img, maps.get(str(int(d))), (j*scale,i*scale), cv2.FONT_HERSHEY_SIMPLEX, scale*0.05, (0,0,255), 2)
    dd = tar.copy()
    plt.imshow(img)
    plt.show()
    cv2.imwrite(out, img)
    da = dd.astype('int').astype('str')
    aa = np.vectorize(lambda x: maps.get(x, x))(da)
    txt = '\n'.join([''.join(list(i)) for i in aa])
    with open(out + '.txt', 'w') as f:
        f.write(txt)


def rich_excel(excel_path):
    headers = []
    result = np.empty((10, 5 * 4 + 1), dtype='U1000')
    writer = pd.ExcelWriter(excel_path, engine='xlsxwriter')
    df = pd.DataFrame(result, columns=headers)
    df.to_excel(writer, sheet_name='result', startrow=0, header=headers, index=False)
    workbook = writer.book
    sheet = writer.sheets['result']
    sheet.set_column(0, result.shape[0], 16)
    header_format = workbook.add_format({'bold': True, 'align': 'vcenter', 'text_wrap': True})
    sheet.set_row(0, cell_format=header_format)
    bad_format = workbook.add_format({'bold': True, 'text_wrap': True, 'valign': 'top', 'align': 'right', 'fg_color': '#FF0000', 'border': 2})
    for row, v in enumerate(result):
        for column, vv in enumerate(v):
            if column > 0 and (column - 1) % 4 in [2, 3] and vv < 1:
                sheet.write(row + 1, column, vv, bad_format)
    writer.save()


class TemporaryDirectory(object):
    def __init__(self, name='tmp'):
        self.name = name

    def __enter__(self):
        try:
            os.mkdir(self.name)
        except:
            ...
        return self.name

    def __exit__(self, exc_type, exc_value, traceback):
        shutil.rmtree(self.name)


class BatchBase(object):
    def __init__(self):
        self.queue = Queue()
        self.pool = ThreadPoolExecutor(max_workers=10)
        self.files = []

    def start(self):
        for item in self.files:
            task = self.pool.submit(self.download, item)
            self.queue.put({"object": task})
        while not self.queue.empty():
            t = self.queue.get()
            if not t["object"].done():
                self.queue.put(t)
        return 'file_name'

    def download(self, url):
        res = requests.get(url)
        with open('data/{}.mp4'.format(url), 'wb')as f:
            for content in res.iter_content(1024):
                if content:
                    f.write(content)

    def video_downloader(self, video_url, video_name):
        size = 0
        with closing(requests.get(video_url, headers={}, stream=True)) as res:
            chunk_size = 1024
            content_size = int(res.headers['content-length'])
            if res.status_code == 200:
                sys.stdout.write(' [文件大小]:%0.2f MB\n' % (content_size / chunk_size / 1024))
            with open(video_name, 'wb') as file:
                for data in res.iter_content(chunk_size=chunk_size):
                    file.write(data)
                size += len(data)
                file.flush()
                sys.stdout.write(' [下载进度]:%.2f%%' % float(size / content_size * 100) + '\r')
                sys.stdout.flush()


class Translator(object):
    def __init__(self, width=1000, each=10):
        self.width = width
        self.each = each

    def encode(self, s, o=' '):
        res = [bin(ord(c)).replace('0b', '') for c in s]
        return o.join([(8 - len(i)) * '0' + i for i in res])

    def decode(self, s):
        s = s.replace(' ', '')
        res = [s[i:i + 8] for i in range(0, (len(s)//8)*8, 8)]
        return ''.join([chr(int(i, 2)) for i in res])

    def file_to_base64(self, file_data: bytes):
        return base64.b64encode(file_data).decode('utf-8')

    def base64_to_data(self, content: bytes):
        return base64.b64decode(content)

    def make_ercode(self, codes):
        w = self.width // self.each
        if len(codes) > w * w:
            print('超出')
        white = [255, 255, 255]
        black = [0, 0, 0]
        e = self.each
        output = np.zeros((self.width + 4 * e, self.width + 4 * e, 3), np.uint8)
        output[e:2 * e, e:-e] = output[-2 * e:-e, e:-e] = white
        output[e:-e, e:2 * e] = output[e:-e, -2 * e:-e] = white
        for i, c in enumerate(codes):
            col = i % w
            row = i // w
            if row >= w:
                break
            output[(2 + row) * e:(row + 3) * e, (col + 2) * e:(col + 3) * e] = white if c == '1' else black
        return output

    def file_to_video(self, file_path, output=None):
        with open(file_path, 'rb') as buf:
            content = 's' * 50 + 'start' + self.file_to_base64(buf.read()) + 'end' + 'd' * 50
        content = self.encode(content, '')
        rows = self.width // self.each
        print(f'need about {len(content) // (rows * rows * 60)} minute')
        video = cv2.VideoWriter(output, cv2.VideoWriter_fourcc(*'XVID'), 1, (self.width + 4*self.each, self.width+4*self.each)) if output else None
        nump = (rows * rows) // 8 * 8
        pages = [content[i * nump:(i + 1) * nump] for i in range(len(content) // nump + 1)]
        for p in pages:
            img = self.make_ercode(p)
            cv2.imshow('Live', img)
            cv2.waitKey(1)
            # time.sleep(0.5)
            if video:
                video.write(img)
        video.release()

    def live_to_file(self, video_path=None):
        out_str = []
        pre_res = ''
        capture = cv2.VideoCapture(video_path if video_path else 0)
        while capture.isOpened():
            rval, frame = capture.read()
            if not rval or cv2.waitKey(1) in [27, ord('q')]:
                break
            h, w, deep = frame.shape
            # 旋转
            # matRotate = cv2.getRotationMatrix2D((w/2, h), -90, 1)  # mat rotate 1 center 2 angle 3 缩放系数
            # frame = cv2.warpAffine(frame, matRotate, (w+h, max(w, h)))
            # 平移
            # M = np.float32([[1, 0, -w/2], [0, 1, 0]])
            # frame = cv2.warpAffine(frame, M, (h, w))
            # 左右反转
            # frame = cv2.flip(frame, 1)
            res = self.get_img_codes(frame)
            cv2.imshow('live', frame)
            if not re.match(r'^[A-Za-z0-9=]+$', res) or res == pre_res:
                continue
            print(res)
            pre_res = res
            out_str.append(res)
        capture.release()
        cv2.destroyAllWindows()
        res = ''.join(out_str)
        return res

    def _get_splits(self, code, gap):
        ros = [0, code.shape[-1]]
        for r in code:
            s = np.where(np.diff(r) != 0)[0]+1
            ros.extend(s)
        ros.sort()
        rs = np.array(sorted(list(set(ros))))
        split_rows = np.split(rs, np.where(np.diff(rs) > gap/2)[0] + 1, axis=0)
        slice = []
        pre = 0
        for i in split_rows:
            this = i[0]
            for j in i:
                if ros.count(j) > ros.count(this):
                    this = j
            power = (this - pre) / gap
            if power > 1.8:
                for i in range(round(power)-1):
                    slice.append(pre+gap * (i+1))
                slice.append(this)
            elif this - pre < gap*0.9 and pre != 0:
                continue
            else:
                slice.append(this)
            pre = this
        if len(slice) != (self.width // self.each + 1):
            slice = [i*self.each for i in range(self.width//self.each + 1)]
        return slice

    def transfor_image(self, img, rect1, rect2):
        w, h, deep = img.shape
        if len(rect1) < 4:  # 仿射变换
            M = cv2.getAffineTransform(rect1, rect2)
            return cv2.warpAffine(img, M, (w, h))
        else:  # 透视变换
            M = cv2.getPerspectiveTransform(rect1, rect2)
            return cv2.warpPerspective(img, M, (w, h))

    def get_img_codes(self, img):
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        gray = cv2.adaptiveThreshold(~gray, 1, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 15, -10)
        contours, _ = cv2.findContours(gray, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)
        contours.sort(key=lambda c: cv2.contourArea(c), reverse=True)
        if not contours:
            return ''
        # cv2.drawContours(img, contours, -1, (255, 0, 0), 2)
        code_img = None
        for c in contours:
            x, y, w, h = cv2.boundingRect(c)
            if 0.9 < w/h < 1.1 and w > 100:
                code_img = img[y:y + h, x:x + w]
                code_gray = gray[y:y+h, x:x + w]
                c1, _ = cv2.findContours(code_gray, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
                is_start_white = True
                for cc in c1:
                    arclen = cv2.arcLength(cc, True)
                    epsilon = max(3, int(arclen * 0.02))
                    approx = cv2.approxPolyDP(cc, epsilon, True)
                    area = cv2.contourArea(cc)
                    if 0.3 < area/w/h < 0.99 and approx.shape[0] == 4:
                        if not is_start_white:
                            is_start_white = True
                            continue
                        pts = [approx[i][0] for i in range(4)]
                        pts.sort(key=np.sum)
                        if pts[1][0] < pts[1][-1]:
                            pts[1], pts[2] = pts[2], pts[1]
                        pts1 = np.float32(pts)
                        x0, y0, x1, y1 = min(pts1[:, 0]), min(pts1[:, -1]), max(pts1[:, 0]), max(pts1[:, -1])
                        pts2 = np.float32([[x0, y0], [x1, y0], [x0, y1], [x1, y1]])
                        code_img = self.transfor_image(code_img, pts1, pts2)
                        cv2.rectangle(img, (x, y), (x+w, y+h), (255, 0, 0), 2)
                        break
                break
        if code_img is None:
            return ''
        gray = cv2.cvtColor(code_img, cv2.COLOR_BGR2GRAY)
        gray = np.where(gray > 125, 255, 0)
        x_shadow = np.sum(gray, axis=0)
        y_shadow = np.sum(gray, axis=1)
        x_black = np.where(x_shadow < x_shadow.max(initial=None)/20)[0]
        y_black = np.where(y_shadow < y_shadow.max(initial=None)/20)[0]
        if len(x_black) < 2 or len(y_black) < 2:
            return ''
        gray[:, :x_black[0]+2] = gray[:, x_black[-1]-2:] = gray[:y_black[0]+2, :] = gray[y_black[-1]-2:, :] = 0
        x_shadow = np.sum(gray, axis=0)
        y_shadow = np.sum(gray, axis=1)
        x_white = np.where(x_shadow >= x_shadow.max(initial=None)*0.99)[0]
        y_white = np.where(y_shadow >= y_shadow.max(initial=None)*0.99)[0]
        gapx = len(x_white) // 2
        gapy = len(y_white) // 2
        real_code = gray[y_white[0]+gapy: y_white[-1]-gapy+1, x_white[0]+gapx: x_white[-1]-gapx+1]
        if len(real_code) <= gapx or len(real_code[0]) <= gapy or gapx <= 0 or gapy <= 0 or np.all(real_code==255) or np.all(real_code==0):
            return ''
        x_slice = self._get_splits(real_code, gapx)
        y_slice = self._get_splits(real_code.T, gapy)
        x_sections = [[x_slice[i], x_slice[i + 1]] for i in range(len(x_slice) - 1)]
        y_sections = [[y_slice[i], y_slice[i + 1]] for i in range(len(y_slice) - 1)]
        res = []
        for i in y_sections:
            row = []
            for j in x_sections:
                pix = real_code[i[0]:i[-1], j[0]:j[-1]]
                row.append(1 if np.average(pix) > 125 else 0)
            res.append(row)
        res = ''.join([str(k) for r in res for k in r])
        return self.decode(res)

    def cat(self, img):
        plt.imshow(img)
        plt.show()


class Work(object):
    def __init__(self, target, call_back=None, error_callback=None, *args, **kwargs):
        self.target = target
        self.args = args
        self.kwargs = kwargs
        self.call_back = call_back
        self.error_callback = error_callback

    def run(self):
        res = None
        try:
            res = self.target(*self.args, **self.kwargs)
        except Exception:
            if self.error_callback:
                self.error_callback()
        finally:
            if self.call_back:
                self.call_back(res)


class Executor(object):
    def __init__(self, able=cpu_count()):
        self.pool = Pool(able)
        self.threads = ThreadPoolExecutor(max_workers=able)
        self.dict = Manager().dict()
        self.list = Manager().list()
        self.works = []

    # 多进程方式
    def run(self):
        jobs = []
        for i in self.works:
            w = self.pool.apply_async(i.target, i.args, i.kwargs, callback=i.call_back, error_callback=i.error_callback)
            jobs.append(w)
        self.pool.close()
        self.pool.join()
        self.pool.terminate()
        return [w.get(timeout=60) for w in jobs]

    # 多线程方式
    def thread_run(self):
        futures = []
        for i in self.works:
            res = self.threads.submit(i.target, *i.args)
            futures.append(res)
        wait(futures)


class Cleaner(object):
    def __init__(self, interval=30):
        self.interval = interval
        self.stopped = False
        self.files = []
        self.error_files = []
        self.thread = None

    def add_file(self, *filenames):
        self.files.extend(filenames)

    def __del__(self):
        self.stop()

    def start(self):
        self.stopped = False
        self.thread = gevent.spawn(self.run)

    def run(self):
        start_time = time.time()
        while not self.stopped:
            if time.time() - start_time < self.interval:
                gevent.sleep(1)
                continue
            try:
                self.do_clean()
            except Exception:
                traceback.print_exc()
            finally:
                start_time = time.time()

    def join(self):
        if self.thread:
            self.thread.join()

    def stop(self):
        if self.thread:
            self.stopped = True
            self.thread.join(timeout=2)
            self.thread = None

    def do_clean(self):
        tmp = self.error_files
        self.error_files = []
        self.delete_files(tmp, self.error_files)
        tmp = self.files
        self.files = []
        self.delete_files(tmp, self.error_files)

    def delete_files(self, files, error_files):
        while files:
            file = files.pop()
            try:
                self.delete_file(file)
            except Exception:
                traceback.print_exc()
                error_files.append(file)
            finally:
                ...

    def delete_file(self, file):
        if os.path.isfile(file):
            os.remove(file)
        elif os.path.isdir(file):
            shutil.rmtree(file)


class ImageElement(xmind.core.mixin.WorkbookMixinElement):
    TAG_NAME = 'xhtml:img'

    def __init__(self, name, node=None, ownerWorkbook=None):
        super(ImageElement, self).__init__(node, ownerWorkbook)
        self.setAttribute('align', 'left')
        self.setAttribute('svg:height', '30')
        self.setAttribute('svg:width', '30')
        for i in os.listdir('markers'):
            for j in os.listdir(f'markers/{i}'):
                if name in j:
                    self.setAttribute('xhtml:src', f'xap:markers/{i}/{j}')


class Mind(object):
    def __init__(self, name):
        super(Mind, self).__init__()
        self.name = name
        self.content = []
        self.is_zen = False
        self.workbook = xmind.load(name)
        if not os.path.exists(name):
            return
        with ZipFile(name) as m:
            if 'content.json' in m.namelist():
                self.is_zen = True
                d = m.open('content.json').read().decode('utf-8')
                self.content = json.loads(d)

    def save(self, name=None):
        if not self.is_zen:
            xmind.save(self.workbook, name or self.name)
        else:
            with ZipFile(name or self.name, 'w') as x:
                x.writestr('content.json', json.dumps(self.content, ensure_ascii=False, indent=3))
                manifest = '{"file-entries":{"content.json":{},"metadata.json":{},"":{}}}'
                metadata = '{"creator":{"name":"Vana","version":"10.1.1.202003310622"}}'
                x.writestr('manifest.json', manifest)
                x.writestr('metadata.json', metadata)

    def parse_mm(self, name):
        sheet = self.workbook.getPrimarySheet()
        sheet.setTitle(Path(name).name)
        topic = sheet.getRootTopic()
        topic.setTitle('map')
        topic = topic.addSubTopic()
        topic.addMarker('mark')
        topic.appendChild('icon')
        topic.setTitle('title')
        topic.setURLHyperlink('link')
        self.save()

        with ZipFile(self.name, 'a') as f:
            manifest = '''
                <manifest xmlns="urn:xmind:xmap:xmlns:manifest:1.0" password-hint="">
                    %s
                    <file-entry full-path="markers/" media-type=""/>
                    <file-entry full-path="content.xml" media-type="text/xml"/>
                    <file-entry full-path="META-INF/" media-type=""/>
                    <file-entry full-path="META-INF/manifest.xml" media-type="text/xml"/>
                    <file-entry full-path="meta.xml" media-type="text/xml"/>
                    <file-entry full-path="styles.xml" media-type="text/xml"/>
                    <file-entry full-path="markers/markerSheet.xml" media-type="text/xml"/>
                </manifest>
                '''
            marks = '<marker-sheet xmlns="urn:xmind:xmap:xmlns:marker:2.0" version="2.0"> %s </marker-sheet>'
            manis = []
            mars = []
            for i in os.listdir('markers'):
                mars.append(f'<marker-group id="{i}" name="{i}" singleton="true">')
                for j in os.listdir('markers/' + i):
                    icon_name = f'{i}/{j}'
                    f.write(f'markers/{icon_name}')
                    mars.append(f'<marker id="{j.split(".")[0]}" name="{j}" resource="{icon_name}"/>')
                    manis.append(f'<file-entry full-path="markers/{icon_name}" media-type="image/{j.split(".")[-1].replace("jpg", "jpeg")}"/>')
                mars.append(f'</marker-group>')

            manifest = manifest % '\n'.join(manis)
            marks = marks % '\n'.join(mars)
            f.writestr('META-INF/manifest.xml', manifest)
            f.writestr('markers/markerSheet.xml', marks)


class MQConsumer(object):
    def __init__(self):
        credentials = pika.PlainCredentials("admin", "123456")
        self.connection = pika.BlockingConnection(pika.ConnectionParameters(host='rabbitmq', port=5672, credentials=credentials))
        self.channel = self.connection.channel()
        self.channel.queue_declare(queue='api_queue')
        self.channel.basic_qos(prefetch_count=1)
        self.channel.basic_consume('api_queue', on_message_callback=self.callback)

    def start_service(self):
        self.channel.start_consuming()

    def callback(self, channel, method, properties, body):
        dlog.dlog('消费：{}'.format(body))
        result = {"task": 'over'}
        channel.basic_publish(
            exchange='',
            routing_key=properties.reply_to,
            body=json.dumps(result).encode(),
            properties=pika.BasicProperties(correlation_id=properties.correlation_id)
        )
        channel.basic_ack(delivery_tag=method.delivery_tag)


class MQProducer(object):
    def __init__(self):
        credentials = pika.PlainCredentials("admin", "123456")
        self.connection = pika.BlockingConnection(pika.ConnectionParameters(host='rabbitmq', port=5672, credentials=credentials))
        self.channel = self.connection.channel()
        self.channel.exchange_declare(exchange='api_ex', exchange_type='fanout')
        self.channel.queue_declare(queue='api_queue')
        self.channel.queue_bind(exchange='api_ex', queue='api_queue')
        self.callbackQueue = self.channel.queue_declare(queue='', exclusive=False)
        self.queueName = self.callbackQueue.method.queue
        self.channel.basic_consume(on_message_callback=self.callback, auto_ack=False, queue=self.queueName)

    def callback(self, channel, method, props, body):
        if self.corr_id == props.correlation_id:
            self.response = body

    def call(self, requestStr):
        dlog.dlog('生产：{}'.format(requestStr))
        self.response = None
        self.corr_id = str(uuid.uuid4().hex)
        properties = pika.BasicProperties(reply_to=self.queueName, correlation_id=self.corr_id)
        self.channel.basic_publish(exchange='api_ex', routing_key='api_queue', body=requestStr, properties=properties)
        while self.response is None:
            self.connection.process_data_events()
        return self.response


if __name__ == '__main__':
    for i in os.listdir('xmind'):
        os.remove(f'xmind/{i}')
    for m in os.listdir('mm'):
        mind = Mind(f'xmind/{m}.xmind')
        mind.parse_mm('mm/' + m)

    def doson(a=None, b=None, c=None):
        print(f'hello')
        return 'ok'

    def workover(name):
        print(name)
        print('==' * 10)
    execu = Executor()
    ar = [1,2,3]
    for i in range(10):
        w = Work(doson, None, None, *ar)
        execu.works.append(w)
    # result = execu.run()
    result = execu.thread_run()
    print('over')
    t = Translator(1000, 20)
    t.file_to_video('../Dockerfile_cpu', '../data_result/b.avi')
    res = t.live_to_file('../data_result/b.avi')  # '../data_result/a.avi'
    pat = re.search(r's+tart(.*)end+', res)
    if pat:
        data = t.base64_to_data(bytes(pat.group(1), encoding='utf-8'))
        with open('../data_result/a.txt', 'wb') as f:
            f.write(data)
    print('')
