# MongoDB
##1. 基础知识
- 连接数据库: `mongodb://admin:123456@localhost/test`
```bash
> show dbs;
> use db_name; # 既是使用又是创建
> db.dropDatabase() # 删除本数据库
> db.createCollection("freedom")
> show tables;
> db.table_name.insert({"a": "b"})
> db.table_name.find()
> db.table_name.find({"a": "b"})
> document=({
    title: 'super', 
    url: 'http://www.baidu.com',
    tags: ['mongodb', 'database', 'NoSQL'],
    age: 100
});
> db.table_name.insert(document)
> var res = db.table_name.insertMany([{"b": 3}, {'c': 4}])
> db.table_name.drop() # 删除表
> db.table_name.update({'title':'super'},{$set:{'title':'MongoDB'}},{upsert: true},{multi:true})
> db.table_name.update({"count":{$gt:4}},{$set: {"test5": "OK"}},true,false);
> db.table_name.find().pretty()
> db.col.remove({'title':'super'})
> db.col.deleteMany({'title': 'super'})
> db.col.find({likes : {$lt :200, $gt : 100}})
> db.col.find({title:/^教/})
> db.col.find({},{"title":1,_id:0}).limit(1).skip(1) # skip 跳过几个
> db.col.find({},{"title":1,_id:0}).sort({"likes":-1})
> db.posts.find({post_text:{$regex:"runoob"}})
```
```
$gt -------- greater than  >
$gte ------- gt equal  >=
$lt -------- less than  <
$lte ------- lt equal  <=
$ne -------- not equal  !=
$eq -------- equal  =
```








