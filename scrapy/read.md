# scrapy爬虫
外面还有一个scrapy.cfg，配置的是这个文件夹
## require.txt
```text
numpy==1.18.0
openpyxl==3.0.2
redis==3.3.11
requests==2.22.0
Scrapy==1.8.0
scrapy-redis==0.6.8
urllib3==1.25.7
urlparser==0.1.2
selenium==3.141.0
PyMySQL==0.9.3
pymongo==3.10.1
```
## run.sh
```bash
scrapy_name='YY'
function all_run() {
  projects=(jincai zhongyang difang yidong liantong jianyu dongfang nanfang dianli cgzb center huobiao jundui jungong)
  for var in ${projects[@]}
  do
    echo $var
    scrapy crawl $var
  done
}

function run_all() {
    scrapy crawlall
}

function create() {
    scrapy startproject $scrapy_name
}

function run() {
    scrapy crawl $scrapy_name
}

function output_scrapy() {
    scrapy crawl $scrapy_name -o a.json
}

function output_requirs() {
    pip3 freeze > require.txt
}

function send() {
    python3 task.py
}
```

## debug scrapy
```python
import os
import sys
from scrapy.cmdline import execute
def debug_scrapy():
    scrapy_name = 'sun'
    sys.path.append(os.path.dirname(os.path.abspath(__file__)))
    execute(['scrapy', 'crawl', scrapy_name])
```

## 发送邮件
```python
# coding! utf-8
import smtplib
from email import encoders
from email.header import Header
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email.mime.multipart import MIMEMultipart
def send_mail():
    class conf:
        from_username = '2829969299@qq.com'
        from_email = '2829969299@qq.com'
        from_pwd = 'xwfwnmyzsygydhae'  # 这是邮箱设置里账户开启SMTP服务生成的密码
        to_email = ['2502666011@qq.com', '2430878895@qq.com']
        smtp_server = 'smtp.qq.com'
        smtp_port = 587  # 465
    att = MIMEText(open(conf.excel_file, 'rb').read(), "base64", "utf-8")
    att["Content-Type"] = "application/octet-stream"
    att["Content-Disposition"] = 'attachment; filename=%s' % str(os.path.split(conf.excel_file)[1])
    cont = MIMEText('这是邮件正文', 'plain', 'utf-8')
    # pic_name = 'abc.png'
    # pic = MIMEBase('image', 'png', filename=pic_name)
    # pic.add_header('Content-Disposition', 'attachment', filename=pic_name)
    # pic.add_header('Content-ID', '<0>')
    # pic.add_header('X-Attachment-Id', '0')
    # pic.set_payload(open('abc.png', 'rb').read())
    # encoders.encode_base64(pic)
    msg = MIMEMultipart()
    msg['Subject'] = Header("邮件标题", 'utf-8')
    msg['From'] = conf.from_email
    msg['To'] = ",".join(conf.to_email)
    msg.attach(att)
    msg.attach(cont)
    # msg.attach(att1)
    # msg.attach(mime)
    try:
        email = smtplib.SMTP(conf.smtp_server, conf.smtp_port)
        email.login(conf.from_username, conf.from_pwd)
        email.sendmail(conf.from_email, conf.to_email, msg.as_string())
    except Exception as err:
        print("邮件发送失败！%s" % err)
    else:
        print("邮件发送成功")
    finally:
        email.quit()
```
