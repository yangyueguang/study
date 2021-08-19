# coding=utf-8
import yagmail
import time
import threading
import itchat
import schedule
from PIL import Image


def error_call():
    yag = yagmail.SMTP(user='xxxx@139.com', password='xxx', host='smtp.139.com')
    yag.send(to=["xxxxx@139.com"], subject='微信机器人掉线通知', contents=['微信机器人掉线,请重启'])
    exit(0)


def doLove():
    for girl in [itchat.search_friends(remarkName=name)[0] for name in ['家人 晴儿']]:
        girl.send_msg('有意思')


def run_threaded(job_func):
    job_thread = threading.Thread(target=job_func)
    job_thread.start()


def task():
    schedule.every().day.at('09:00').do(run_threaded, doLove)
    schedule.every(10).seconds.do(run_threaded, doLove)
    while True:
        schedule.run_pending()
        time.sleep(1)


@itchat.msg_register(itchat.content.TEXT, isFriendChat=True)
def text_reply(msg):
    print("文本消息:{}".format(msg))


@itchat.msg_register(itchat.content.FRIENDS)
def add_Friend(msg):
    print("添加好友")
    print(msg)
    itchat.add_friend(**msg['Text'])


@itchat.msg_register(itchat.content.PICTURE, isFriendChat=True)
def picture_reply(msg):
    print("接收到图片:")


def qrCallback(uuid, status, qrcode):
    if status == '0':
        Image.open(qrcode)
        # with open('qrcode.jpg', 'wb') as f:
        #     f.write(qrcode)
        #     f.close()
        # import subprocess
        # subprocess.call(['open', 'qrcode.jpg'])

    elif status == '200':
        print('login success')


if __name__ == "__main__":
    itchat.auto_login(hotReload=True, qrCallback=qrCallback, exitCallback=error_call)
    list_group = itchat.get_chatrooms()
    for group in list_group:
        print(group["NickName"])
    group = itchat.search_chatrooms(name='家')[0]
    memberList = itchat.update_chatroom(group['UserName'], detailedMember=True)
    for member in memberList["MemberList"]:
        print(member)
    threading.Thread(target=task).start()
    itchat.run()
