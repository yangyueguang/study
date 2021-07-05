#coding:utf-8
'''
auther: Super
wechat: 2829969299
use for windows control
'''
import json
from time import sleep
from rpa import win32

'''键盘 shift+f10是右键'''
class Key(enumerate):
    ctrl = 'ctrl'
    enter = 'enter'
    shift = 'shift'
    fn = 'fn'
    tab = 'tab'
    alt = 'alt'
    win = 'win'
    up = 'up'
    down = 'down'
    left = 'left'
    right = 'right'
    back = 'backspace'
    delete = 'delete'
    space = 'space'
    esc = 'esc'
    home = 'home'
    end = 'end'
    insert = 'insert'

    f1 = 'f1'
    f2 = 'f2'
    f3 = 'f3'
    f4 = 'f4'
    f5 = 'f5'
    f6 = 'f6'
    f7 = 'f7'
    f8 = 'f8'
    f9 = 'f9'
    f10 = 'f10'
    f11 = 'f11'
    f12 = 'f12'
    '''单键输入'''
    @classmethod
    def send(cls, key):
        win32.key_send(key)
        sleep(1)

    '''键盘输入'''
    @staticmethod
    def input(word):
        for i in word:
            win32.key_send(i)
        sleep(2)

'''鼠标'''
class Mouse(object):
    '''初始化'''
    def __init__(self):
        self.x = 0
        self.y = 0
    '''移动'''
    def move(self, x=0, y=0):
        self.x = x
        self.y = y
        return win32.cursor_move(x, y)
    '''点击'''
    def click(self, times=1, left=True):
        win32.mouse_click(x=self.x, y=self.y, button='left' if left else 'right', count=times)
    '''滚动'''
    def scroll(self, height):
        win32.wheel_scroll(self.x, self.y, -height)
    # '''根据文字点击对应位置'''
    # def click_text(self, text, onwindow=None):
    #     screen_path = capture('screen.png', None) if not onwindow else onwindow.screenshots()
    #     positions = OCR().text2roi(screen_path, text)
    #     self.move((positions[0] + positions[2]) / 2, (positions[1] + positions[3]) / 2)
    #     self.click()
    # '''根据图片点击对应位置'''
    # def click_image(self, image_path, onwindow=None):
    #     screen_path = capture('screen.png', None) if not onwindow else onwindow.screenshots()
    #     positions = OCR().image2roi(screen_path, image_path)
    #     self.move((positions[0] + positions[2]) / 2, (positions[1] + positions[3]) / 2)
    #     self.click()

'''窗口'''
class Window(object):
    def __init__(self, title, title_class=None, timeout=5):
        self.obj = win32.win_appear(title, title_class, timeout)
        try:
            win32.get_hwnd_by_title(title, title_class)
            self.title = title
        except:
            self.title = self.obj
        self.timeout = timeout
        self.title_class = title_class
    def _valid(self, obj):
        if obj != 0:
            self.obj = obj
            return obj
        else:
            return None
    '''最小化'''
    def min(self):
        obj = win32.win_minimize(self.title, win_class_type=self.title_class, allMatch=True)
        return self._valid(obj)
    '''最大化'''
    def max(self):
        obj = win32.win_maximize(self.title, win_class_type=self.title_class, allMatch=True)
        return self._valid(obj)
    '''激活'''
    def active(self):
        obj = win32.win_active(self.title, win_class_type=self.title_class, allMatch=True)
        return self._valid(obj)
    '''关闭'''
    def close(self):
        obj = win32.win_close(self.title, win_class_type=self.title_class, allMatch=True)
        return self._valid(obj)
    '''是否出现'''
    def isAppear(self, timeout=10):
        obj = win32.win_appear(self.title, win_class_type=self.title_class, timeout=timeout, allMatch=True)
        return self._valid(obj)
    '''是否存在'''
    def isExists(self):
        return win32.win_exists(self.title, win_class_type=self.title_class, allMatch=True)
    '''等待出现'''
    def wait(self, isAppear=True, timeout=5):
        if isAppear:
            self.isAppear(timeout)
        else:
            self.disappear(timeout)
    '''显示'''
    def show(self):
        obj = win32.win_show(self.title, win_class_type=self.title_class, allMatch=True)
        return self._valid(obj)
    '''隐藏'''
    def hide(self):
        obj = win32.win_hide(self.title, win_class_type=self.title_class, allMatch=True)
        return self._valid(obj)
    '''消失'''
    def disappear(self, timeout=5):
        obj = win32.win_disappear(self.title, win_class_type=self.title_class, timeout=timeout, allMatch=True)
        return self.obj if obj == 0 else None
    '''标题名字'''
    def name(self):
        return win32.get_title_by_hwnd(self.obj).decode(encoding='utf-8')
    '''内容文本'''
    def content(self, child_title, index=1):
        return win32.text(child_title, self.title, index=index, parent_class_type=self.title_class, allMatch=True)
    '''按钮点击'''
    def button_click(self, type='button', index=1):
        success = win32.button_click(child_type=type, parent_title=self.title, index=index,
                                     parent_class_type=self.title_class, count=1, allMatch=True)
        return True if success == 0 else False
    '''文本输入'''
    def input(self, text, type='Edit', index=1):
        win32.input_text(type, self.title, text, index=index)
    '''截屏'''
    def screenshots(self, path='a.png', child_title=None, *args):
        pass
        # success = capture(path, xStart=args[0], yStart=args[2], xEnd=args[1], yEnd=args[3], cover=True, title=child_title, window_class_name=self.title_class, allMatch=True, index=1)
        # return path if success else None
    '''获取子窗口'''
    def children(self, type='button', index=1):
        childs = win32.get_sub_hwnd(type, self.title, index=index, parent_class_type=self.title_class, allMatch=True)
        return childs
    '''获取子窗口内容'''
    def child_content(self, type='button', index=1):
        result = win32.get_subwindow_content(type,self.title,index = index,parent_class_type = self.title_class)
        if result[0] > 0:
            return result[1]
        else:
            return None
    '''抽取表格'''
    def table(self, type='table'):
        result = win32.table_read(type, parent_title=self.title, index=1, parent_class_type=self.title_class, allMatch=True, read_type=1)
        return result
    '''开始录屏'''
    def start_record(self, path):
        self.record = win32.ScreenCap(path)
    '''结束录屏'''
    def stop_record(self):
        self.record.stop()
    '''获取屏幕像素'''
    def recognize_rate(self, x=0, y=0):
        return win32.get_screen_pixel(x, y)
    '''设置分辨率'''
    def set_recorgnizer(self, x=1920, y=1680):
        return win32.DesktopPixel(x, y)
    '''中心位置'''
    def center(self):
        p = self.position
        s = self.size
        return ((p[0] + s[0]) / 2, (p[1] + s[1]) / 2)
    @property
    def position(self):
        return win32.win_position(self.title, win_class_type=self.title_class, allMatch=True)
    @position.setter
    def position(self, *args):
        win32.set_window_position(self.title, args[9], args[1], self.title_class, 0)
    @property
    def size(self):
        return win32.win_size(self.title, win_class_type=self.title_class, allMatch=True)
    @size.setter
    def size(self, *args):
        win32.set_window_size(self.title, args[0], args[1], self.title_class, 0)

'''应用程序'''
class Project(object):
    '''程序名 程序运行路径'''
    def __init__(self, name='', path=''):
        self.name = name
        self.path = path
    '''点击菜单: path：文件-打开'''
    def menu_click(self, path, win_class=None):
        win32.click_menu(self.name, path, win_type_class=win_class, allMatch=False)
    '''激活程序'''
    def active(self):
        Window(self.name).active()
    '''剪切板'''
    @property
    def clipboard(self):
        return win32.copy_str_get()
    @clipboard.setter
    def clipboard(self, value):
        win32.copy_str_set(value)

    '''快捷键'''
    def quick(self, **kwargs):
        quick_key = ''
        if kwargs.has_key(Key.ctrl):
            quick_key = Key.ctrl + ' ' + kwargs[Key.ctrl]
        elif kwargs.has_key(Key.shift):
            quick_key = Key.shift + ' ' + kwargs[Key.shift]
        elif kwargs.has_key(Key.win):
            quick_key = Key.win + ' ' + kwargs[Key.win]
        elif kwargs.has_key(Key.alt):
            quick_key = Key.alt + ' ' + kwargs[Key.alt]
        else:
            quick_key = Key.fn + ' ' + kwargs[Key.fn]
        win32.shortkeys_press(None, quick_key, None, allMatch=False)
        sleep(2)

    '''启动程序'''
    def run(self):
        if self.path:
            win32.start_program(self.path)
        else:
            Key.send(Key.win)
            Key.input(self.name)
            Key.send(Key.enter)
