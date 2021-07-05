# coding=utf-8
import os
import sys
import time


class Tail(object):
    def __init__(self, tailed_file, func):
        self.check_file_validity(tailed_file)
        self.tailed_file = tailed_file
        self.callback = func if func else sys.stdout.write

    def follow(self, s=1):
        with open(self.tailed_file) as file_:
            file_.seek(0, 2)
            while True:
                curr_position = file_.tell()
                line = file_.readline()
                if not line:
                    file_.seek(curr_position)
                    time.sleep(s)
                else:
                    self.callback(line)

    def check_file_validity(self, file_):
        ''' Check whether the a given file exists, readable and is a file '''
        if not os.access(file_, os.F_OK):
            raise TailError("File '%s' does not exist" % (file_))
        if not os.access(file_, os.R_OK):
            raise TailError("File '%s' not readable" % (file_))
        if os.path.isdir(file_):
            raise TailError("File '%s' is a directory" % (file_))


class TailError(Exception):
    def __init__(self, msg):
        self.message = msg

    def __str__(self):
        return self.message


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
