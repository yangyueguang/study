import multiprocessing
from multiprocessing import Pool, Process, Manager
from concurrent.futures import ThreadPoolExecutor, wait


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
    def __init__(self, able=multiprocessing.cpu_count()):
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



if __name__ == '__main__':
    # ds
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
