import asyncio
from pymongo import MongoClient
client = MongoClient('localhost', 27017)
# client = MongoClient('mongodb://localhost:27017')
# client = MongoClient('mongodb://username:password@localhost:27017/dbname')
# 获取数据库
db = client.zfdb
collection = db['test']
loop = asyncio.get_event_loop()

async def do_find_one():
    n = await db.test_collection.count_documents({'name': {'$gt': 1000}})
    document = await db.test_collection.find_one({'name': 'zone'})
    print(document)
loop.run_until_complete(do_find_one())

def main():
    db = client.zfdb
    test = db.test
    # 增加一条记录
    person = {'name': 'zone', 'sex': 'boy'}
    res = test.insert_one(person)
    persons = [{'name': 'zone', 'sex': 'boy'}, {'name': 'zone1', 'sex': 'boy1'}]
    res = test.insert_many(persons)
    res = test.delete_one({'name': 'zone'})
    res = test.delete_many({'name': 'zone'})
    res = test.update_one({'name': 'zone'}, {'$set': {'sex': 'girl girl'}})
    print(res.matched_count)
    test.update_many({'name': 'zone'}, {'$set': {'sex': 'girl girl'}})
    print(test.find())
    print(test.find({"sex": "boy"}).sort("name"))
    # 聚合查找
    aggs = [
        {"$match": {"$or": [{"field1": {"$regex": "regex_str"}}, {"field2": {"$regex": "regex_str"}}]}},  # 正则匹配字段
        {"$project": {"field3": 1, "field4": 1}},  # 筛选字段
        {"$group": {"_id": {"field3": "$field3", "field4": "$field4"}, "count": {"$sum": 1}}},  # 聚合操作
    ]
    result = test.aggregate(pipeline=aggs)
    print(result)
