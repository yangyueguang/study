import motor
import asyncio
"""
这个案例实现 python 异步驱动mongodb
motor 文档
https://motor.readthedocs.io/en/stable/
"""

'''连接'''
# 普通连接
client = motor.MotorClient('mongodb://localhost:27017')
'''
# 副本集连接
client = motor.MotorClient('mongodb://host1,host2/?replicaSet=my-replicaset-name')
# 密码连接
client = motor.MotorClient('mongodb://username:password@localhost:27017/dbname')
'''
# 获取数据库
db = client.zfdb
# db = client['zfdb']
# 获取 collection
collection = db.test
# collection = db['test']
loop = asyncio.get_event_loop()


# 增加1条记录
async def do_insert_one():
    document = {'name': 'zone', 'sex': 'boy'}
    result = await db.test_collection.insert_one(document)
    print(f'result {repr(result.inserted_id)}')
loop.run_until_complete(do_insert_one())


# 批量增加记录
async def do_insert_many():
    result = await db.test_collection.insert_many([{'name': i, 'sex': str(i + 2)} for i in range(20)])
    print(f'inserted {len(result.inserted_ids)} docs')
loop.run_until_complete(do_insert_many())


# 查找一条记录
async def do_find_one():
    document = await db.test_collection.find_one({'name': 'zone'})
    print(document)
loop.run_until_complete(do_find_one())


# 查找多条记录 排序
async def do_find_many():
    cursor = db.test_collection.find({'name': {'$lt': 5}}).sort('i')
    for document in await cursor.to_list(length=100):
        print(document)
loop.run_until_complete(do_find_many())


# 添加筛选条件，排序，跳过，限制返回结果数
async def do_find():
    cursor = db.test_collection.find({'name': {'$lt': 4}})
    # Modify the query before iterating
    cursor.sort('name', -1).skip(1).limit(2)
    async for document in cursor:
        print(document)
loop.run_until_complete(do_find())


# 统计
async def do_count():
    n = await db.test_collection.count_documents({})
    print('%s documents in collection' % n)
    n = await db.test_collection.count_documents({'name': {'$gt': 1000}})
    print('%s documents where i > 1000' % n)
loop.run_until_complete(do_count())


# 替换，将除id以外的其他内容全部替换
async def do_replace():
    coll = db.test_collection
    old_document = await coll.find_one({'name': 'zone'})
    print(f'found document: {old_document}')
    _id = old_document['_id']
    result = await coll.replace_one({'_id': _id}, {'sex': 'hanson boy'})
    print(f'replaced {result.modified_count} document')
    new_document = await coll.find_one({'_id': _id})
    print(f'document is now {new_document}')
loop.run_until_complete(do_replace())


# 更新 更新指定字段，不会影响到其他内容
async def do_update():
    coll = db.test_collection
    result = await coll.update_one({'name': 0}, {'$set': {'sex': 'girl'}})
    print(f'更新条数：{result.modified_count}')
    new_document = await coll.find_one({'name': 0})
    print(f'更新结果为：{new_document}')
loop.run_until_complete(do_update())


# 删除 删除指定记录
async def do_delete_many():
    coll = db.test_collection
    n = await coll.count_documents({})
    print(f'删除前有 {n} 条数据')
    await db.test_collection.delete_many({'name': {'$gte': 10}})
    m = await coll.count_documents({})
    print(f'删除后有 {m} 条数据')
loop.run_until_complete(do_delete_many())



def mongo_client_test():
    from pymongo import MongoClient

    """
    介绍：这个demo简单介绍 python连接mongodb。
    """
    # 普通连接
    client = MongoClient('localhost', 27017)
    '''
    client = MongoClient('mongodb://localhost:27017/')
    # 密码连接
    client = MongoClient('mongodb://username:password@localhost:27017/dbname')
    '''

    db = client.zfdb
    # db = client['zfdb']

    test = db.test

    # 增加一条记录
    person = {'name': 'zone', 'sex': 'boy'}
    person_id = test.insert_one(person).inserted_id
    print(person_id)

    # 批量插入
    persons = [{'name': 'zone', 'sex': 'boy'}, {'name': 'zone1', 'sex': 'boy1'}]
    result = test.insert_many(persons)
    print(result.inserted_ids)

    # 删除单条记录
    result1 = test.delete_one({'name': 'zone'})
    print(result1)

    # 批量删除
    result1 = test.delete_many({'name': 'zone'})
    print(result1)

    # 更新单条记录
    res = test.update_one({'name': 'zone'}, {'$set': {'sex': 'girl girl'}})
    print(res.matched_count)

    # 更新多条记录
    test.update_many({'name': 'zone'}, {'$set': {'sex': 'girl girl'}})

    # 查找多条记录
    print(test.find())

    # 添加查找条件
    print(test.find({"sex": "boy"}).sort("name"))

    # 聚合查找
    aggs = [
        {"$match": {"$or": [{"field1": {"$regex": "regex_str"}}, {"field2": {"$regex": "regex_str"}}]}},  # 正则匹配字段
        {"$project": {"field3": 1, "field4": 1}},  # 筛选字段
        {"$group": {"_id": {"field3": "$field3", "field4": "$field4"}, "count": {"$sum": 1}}},  # 聚合操作
    ]
    result = test.aggregate(pipeline=aggs)
    print(result)
