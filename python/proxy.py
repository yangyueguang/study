#coding: utf-8
import re
import os
a = ''
res = re.split('\s', a)
for i, value in enumerate(res):
    if i > 0 and re.match('.*[a-zA-Z]+$', res[i-1]) and re.match('^[a-zA-Z]+.*', value):
       res[i] = ' ' + value
result = ''.join(res)
print(result)

import mitmproxy.http
from mitmproxy import ctx
import json
import configparser
from mitmproxy import options
from mitmproxy import proxy
from mitmproxy.tools.dump import DumpMaster

class Joker:

    def request(self, flow: mitmproxy.http.HTTPFlow):
        # 拦截请求
        url = flow.request.url
        if "sns-img-hw.xhscdn.com" in url or "img.xiaohongshu.com" in url:
            flow.response = mitmproxy.http.HTTPResponse.make(status_code=404)
            pass


    """
    拦截请求头信息
    def response(self,flow: mitmproxy.http.HTTPFlow):
        print("")
        print("=" * 50)
        # print("FOR: " + flow.request.url)
        print(flow.request.method + " " + flow.request.path + " " + flow.request.http_version)

        print("-" * 50 + "request headers:")
        for k, v in flow.request.headers.items():
            print("%-20s: %s" % (k.upper(), v))
        # 
        # print("-" * 50 + "response headers:")
        # for k, v in flow.response.headers.items():
        #     print("%-20s: %s" % (k.upper(), v))
    """

    def response(self, flow: mitmproxy.http.HTTPFlow):
        url_1 = 'https://www.xiaohongshu.com/api/sns/v5/note/'
        url_2 = 'https://www.xiaohongshu.com/api/sns/v9/search/notes?'
        if flow.request.url.startswith(url_1):
            text = flow.response.text
            infos = json.loads(text)
            datas = infos['data']['comments']
            for data in datas:
                print(data['content'])
                with open('comment.txt', 'a', encoding='utf-8') as f:
                    f.writelines(data['user']['nickname'] + ' ' + data['content'])
                    f.write('\n')
        if flow.request.url.startswith(url_2):
            text = flow.response.text
            infos = json.loads(text)
            datas = infos['data']['notes']
            for data in datas:
                print(data)
                with open('test.txt', 'a', encoding='utf-8') as f:
                    f.writelines(str(data))
                    f.write('\n')
                with open('url.txt', 'a', encoding='utf-8') as f:
                    f.writelines('https://www.xiaohongshu.com/discovery/item/' + data['id'])
                    f.write('\n')

def start():
    myaddon = Joker()
    opts = options.Options(listen_port=8080)
    pconf = proxy.config.ProxyConfig(opts)
    m = DumpMaster(opts)
    m.server = proxy.server.ProxyServer(pconf)
    m.addons.add(myaddon)
    try:
        m.run()
    except KeyboardInterrupt:
        m.shutdown()

if __name__ == '__main__':
      start()
