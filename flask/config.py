# coding: utf-8
import os
import sys
import multiprocessing

bind = '0.0.0.0:8000'
workers = os.environ.get('WORKERS', multiprocessing.cpu_count())
threads = os.environ.get('THREADS', 1 if multiprocessing.cpu_count() == 1 else 2)
CURR_PATH = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.dirname(CURR_PATH))
IS_DEBUG = True
reload = True
LOG_PATH = os.path.join(CURR_PATH, 'data/root.log')


