#coding: utf-8
import json
import mitmproxy.http
from mitmproxy import ctx
from mitmproxy import options
from mitmproxy import proxy
from mitmproxy.tools.dump import DumpMaster


class Joker:
    def request(self, flow: mitmproxy.http.HTTPFlow):
        url = flow.request.url
        if "cdn.com" in url:
            flow.response = mitmproxy.http.HTTPResponse.make(status_code=404)

    def response(self, flow: mitmproxy.http.HTTPFlow):
        if flow.request.url.startswith('http'):
            text = flow.response.text
            print(json.loads(text))


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
