# coding! utf-8
import scrapy
import json
from project.items import YYItem
from scrapy_redis.spiders import RedisCrawlSpider
from scrapy_redis.spiders import RedisSpider
from scrapy.linkextractors import LinkExtractor
from scrapy.spiders import CrawlSpider, Rule


class Jincai_spider(scrapy.Spider):
    name = 'abc'
    offset = 0
    allowed_domains = ['www.cfcpn.com']
    # start_urls = ['http://www.cfcpn.com/jcw/noticeinfo/noticeInfo/dataNoticeList']
    base_url = 'http://www.cfcpn.com/jcw/sys/index/goUrl?url=modules/sys/login/detail&column=undefined&searchVal='
    def start_requests(self):
        url = 'http://www.cfcpn.com/jcw/noticeinfo/noticeInfo/dataNoticeList'
        for i in range(1, 5):
            yield scrapy.FormRequest(url=url, formdata={'noticeType': '1'}, callback=self.parse)

    def parse(self, response):
        res = json.loads(response.text)
        if res.get('result'):
            for each in res.get('rows'):
                item = YYItem()
                item['name'] = each['noticeTitle']
                yield item
            if self.offset < 5:
                self.offset += 1
            yield scrapy.Request(self.base_url + 'index_' + str(self.offset) + '.htm', callback=self.parse)


class Yidong_Spider(scrapy.Spider):
    name = 'yidong'
    allowed_domains = ['b2b.10086.cn']
    base_url = 'https://b2b.10086.cn/b2b/main/viewNoticeContent.html?noticeBean.id='
    custom_settings = {
        'DOWNLOADER_MIDDLEWARES': {
            'project.middlewares.RandomUserAgentDownloadMiddleware': 100,
            'project.middlewares.SeleniumDownloadMiddleware': 200
        }
    }

    def start_requests(self):
        url = 'https://b2b.10086.cn/b2b/main/listVendorNotice.html?noticeType=2'
        for i in range(1, 3):
            yield scrapy.Request(url, callback=self.parse, meta={'page': i}, dont_filter=True)

    def parse(self, response):
        items = response.xpath('//*[@id="searchResult"]/table/tbody/tr')
        for each in items[2:]:
            item = YYItem()
            item['name'] = each.xpath('.//td[3]/a/text()').extract()[0]
            yield item


# CrawlSpider 循环查找规则url的爬虫
class SunSpider(CrawlSpider):
    name = 'sun'
    allowed_domains = ['wz.sun0769.com']
    start_urls = ['http://wz.sun0769.com/index.php/question/questionType?type=4&page=0']
    # 规则意味着html里面所有的链接符合规则的会继续往里面爬取 callback是用来响应子爬取的网页解析
    rules = (
        Rule(LinkExtractor(allow=r'type=4&page=\d+'), follow=True, process_links='deal_links', process_request='deal_request'),
        Rule(LinkExtractor(allow=r'/html/question/\d+/\d+.shtml'), callback='parse_detail'),
    )

    def deal_links(self, links):
        for link in links:
            print(link.url)
            link.url = link.url.replace('?', '&').replace('Type&', 'Type?')
        return links

    def deal_request(self, request, response):
        print(request.url)
        request.headers['User-Agent'] = "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/5.0)"
        return request

    def parse_detail(self, response):
        item = YYItem()
        item['name'] = response.xpath('//span[@class="niae2_top"]/text()').extract()[0]
        item['unit'] = '采购单位'
        item['time'] = '2020-01-01 00:00'
        item['sources'] = self.name
        item['address'] = response.url
        yield item


class MySpider(RedisSpider):
    name = 'YY'
    #allowed_domains = ['youyuan.com']
    #start_urls = ['http://www.youyuan.com/find/beijing/mm18-25/advance-0-0-0-0-0-0-0/p1/']
    redis_key = "yyspider:start_urls"

    def __init__(self, *args, **kwargs):
        domain = kwargs.pop('domain', '')
        self.allowed_domains = filter(None, domain.split(','))
        super(YySpider, self).__init__(*args, **kwargs)

    def parse(self, response):
        print(response.text)
        item = YYItem()
        item['name'] = ''
        item['unit'] = ''
        item['time'] = '2020-01-01 00:00'
        item['address'] = ''
        item['sources'] = self.name
        yield item


class YySpider(RedisCrawlSpider):
    name = 'YY'
    #allowed_domains = ['youyuan.com']
    #start_urls = ['http://www.youyuan.com/find/beijing/mm18-25/advance-0-0-0-0-0-0-0/p1/']
    redis_key = "yyspider:start_urls"
    rules = (
        Rule(LinkExtractor(allow=(r"youyuan.com/find/beijing/mm18-25/advance-0-0-0-0-0-0-0/p\d+/"))),
        Rule(LinkExtractor(allow=(r"youyuan.com/\d+-profile/")), callback="parse_item"),
    )

    def __init__(self, *args, **kwargs):
        domain = kwargs.pop('domain', '')
        self.allowed_domains = filter(None, domain.split(','))
        super(YySpider, self).__init__(*args, **kwargs)

    def parse_item(self, response):
        print(response.text)
        item = YYItem()
        item['name'] = ''
        item['unit'] = ''
        item['time'] = '2020-01-01 00:00'
        item['address'] = ''
        item['sources'] = self.name
        yield item
