import os
import shutil
import time
import traceback
import gevent


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

