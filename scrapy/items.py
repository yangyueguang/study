# coding! utf-8
import scrapy


class YYItem(scrapy.Item):
    name = scrapy.Field()
    unit = scrapy.Field()
    time = scrapy.Field()
    address = scrapy.Field()
    sources = scrapy.Field()
