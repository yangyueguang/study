# coding! utf-8
import json
import redis
import pymongo
import pymysql
import requests


class YYPipeline(object):
    def __init__(self):
        self.se = requests.session()
        self.se.headers = {
            'Accept': '*/*',
            'Accept-Encoding': 'gzip, deflate',
            'Accept-Language': 'en-US,en;q=0.9,zh-CN;q=0.8,zh;q=0.7',
            'Connection': 'keep-alive',
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36',
        }

    def process_item(self, item, spider):
        if True:
            return item
        else:
            return None

    def close_spider(self, spider):
        print('closed')


class MongoDB_pipline(object):
    def process_item(self, item, spider):
        redis_cli = redis.Redis(host="127.0.0.1", port=6379, db="0")
        mongo_cli = pymongo.MongoClient(host="127.0.0.1", port=27017)
        dbname = mongo_cli["student"]
        sheet_name = dbname["beijing"]
        offset = 0
        while True:
            source, data = redis_cli.blpop("yy:items")
            offset += 1
            data = json.loads(data)
            sheet_name.insert(data)
            print(offset)


class MySQL_pipline(object):
    def process_item(self, item, spider):
        redis_cli = redis.Redis(host="127.0.0.1", port=6379, db=0)
        mysql_cli = pymysql.connect(host="127.0.0.1", port=3306, user="admin", passwd="123456", db="student")
        offset = 0
        while True:
            source, data = redis_cli.blpop("yy:items")
            item = json.loads(data)
            sql = "insert into beijing (username, age, header_url) values (%s, %s, %s)"
            try:
                cursor = mysql_cli.cursor()
                cursor.execute(sql, [item['username'], item['age'], item['header_url']])
                mysql_cli.commit()
                cursor.close()
                offset += 1
                print(offset)
            except:
                pass

