'''
撩妹机器人
1、每天早上定时发爱心
2、
'''

import re
import time
import datetime
import random
import threading
import requests
import itchat
from itchat.content import *
import schedule
from flask import Flask, make_response
from config import poems, moon_and_sixpence, love1, love2

love = love1 + love2
schedule_plan = {
    "love": {"time": "22:{}".format(random.choice(range(25, 35))), "todo": "doLove"},
    "wake": {"time": "7:{}".format(random.choice(range(20, 38))), "todo": "doWakeup"},
    "joke": {"time": "8:{}".format(random.choice(range(20, 35))), "todo": "sendXiaohua"},
}
schedule_weekend_plan = {
    "love": {"time": "22:{}".format(random.choice(range(25, 35))), "todo": "doLove"},
    # "wake": {"time": "9:{}".format(random.choice(range(20, 38))), "todo": "doWakeup"},
    "joke": {"time": "9:{}".format(random.choice(range(35, 50))), "todo": "sendXiaohua"},
}
schedule_flag = 1

KEYS = ['241b5a1059b04c898d00d197522a917c', 'ca6acaabfd7a40edb0b42a7bea233dc7', '85c0d048714b43e6bed1b0c966c20cbe']
apiUrl = 'http://www.tuling123.com/openapi/api'
data = {
    'key': random.choice(KEYS),
    'info': "笑话",
    'userid': 'wechat-robot',
}

qrSource = ''


# 计划时间表：时间-任务

def start_flask():
    flaskApp = Flask('itchat登录二维码')

    @flaskApp.route('/')
    def return_qr():
        if len(qrSource) < 100:
            return qrSource
        else:
            response = make_response(qrSource)
            response.headers['Content-Type'] = 'image/jpeg'
            return response

    flaskApp.run(host="0.0.0.0", )
    # flaskApp.run()


def start_falsk():
    flaskThread = threading.Thread(target=start_flask)
    flaskThread.setDaemon(True)
    flaskThread.start()


def qrCallback(uuid, status, qrcode):
    if status == '0':
        global qrSource
        qrSource = qrcode
        # print(qrSource)
    elif status == '200':
        qrSource = 'Logged in!'
    elif status == '201':
        qrSource = 'Confirm'


def ec():
    import os
    import yagmail
    print("机器人退出时间：{}".format(datetime.datetime.now()))
    # print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>") #HT
    yag = yagmail.SMTP(user='xxxx@139.com', password='xxx', host='smtp.139.com')
    body = '{}  微信机器人掉线,请重启'.format(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
    yag.send(to=["xxxxx@139.com"], subject='微信机器人掉线通知', contents=[body])
    # print("<<<<<<<<<<<<<<<<<<<<<<")# HT
    file_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "itchat.pkl")
    if os.path.isfile(file_dir):
        os.remove(file_dir)
    os._exit(0)


word_faces = ["✪ω✪", '✷(ꇐ‿ꇐ)✷', "｡◕‿◕｡", "(๑￫ܫ￩)", "(-人-) [拜佛] ", "(*/ω＼*)",
              " ( *^-^)ρ(^0^* )", "(●'◡'●)ﾉ♥", "( ◔ ڼ ◔ )", "( ´◔ ‸◔`)", "(・ω< )★", "(♥◠‿◠)ﾉ",
              '（*＾-＾*）', "(｡◕ˇ∀ˇ◕）", "✪ω✪", "~Ⴚ(●ტ●)Ⴢ~", "(๑◕ܫ￩๑)b",
              "v( ^-^(ё_ёゝ", "(✿◡‿◡)", "o(￣▽￣)ｄ",
              "٩(๑´0`๑)۶",
              "( ´◔ ‸◔`) ", "๑乛◡乛๑ ", "♥(｡￫v￩｡)♥",
              "(•‾̑⌣‾̑•)✧˖°", " (｀◕‸◕´+) ",
              "(oﾟωﾟo)", " (*′∇`*)", "(￣y▽￣)~*", "------\(˙<>˙)/------",
              "（＾∀＾）", "(•̀ᴗ•́)و ̑̑ "
              ]




# girl_names = ["你会"] #测试


def get_moon_six():
    text_place = random.choice(range(0, len(moon_and_sixpence) - 1))
    text = moon_and_sixpence[text_place]
    text = text.replace("。", "。\n")
    text = text.replace("；", "；\n")
    # text = text.replace("\r", "\n")
    text = text.replace("-", "")
    text = text.replace("/", "，")
    text = re.sub("“ *”", "“ \n”", text, count=10)
    # print(text)
    return text


def get_love():
    text_place = random.choice(range(0, len(love) - 1))
    text = love[text_place]
    text = text.replace("。", "。\n")
    text = text.replace("；", "；\n")
    # text = text.replace("\r", "\n")
    text = text.replace("-", "")
    text = text.replace("/", "，")
    text = re.sub("“ *”", "“ \n”", text, count=10)
    # text = text.replace("”“", "” \n“")
    # text = text.replace("” “", "” \n“")

    # print(text)
    return text


def get_girls():
    u_objs = [itchat.search_friends(remarkName=name)[0] for name in girl_names]
    return u_objs


def sendXiaohua():
    try:
        r = requests.post(apiUrl, data=data).json()
        msg = r['text']
        # print(msg)
    except:
        # print("失败笑话")
        return "今日没笑话"

    for girl in get_girls():
        girl.send_msg(msg)
    # time.sleep(60)
    # for girl in get_girls():
    #     girl.send_msg(" 嘿嘿   ")


def doLove():
    day = datetime.datetime.now().weekday() + 1
    if day in [1, 3, 5, 7]:
        schedule_flag = 1
    else:
        schedule_flag = 3

    if schedule_flag == 1:
        msg = random.choice(poems)
    elif schedule_flag == 2:
        msg = get_moon_six()
    elif schedule_flag == 3:
        msg = get_love()
    else:
        msg = "it is wrong ,call me"
    for girl in get_girls():
        girl.send_msg(msg)


def doWakeup():
    for girl in get_girls():
        girl.send_msg('''起床啦  起床啦   {}'''.format(random.choice(word_faces)))


def run_threaded(job_func):
    job_thread = threading.Thread(target=job_func)
    job_thread.start()


def task():
    for task in schedule_plan.keys():
        # schedule.every().day.at(schedule_plan[task]["time"]).do(run_threaded, eval(schedule_plan[task]["todo"]))
        schedule.every().monday.at(schedule_plan[task]["time"]).do(run_threaded, eval(schedule_plan[task]["todo"]))
        schedule.every().tuesday.at(schedule_plan[task]["time"]).do(run_threaded, eval(schedule_plan[task]["todo"]))
        schedule.every().wednesday.at(schedule_plan[task]["time"]).do(run_threaded, eval(schedule_plan[task]["todo"]))
        schedule.every().thursday.at(schedule_plan[task]["time"]).do(run_threaded, eval(schedule_plan[task]["todo"]))
        schedule.every().friday.at(schedule_plan[task]["time"]).do(run_threaded, eval(schedule_plan[task]["todo"]))
    for task in schedule_weekend_plan.keys():
        schedule.every().saturday.at(schedule_weekend_plan[task]["time"]).do(run_threaded,
                                                                             eval(schedule_weekend_plan[task]["todo"]))
        schedule.every().sunday.at(schedule_weekend_plan[task]["time"]).do(run_threaded,
                                                                           eval(schedule_weekend_plan[task]["todo"]))
    # schedule.every(10).seconds.do(doLove)# 测试

    while True:
        schedule.run_pending()
        time.sleep(1)


def get_groups():
    list_group = itchat.get_chatrooms()
    print(list_group)
    for group in list_group:
        print(group["NickName"])


def get_group_youzheng():
    youzhen_members = {
        "man": [],
        "girl": []
    }
    group = itchat.search_chatrooms(name='2018.05.20xxxx铭心')[0]
    print(group)
    print("群聊的名称：{}".format(group["NickName"]))
    # 更新群成员列表
    memberList = itchat.update_chatroom(group['UserName'], detailedMember=True)
    print(memberList["MemberList"])
    print("打印群成员信息")
    for member in memberList["MemberList"]:
        # print(member)
        # print("群友的昵称：{}，备注:{} ,性别：{}".format(member["NickName"], member["DisplayName"],
        #                                      "男" if member["Sex"] == 1 else "女"))
        if member["Sex"] == 1:
            youzhen_members["man"].append(member)
        else:
            youzhen_members["girl"].append(member)
    print("邮政群的女生们，数量：{}".format(len(youzhen_members["girl"])))
    for girl in youzhen_members["girl"]:
        # if girl["NickName"] in ["xxx"]:
        #     print(girl)
        # 我的好友
        # if girl["ContactFlag"] != 0:
        #     print("昵称：{} ,   群昵称:{} ,   性别：{} ,   备注：{}".format(girl["NickName"], girl["DisplayName"],
        #                                               "男" if girl["Sex"] == 1 else "女",girl["RemarkName"]))
        # print(girl["ContactFlag"])
        print("昵称：{} ,   群昵称:{} ,   性别：{}".format(girl["NickName"], girl["DisplayName"],
                                                  "男" if girl["Sex"] == 1 else "女"))
    print()
    print()
    print("邮政群的男士们，数量：{}".format(len(youzhen_members["man"])))
    for man in youzhen_members["man"]:
        # 我的好友
        # if man["ContactFlag"] != 0:
        #     print("昵称：{} ,   群昵称:{} ,   性别：{} ,   备注：{}".format(man["NickName"], man["DisplayName"],
        #                                               "男" if man["Sex"] == 1 else "女",girl["RemarkName"]))
        print("昵称：{} ,   群昵称:{} ,   性别：{}".format(man["NickName"], man["DisplayName"],
                                                  "男" if man["Sex"] == 1 else "女"))


# 这里是我们在“1. 实现微信消息的获取”中已经用到过的同样的注册方法
@itchat.msg_register(TEXT, isFriendChat=True)
def text_reply(msg):
    print("文本消息:{}".format(msg))



@itchat.msg_register(FRIENDS)
def add_Friend(msg):
    print("添加好友")
    # print(msg)
    # print(msg['RecommendInfo'])
    itchat.add_friend(**msg['Text'])
    # itchat.send_msg("大家好，我是squirrel")
    # time.sleep(5)


@itchat.msg_register(PICTURE, isFriendChat=True)
def picture_reply(msg):
    print("接收到图片:")


def run():
    try:
        global qrSource
        start_falsk()
        itchat.auto_login(hotReload=True, qrCallback=qrCallback, exitCallback=ec)
        qrSource = "已登录"
        t1 = threading.Thread(target=task)
        t1.start()
        itchat.run()
    except Exception as e:
        print(e)


if __name__ == "__main__":
    run()
