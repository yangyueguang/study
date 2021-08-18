from collections import OrderedDict
import pandas as pd
import subprocess
import sys

from flask import Flask
from flask import request
app = Flask(__name__)
# from werkzeug import ImmutableMultiDict
# from collections import ImmutableMultiDict
@app.route("/")
def hello():
    return "Hello World!"

if __name__ == "__main__":
    app.run()


# p = subprocess.Popen("""/sbin/ifconfig en0 | awk '/inet /{print $2}'""", shell=True, stdout=subprocess.PIPE)
# a = p.communicate()[0].decode('utf8')
# ip = a.strip()
#
# p = subprocess.Popen("""/sbin/ifconfig en0 | awk '/ether/{print $2}'""", shell=True, stdout=subprocess.PIPE)
# a = p.communicate()[0].decode('utf8')
# mac = a.strip()
#
#
# p = subprocess.Popen('/usr/sbin/system_profiler SPNVMeDataType SPNetworkLocationDataType SPHardwareDataType', shell=True, stdout=subprocess.PIPE)
# a = p.communicate()[0].decode('utf8')
# b = a.split('\n')
#
# res = OrderedDict([])
#
# def ff(s):
#     x, y = s.split(':')
#     return y.strip()
#
# for i in b:
#     j = i.strip()
#     if j.startswith('Model Identifier'):
#         res['型号'] = ff(j)
#     if j.startswith('Serial Number:'):
#         res['硬盘序列号'] = ff(j)
#     if j.startswith('Serial Number (system)'):
#         sn = ff(j)
#
#
# cmd = """curl -s https://support-sp.apple.com/sp/product?cc=%s""" %(sn[8:])
# print(cmd)
# p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
# a = p.communicate()[0].decode('utf8')
# print(a)
# name = a.strip().split('<configCode>')[1].split('</configCode>')[0]
# print(name)
# dtp = name.split(',')[1].strip()
#
# f = open('/var/log/install.log')
# line = f.readline()
# dts = line.split()[0]
#
# res['启用时间（首次使用该设备时间）'] = dts
# res['Mac:出厂日期'] = dtp
# print(res)
#
# df = pd.DataFrame.from_dict([res])
# df.to_excel('info.xlsx')
#
