# coding=utf-8
import os
import sys
import time


class Tail(object):
    def __init__(self, file_name, func):
        if not os.access(file_name, os.F_OK):
            raise Exception(f'File {file_name} does not exist')
        if not os.access(file_name, os.R_OK):
            raise Exception(f'File {file_name} not readable')
        if os.path.isdir(file_name):
            raise Exception(f'File {file_name} is a directory')

        self.file_name = file_name
        self.callback = func if func else sys.stdout.write

    def follow(self, s=1):
        with open(self.file_name) as f:
            f.seek(0, 2)
            while True:
                curr_position = f.tell()
                line = f.readline()
                if not line:
                    f.seek(curr_position)
                    time.sleep(s)
                else:
                    self.callback(line)



'''test
f = open("test_log.log","w+")
try:
    while True:
        time.sleep(2)
        f.seek(0, 2)
        f.write("2020-02-05 15:35:43,376 - ERROR - web.py:1467 - _execute() - doc_prob: 0.5\n")
finally:
    f.close()
'''
