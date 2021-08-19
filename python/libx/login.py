import os
import platform
import random
import time
import uuid
import json
import requests
import base64
import pytesseract
from PIL import Image
from io import BytesIO
from sys import version_info
from selenium import webdriver
from selenium.webdriver import ActionChains
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities


# 根据偏移量获取移动轨迹
def get_track(distance):
    track = []
    current = v = 0
    dt = 0.2
    while current < distance:
        a = 2 if current < distance * 4 / 5 else -3
        v = v + a * dt
        move = v * dt + 1 / 2 * a * dt * dt
        current += move
        track.append(round(move))
    return track


def get_text_from_img(image_name):
    img = Image.open(image_name).convert('L')
    pixels = img.load()
    for x in range(img.width):
        for y in range(img.height):
            pixels[x, y] = 255 if pixels[x, y] > 127 else 0
    return pytesseract.image_to_string(img, lang='eng', config='')


def get_elementid_location(browser):
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
    screenshot_path = os.path.join('./data', '_screenshot' + picuniqid + ".png")
    browser.get_screenshot_as_file(screenshot_path)
    path = os.path.join('./data', '_captcha' + picuniqid + ".png")
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
    photo.save(os.path.join('./data', 'convert' + path.split('/')[-1]))
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


class CrackGeetest():
    def __init__(self):
        self.url = 'http://ha.gsxt.gov.cn/index.html'
        self.browser = webdriver.Chrome()
        self.wait = WebDriverWait(self.browser, 20)

    def __del__(self):
        self.browser.close()

    def close(self):
        self.browser.close()
        self.browser.quit()

    def get_screenshot(self):
        screenshot = self.browser.get_screenshot_as_png()
        screenshot = Image.open(BytesIO(screenshot))
        return screenshot

    def get_gap(self, image1, image2):
        left = 60
        for i in range(left, image1.size[0]):
            for j in range(image1.size[1]):
                p1 = image1.load()[i, j]
                p2 = image2.load()[i, j]
                gap = 60
                if not (abs(p1[0] - p2[0]) < gap and abs(p1[1] - p2[1]) < gap and abs(p1[2] - p2[2]) < gap):
                    left = i
                    return left
        return left

    def crack(self):
        self.browser.get(self.url)
        email = self.wait.until(EC.presence_of_element_located((By.ID, 'email')))
        password = self.wait.until(EC.presence_of_element_located((By.ID, 'password')))
        email.send_keys('2829969299@qq.com')
        password.send_keys('123456')
        image1 = self.get_geetest_image('captcha1.png')
        slider = self.wait.until(EC.element_to_be_clickable((By.CLASS_NAME, 'geetest_slider_button')))
        slider.click()
        image2 = self.get_geetest_image('captcha2.png')
        gap = self.get_gap(image1, image2)
        print('缺口位置', gap)
        track = get_track(gap)
        print('滑动轨迹', track)
        ActionChains(self.browser).click_and_hold(slider).perform()
        for x in track:
            ActionChains(self.browser).move_by_offset(xoffset=x, yoffset=0).perform()
        time.sleep(0.5)
        ActionChains(self.browser).move_by_offset(xoffset=-3, yoffset=0).perform()
        ActionChains(self.browser).move_by_offset(xoffset=3, yoffset=0).perform()
        ActionChains(self.browser).release().perform()
        success = self.wait.until(EC.text_to_be_present_in_element((By.CLASS_NAME, 'geetest_success_radar_tip_content'), '验证成功'))
        print(success)
        if success:
            submit = self.wait.until(EC.element_to_be_clickable((By.CLASS_NAME, 'login-btn')))
            submit.click()
            time.sleep(10)
        else:
            self.crack()

    # 获取验证码图片
    def get_geetest_image(self, name='captcha.png'):
        img = self.wait.until(EC.presence_of_element_located((By.CLASS_NAME, 'geetest_canvas_slice geetest_absolute')))
        time.sleep(2)
        location = img.location
        size = img.size
        top, bottom, left, right = location['y'], location['y'] + size['height'], location['x'], location['x'] + size[
            'width']
        print('验证码位置', top, bottom, left, right)
        screenshot = self.get_screenshot()
        captcha = screenshot.crop((left, top, right, bottom))
        captcha.save(name)
        return captcha

    def excuteJs(self, js):
        self.browser.execute_script(js)


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
            for p in positions:
                x_p, y_p = int(x) + int(p[0]), int(y) + int(p[1])
                time.sleep(1)
                ActionChains(browser).move_by_offset(x_p, y_p).perform()
                ActionChains(browser).click().perform()
                time.sleep(1)
                ActionChains(browser).move_by_offset(-x_p, -y_p).perform()
            commit_button = browser.find_element_by_class_name('geetest_commit_tip')
            time.sleep(1)
            commit_button.click()
            max_retry -= 1
        except Exception as e:
            break
    return browser.find_element_by_class_name('ucsList')


def login_gsxt():
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


if __name__ == '__main__':
    login_gsxt()
    start_login()
    crack = CrackGeetest()
    crack.crack()
