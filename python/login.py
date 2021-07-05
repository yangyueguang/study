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
