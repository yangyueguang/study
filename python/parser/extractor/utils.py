# coding=utf-8
import os
import sys
import io
import gzip
import shutil
import base64
import traceback
import requests
from queue import Queue
from skimage import io
from bottle import HTTPResponse
from contextlib import closing
from concurrent.futures import ThreadPoolExecutor


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
