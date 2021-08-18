import os
import platform
import random
import time
import uuid
from PIL import Image
from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
IMAGE_DATA_FILE_PATH = "./data"

import json
import requests
import base64
from io import BytesIO
from sys import version_info
import time
from io import BytesIO
from PIL import Image
from selenium import webdriver
from selenium.webdriver import ActionChains
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

EMAIL = '2829969299@qq.com'
PASSWORD = '123456'
BORDER = 6
INIT_LEFT = 60
import pytesseract
from PIL import Image

# 图片降噪处理 standard:阀值
def convert_Image(img, standard=127.5):
    image = img.convert('L')
    pixels = image.load()
    for x in range(image.width):
        for y in range(image.height):
            if pixels[x, y] > standard:
                pixels[x, y] = 255
            else:
                pixels[x, y] = 0
    image.show()
    return image

def main():
    base_img = Image.open('vcode.jpg')
    img = convert_Image(base_img)
    num_conf = '--psm 6 --oem 3 -c tessedit_char_whitelist=0123456789'
    str_conf = ''
    textCode = pytesseract.image_to_string(img, lang='eng', config=str_conf)
    print('识别的结果：', textCode)


class CrackGeetest():
    def __init__(self):
        self.url = 'http://ha.gsxt.gov.cn/index.html'
        self.browser = webdriver.Chrome()
        self.wait = WebDriverWait(self.browser, 20)
        #self.email = EMAIL
        #self.password = PASSWORD

    def __del__(self):
        self.browser.close()

    def get_geetest_button(self):
        """
        获取初始验证按钮
        :return:
        """
        button = self.wait.until(EC.element_to_be_clickable((By.CLASS_NAME, 'geetest_slider_button')))
        return button

    def get_position(self):
        """
        获取验证码位置
        :return: 验证码位置元组
        """
        img = self.wait.until(EC.presence_of_element_located((By.CLASS_NAME, 'geetest_canvas_slice geetest_absolute')))
        time.sleep(2)
        location = img.location
        size = img.size
        top, bottom, left, right = location['y'], location['y'] + size['height'], location['x'], location['x'] + size[
            'width']
        return (top, bottom, left, right)

    def get_screenshot(self):
        """
        获取网页截图
        :return: 截图对象
        """
        screenshot = self.browser.get_screenshot_as_png()
        screenshot = Image.open(BytesIO(screenshot))
        return screenshot

    def get_slider(self):
        """
        获取滑块
        :return: 滑块对象
        """
        slider = self.wait.until(EC.element_to_be_clickable((By.CLASS_NAME, 'geetest_slider_button')))
        return slider

    def get_geetest_image(self, name='captcha.png'):
        """
        获取验证码图片
        :return: 图片对象
        """
        top, bottom, left, right = self.get_position()
        print('验证码位置', top, bottom, left, right)
        screenshot = self.get_screenshot()
        captcha = screenshot.crop((left, top, right, bottom))
        captcha.save(name)
        return captcha

    def open(self):
        """
        打开网页输入用户名密码
        :return: None
        """
        self.browser.get(self.url)
        # email = self.wait.until(EC.presence_of_element_located((By.ID, 'email')))
        # password = self.wait.until(EC.presence_of_element_located((By.ID, 'password')))
        # email.send_keys(self.email)
        # password.send_keys(self.password)
        keyword = self.wait.until(EC.presence_of_element_located((By.ID, 'keyword')))
        keyword.send_keys("河南镇平农村商业银行")
        submit = self.wait.until(EC.element_to_be_clickable((By.ID, 'btn_query')))

    def get_gap(self, image1, image2):
        """
        获取缺口偏移量
        :param image1: 不带缺口图片
        :param image2: 带缺口图片
        :return:
        """
        left = 60
        for i in range(left, image1.size[0]):
            for j in range(image1.size[1]):
                if not self.is_pixel_equal(image1, image2, i, j):
                    left = i
                    return left
        return left

    def is_pixel_equal(self, image1, image2, x, y):
        """
        判断两个像素是否相同
        :param image1: 图片1
        :param image2: 图片2
        :param x: 位置x
        :param y: 位置y
        :return: 像素是否相同
        """
        # 取两个图片的像素点
        pixel1 = image1.load()[x, y]
        pixel2 = image2.load()[x, y]
        threshold = 60
        if abs(pixel1[0] - pixel2[0]) < threshold and abs(pixel1[1] - pixel2[1]) < threshold and abs(
                pixel1[2] - pixel2[2]) < threshold:
            return True
        else:
            return False

    def get_track(self, distance):
        """
        根据偏移量获取移动轨迹
        :param distance: 偏移量
        :return: 移动轨迹
        """
        # 移动轨迹
        track = []
        # 当前位移
        current = 0
        # 减速阈值
        mid = distance * 4 / 5
        # 计算间隔
        t = 0.2
        # 初速度
        v = 0

        while current < distance:
            if current < mid:
                # 加速度为正2
                a = 2
            else:
                # 加速度为负3
                a = -3
            # 初速度v0
            v0 = v
            # 当前速度v = v0 + at
            v = v0 + a * t
            # 移动距离x = v0t + 1/2 * a * t^2
            move = v0 * t + 1 / 2 * a * t * t
            # 当前位移
            current += move
            # 加入轨迹
            track.append(round(move))
        return track

    def move_to_gap(self, slider, track):
        """
        拖动滑块到缺口处
        :param slider: 滑块
        :param track: 轨迹
        :return:
        """
        ActionChains(self.browser).click_and_hold(slider).perform()
        for x in track:
            ActionChains(self.browser).move_by_offset(xoffset=x, yoffset=0).perform()
        time.sleep(0.5)
        ActionChains(self.browser).release().perform()

    def login(self):
        """
        登录
        :return: None
        """
        submit = self.wait.until(EC.element_to_be_clickable((By.CLASS_NAME, 'login-btn')))
        submit.click()
        time.sleep(10)
        print('登录成功')

    def crack(self):
        # 输入用户名密码
        self.open()

        # 点击验证按钮
        button = self.get_geetest_button()
        button.click()
        # 获取验证码图片
        image1 = self.get_geetest_image('captcha1.png')
        # 点按呼出缺口
        slider = self.get_slider()
        slider.click()
        # 获取带缺口的验证码图片
        image2 = self.get_geetest_image('captcha2.png')
        # 获取缺口位置
        gap = self.get_gap(image1, image2)
        print('缺口位置', gap)
        # 减去缺口位移
        gap -= BORDER
        # 获取移动轨迹
        track = self.get_track(gap)
        print('滑动轨迹', track)
        # 拖动滑块
        self.move_to_gap(slider, track)

        success = self.wait.until(
            EC.text_to_be_present_in_element((By.CLASS_NAME, 'geetest_success_radar_tip_content'), '验证成功'))
        print(success)

        # 失败后重试
        if not success:
            self.crack()
        else:
            self.login()


if __name__ == '__main__':
    crack = CrackGeetest()
    crack.crack()

#
# '''
# from selenium.webdriver.support import expected_conditions as EC
# from selenium import webdriver
# from selenium.webdriver.support.wait import WebDriverWait
# from selenium.webdriver.common.by import By
# from selenium.webdriver import ActionChains
# from PIL import Image
# from io import BytesIO
# import time
#
# BORDER = 6
#
# class CrackGeetest():
#     def __init__(self):
#         self.url = 'https://www.geetest.com/type/'
#         self.browser = webdriver.Chrome()
#         self.wait = WebDriverWait(self.browser,10)
#
#     def open(self):
#         '''
#         打开网页
#         :return None
#         '''
#         self.browser.get(self.url)
#
#     def close(self):
#         '''
#         关闭网页
#         :return None
#         '''
#         self.browser.close()
#         self.browser.quit()
#
#     def change_to_slide(self):
#         '''
#         切换为滑动认证
#         :return 滑动选项对象
#         '''
#         huadong = self.wait.until(
#             EC.element_to_be_clickable((By.CSS_SELECTOR,'.products-content ul > li:nth-child(2)'))
#         )
#         return huadong
#
#     def get_geetest_button(self):
#         '''
#         获取初始认证按钮
#         :return 按钮对象
#         '''
#         button = self.wait.until(
#             EC.element_to_be_clickable((By.CSS_SELECTOR,'.geetest_radar_tip'))
#         )
#         return button
#
#     def wait_pic(self):
#         '''
#         等待验证图片加载完成
#         :return None
#         '''
#         self.wait.until(
#             EC.presence_of_element_located((By.CSS_SELECTOR,'.geetest_popup_wrap'))
#         )
#
#     def get_screenshot(self):
#         """
#         获取网页截图
#         :return: 截图对象
#         """
#         screenshot = self.browser.get_screenshot_as_png()
#         screenshot = Image.open(BytesIO(screenshot))
#         return screenshot
#
#     def get_position(self):
#         '''
#         获取验证码位置
#         :return: 位置元组
#         '''
#         img = self.wait.until(EC.presence_of_element_located((By.CLASS_NAME,'geetest_canvas_bg geetest_absolute')))
#         time.sleep(2)
#         location = img.location
#         size = img.size
#         top, bottom = location['y'], location['y'] + size['height']
#         left, right = location['x'], location['x'] + size['width']
#         return (top, bottom, left, right)
#
#     def get_slider(self):
#         '''
#         获取滑块
#         :return: 滑块对象
#         '''
#         slider = self.wait.until(EC.element_to_be_clickable((By.CLASS_NAME,'geetest_slider_button')))
#         return slider
#
#     def get_geetest_image(self,name='captcha.png'):
#         '''
#         获取验证码图片
#         :return: 图片对象
#         '''
#         top, bottom, left, right = self.get_position()
#         print('验证码位置',top, bottom, left, right)
#         screenshot = self.get_screenshot()
#         captcha = screenshot.crop((left, top, right, bottom))
#         captcha.save(name)
#         return captcha
#
#     def delete_style(self):
#         '''
#         执行js脚本，获取无滑块图
#         :return None
#         '''
#         js = 'document.querySelectorAll("canvas")[2].style=""'
#         self.browser.execute_script(js)
#
#
#
#     def is_pixel_equal(self, img1, img2, x, y):
#         '''
#         判断两个像素是否相同
#         :param img1: 不带缺口图片
#         :param img2: 带缺口图
#         :param x: 位置x
#         :param y: 位置y
#         :return: 像素是否相同
#         '''
#         # 取两个图片的像素点
#         pix1 = img1.load()[x, y]
#         pix2 = img2.load()[x, y]
#         threshold = 60
#         if abs(pix1[0] - pix2[0]) < threshold \
#         and abs(pix1[1] - pix2[1]) < threshold \
#         and abs(pix1[2] - pix2[2]) < threshold:
#             return True
#         else:
#             return False
#
#
#     def get_gap(self, img1, img2):
#         '''
#         获取缺口偏移量
#         :param img1: 不带缺口图片
#         :param img2: 带缺口图
#         :return 缺口位置
#         '''
#         left = 60
#         for i in range(left, img1.size[0]):
#             for j in range(img1.size[1]):
#                 if not self.is_pixel_equal(img1, img2, i, j):
#                     left = i
#                     return left
#         return left
#
#     def get_track(self, distance):
#         '''
#         根据偏移量获取移动轨迹
#         :param distance: 偏移量
#         :return: 移动轨迹
#         '''
#         #移动轨迹
#         track = []
#         #当前位移
#         current = 0
#         #减速阈值
#         mid = distance * 3 / 5
#         #计算间隔
#         t = 0.2
#         #初速度
#         v = 0
#         #滑超过过一段距离
#         distance += 15
#         while current < distance:
#             if current < mid:
#                 #加速度为正
#                 a = 1
#             else:
#                 #加速度为负
#                 a = -0.5
#             #初速度 v0
#             v0 = v
#             #当前速度 v
#             v = v0 + a * t
#             #移动距离 move-->x
#             move = v0 * t + 1 / 2 * a * t * t
#             #当前位移
#             current += move
#             #加入轨迹
#             track.append(round(move))
#         return track
#     # def get_track(self, distance):
#     #     """
#     #     根据偏移量获取移动轨迹
#     #     :param distance: 偏移量
#     #     :return: 移动轨迹
#     #     """
#     #     # 移动轨迹
#     #     track = []
#     #     # 当前位移
#     #     current = 0
#     #     # 减速阈值
#     #     mid = distance * 4 / 5
#     #     # 计算间隔
#     #     t = 0.2
#     #     # 初速度
#     #     v = 0
#
#     #     while current < distance:
#     #         if current < mid:
#     #             # 加速度为正2
#     #             a = 2
#     #         else:
#     #             # 加速度为负3
#     #             a = -3
#     #         # 初速度v0
#     #         v0 = v
#     #         # 当前速度v = v0 + at
#     #         v = v0 + a * t
#     #         # 移动距离x = v0t + 1/2 * a * t^2
#     #         move = v0 * t + 1 / 2 * a * t * t
#     #         # 当前位移
#     #         current += move
#     #         # 加入轨迹
#     #         track.append(round(move))
#     #     return track
#
#     def shake_mouse(self):
#         '''
#         模拟人手释放鼠标时的抖动
#         :return: None
#         '''
#         ActionChains(self.browser).move_by_offset(xoffset=-3, yoffset=0).perform()
#         ActionChains(self.browser).move_by_offset(xoffset=3, yoffset=0).perform()
#
#     def move_to_gap(self, slider, tracks):
#         '''
#         拖动滑块到缺口处
#         :param slider: 滑块
#         :param tracks: 轨迹
#         :return
#         '''
#         back_tracks = [-1, -1, -2, -2, -3, -2, -2, -1, -1]
#         ActionChains(self.browser).click_and_hold(slider).perform()
#         #正向
#         for x in tracks:
#             ActionChains(self.browser).move_by_offset(xoffset=x, yoffset=0).perform()
#         time.sleep(0.5)
#         #逆向
#         for x in back_tracks:
#             ActionChains(self.browser).move_by_offset(xoffset=x, yoffset=0).perform()
#         #模拟抖动
#         self.shake_mouse()
#         time.sleep(0.5)
#         ActionChains(self.browser).release().perform()
#
#
#     def crack(self):
#         try:
#             #打开网页
#             self.open()
#             #转换验证方式，点击认证按钮
#             s_button = self.change_to_slide()
#             time.sleep(1)
#             s_button.click()
#             g_button = self.get_geetest_button()
#             g_button.click()
#             #确认图片加载完成
#             self.wait_pic()
#             #获取滑块
#             slider = self.get_slider()
#             print(111)
#             #获取带缺口的验证码图片
#             image1 = self.get_geetest_image('captcha1.png')
#             image1.show()
#             self.delete_style()
#             image2 = self.get_geetest_image('captcha2.png')
#             image1.show()
#             gap = self.get_gap(image1,image2)
#             print('缺口位置',gap)
#             gap -= BORDER
#             track = self.get_track(gap)
#             self.move_to_gap(slider, track)
#             success =  self.wait.until(
#                 EC.text_to_be_present_in_element((By.CLASS_NAME,'geetest_success_radar_tip_content'),'验证成功')
#             )
#             print(success)
#             time.sleep(5)
#             self.close()
#         except:
#             #print'repr(e):\t', repr(e)
#             print('Failed-Retry')
#             self.crack()
#
#
#
# if __name__ == '__main__':
#     crack = CrackGeetest()
#     crack.crack()
    '''



def get_elementid_location(browser):
    try:
        time.sleep(2)
        elecaptcha = browser.find_element_by_class_name('geetest_widget')
        elecaptcha_head = browser.find_element_by_class_name('geetest_head').size
        elecaptcha_table = browser.find_element_by_class_name('geetest_table_box').size
        captcha_location = elecaptcha.location
        captcha_size = elecaptcha.size
        captcha_size["height"] = elecaptcha_head['height'] + elecaptcha_table['height']
        s = platform.system()
        if u"Darwin" in s:
            left = int(captcha_location['x']) * 2
            top = int(captcha_location['y']) * 2
            right = int(captcha_location['x'] + captcha_size['width']) * 2
            bottom = int(captcha_location['y'] + captcha_size['height']) * 2
        else:
            left = int(captcha_location['x'])
            top = int(captcha_location['y'])
            right = int(captcha_location['x'] + captcha_size['width'])
            bottom = int(captcha_location['y'] + captcha_size['height'])
        picuniqid = str(uuid.uuid4())
        screenshot_path = os.path.join(IMAGE_DATA_FILE_PATH, picuniqid + "_screenshot" + ".png")
        browser.get_screenshot_as_file(screenshot_path)
        # 存储验证码图
        captcha_path = os.path.join(IMAGE_DATA_FILE_PATH, picuniqid + "_captcha" + ".png")
        im = Image.open(screenshot_path)
        im = im.crop((left, top, right, bottom))
        im = im.resize((captcha_size.get('width'), captcha_size.get('height')), Image.ANTIALIAS)
        im.save(captcha_path)
        # 识别验证码

        res = base64_api('datagrand', 'datagrand@', captcha_path)
        positions = [x_y.split(',') for x_y in res.split("|")]
        return captcha_location.get('x'), captcha_location.get('y'), positions
    except Exception as e:
        pass


def click_with_captcha(browser, area_position, positions):
    for p in positions:
        left_p, top_p = area_position[0], area_position[1]
        x_p, y_p = int(left_p) + int(p[0]), int(top_p) + int(p[1])
        time.sleep(1)
        ActionChains(browser).move_by_offset(x_p, y_p).perform()
        ActionChains(browser).click().perform()
        time.sleep(1)
        ActionChains(browser).move_by_offset(-x_p, -y_p).perform()
    return browser



def start_login():
    caps = DesiredCapabilities.CHROME
    caps['loggingPrefs'] = {'performance': 'ALL'}
    driver_option = webdriver.ChromeOptions()
    driver_option.add_experimental_option('useAutomationExtension', False)
    browser = webdriver.Chrome(chrome_options=driver_option, desired_capabilities=caps)
    browser.execute_cdp_cmd("Page.addScriptToEvaluateOnNewDocument", {
        "source": """
    Object.defineProperty(navigator, 'webdriver', {
      get: () => undefined
    })
  """
    })
    browser.set_window_size(1500, 900)
    browser.implicitly_wait(20)
    browser.get('http://www.gsxt.gov.cn/socialuser-use-login.html')
    username_input = browser.find_element_by_xpath('//*[@id="UserName"]')
    passwd_input = browser.find_element_by_xpath('//*[@id="gsxtp"]')
    login_button = browser.find_element_by_xpath('//*[@id="btn_login"]')
    username_input.send_keys("")
    time.sleep(0.5)
    passwd_input.send_keys("")
    time.sleep(0.5)
    login_button.click()
    max_retry = 5
    while max_retry:
        try:
            time.sleep(2)
            browser.find_element_by_class_name('geetest_widget')
            x, y, positions = get_elementid_location(browser)
            click_with_captcha(browser, [x, y], positions)
            commit_button = browser.find_element_by_class_name('geetest_commit_tip')
            time.sleep(1)
            commit_button.click()
            # send_jiyan_captcha_ref()
            max_retry -= 1
        except Exception as e:
            break
    return browser.find_element_by_class_name('ucsList')

# =========================================           ======================================= #

def get_elementid_location(browser):
    try:
        time.sleep(1)
        elecaptcha = browser.find_element_by_xpath("//div[contains(@class,'geetest_slicebg')]")
        captcha_location = elecaptcha.location
        captcha_size = elecaptcha.size
        s = platform.system()
        if u"Darwin" in s:
            left = int(captcha_location['x']) * 2
            top = int(captcha_location['y']) * 2
            right = int(captcha_location['x'] + captcha_size['width']) * 2
            bottom = int(captcha_location['y'] + captcha_size['height']) * 2
        else:
            left = int(captcha_location['x'])
            top = int(captcha_location['y'])
            right = int(captcha_location['x'] + captcha_size['width'])
            bottom = int(captcha_location['y'] + captcha_size['height'])
        picuniqid = str(uuid.uuid4())
        screenshot_path = os.path.join(IMAGE_DATA_FILE_PATH, '_screenshot' + picuniqid + ".png")
        browser.get_screenshot_as_file(screenshot_path)
        path = os.path.join(IMAGE_DATA_FILE_PATH, '_captcha' + picuniqid + ".png")
        im = Image.open(screenshot_path)
        im = im.crop((left, top, right, bottom))
        im = im.resize((captcha_size.get('width'), captcha_size.get('height')), Image.ANTIALIAS)
        im.save(path)
        photo = Image.open(path)
        # 模式L”为灰色图像，它的每个像素用8个bit表示，0表示黑，255表示白，其他数字表示不同的灰度。
        Img = photo.convert('L')
        threshold = 100
        table = []
        for i in range(256):
            if i < threshold:
                table.append(0)
            else:
                table.append(1)
        # 图片二值化
        photo = Img.point(table, '1')
        photo.save(os.path.join(IMAGE_DATA_FILE_PATH, 'convert' + path.split('/')[-1]))
        width = 45
        height = 40
        res_list = dict()
        for x in range(width, photo.size[0] - width):
            for y in range(0, photo.size[1] - height):
                white = 0
                black = 0
                im = photo.crop((x, y, width + x, height + y))
                im_array = im.load()
                for _x in range(0, width):
                    for _y in range(0, height):
                        if im_array[_x, _y] == 1:
                            white += 1
                        else:
                            black += 1
                        res_list[black] = [x, y]
        res_key = max(res_list)
        return res_list[res_key]
    except Exception as e:
        print(e)


def get_track(distance):
    """
    根据偏移量获取移动轨迹
    :param distance: 偏移量
    :return: 移动轨迹
    """
    track = []
    current = 0
    mid = distance * 3 / 5
    t = 1
    v = 0
    while current < distance:
        if current < mid:
            a = 2
        else:
            a = -3
        v0 = v
        move = v0 * t + 0.5 * a * (t ** 2)
        current += move
        v = v0 + a * t
        track.append(round(move))
    track.append(distance - sum(track))
    return track


def login_gsxt():
    try:
        caps = DesiredCapabilities.CHROME
        caps['loggingPrefs'] = {'performance': 'ALL'}
        driver_option = webdriver.ChromeOptions()
        driver_option.add_experimental_option('useAutomationExtension', False)
        browser = webdriver.Chrome(options=driver_option, desired_capabilities=caps)
        browser.execute_cdp_cmd("Page.addScriptToEvaluateOnNewDocument", {
            "source": """
            Object.defineProperty(navigator, 'webdriver', {
              get: () => undefined
            })
          """
        })
        browser.set_window_size(1500, 900)
        browser.implicitly_wait(20)
        browser.get('http://www.gsxt.gov.cn/index.html')
        keyword_input = browser.find_element_by_xpath('//*[@id="keyword"]')
        search_btn = browser.find_element_by_xpath('//*[@id="btn_query"]')
        keyword_input.send_keys("youyisi")
        time.sleep(2)
        search_btn.click()
        x, y = get_elementid_location(browser)
        x = x - 9
        slider = browser.find_element_by_xpath("//div[@class='geetest_slider_button']")
        distance = get_track(x)
        print(distance)
        print(sum(distance))
        ActionChains(browser).click_and_hold(slider).perform()
        time.sleep(0.5)
        offset_y = - 1
        index = 0
        for x in distance:
            ActionChains(browser).move_by_offset(xoffset=x, yoffset=random.randint(2, 5) * offset_y ** index).perform()
            index += 1
        time.sleep(random.uniform(0.2, 0.5))
        ActionChains(browser).release().perform()

        time.sleep(60)
    except Exception as e:
        print(e)
        return None


if __name__ == '__main__':
    login_gsxt()
    start_login()
