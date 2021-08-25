# MySQL
常用命令|说明
--- | ---
show databases;| 显示数据库
create database name;| 创建数据库
use databasename; | 选择数据库
drop database name; | 直接删除数据库，不提醒
show tables; | 显示表
describe tablename; | 显示具体的表结构
select distinct |去除重复字段
mysqladmin drop databasename; | 删除数据库前，有提示。
select version(),current_date; | 显示当前mysql版本和当前日期
flush privileges |刷新数据库
mysql -h localhost -u root -p | 登录
update user set password=password("123456") where user='root';|修改mysql中root的密码：
alter table t1 rename t2;|重命名表
mysqldump -h host -u root -p dbname >dbname_backup.sql|备份数据库
mysqldump -h host -u root -p dbname < dbname_backup.sql|恢复数据库
mysqladmin -u root -p -d databasename > a.sql|导出建表指令
mysqladmin -u root -p -t databasename > a.sql|导出sql数据
mysqldump -T ./ phptest driver|导出纯数据
grant all on databasename.* to $username identified by '12345678'|赋予username操作数据库权限
grant all on *.* to root@202.116.39.2 identified by "123456";`|授权远程访问
grant select on 数据库.* to 用户名@登录主机 identified by "密码"|增加新用户
GRANT ALL PRIVILEGES ON *.* TO monty@localhost IDENTIFIED BY 'something' WITH GRANT OPTION;|demo
GRANT ALL PRIVILEGES ON *.* TO mailto:monty@"" IDENTIFIED BY 'something' WITH GRANT OPTION;|demo
grant select, insert, update, delete, create,drop on fangchandb.* to custom@it363.com identified by 'passwd'|创建一个用户custom在特定客户端it363.com登录，可访问特定数据库fangchandb
revoke all privileges on *.* from mailto:root@"";delete from user where user="root" and host="%";flush privileges;|删除授权

## mysql 字段类型：
- string
- hash
- list
- set
- zset
## 查询完整语法
```odpsql
select distinct * from Student
where ...
group by ...
having ...
order by ...
limit ...
```
```odpsql
create database Student charset=utf8;
drop database Student
show databases;
use Student

create table stu(
id int not null primary key auto_increment, 
name varchar(10) not null, 
gender bit default 1,
birthday datetime, isDelete bit default 0);
create table stu(
    id int not null primary key auto_increment,
    name varchar(10) not null,
    gender bit default 1,
    birthday datetime,
    isDelete bit default 0,
);
Create TABLE Student.users (
  id int(11) NOT NULL auto_increment,
  username varchar(40) default NULL,
  birthday date default NULL,
  foreign key(stu_id) references stu(id),
  foreign key(sub_id) references sub(id)
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=gb2312;

show tables;
desc Student;
drop table Student;
Drop TABLE IF EXISTS Student.users;
alter table Student add|modify|drop Student;
alter table stu modify column isDelete bit not null default 0;
insert into stu(name) values(abc),(def)...;
insert into stu values(0,1,1,100);
update Student set age=23,... where ...;
update firstdb.users set username='abc' where id=3;
delete from Student where ...;
select distinct * from stu where gender=1 and (name like 'abc%' or name like 'def%')
select * from stu inner join class on stu.class_id=class.id
select name,score from stu inner join sco on stu.id=sco.stu_id
select name,avg(score) from stu inner join sco on stu.id=sco.stu_id group by name
select id from areas where title='abc' or title='def'
select * from areas where pid in(select id from areas where title='a' or title='b')
select qu.*,qu1.*
from areas as shi
inner join areas as qu on qu.pid=shi.id
left join areas as qu1 on qu1.pid=qu.id
where shi.title='abc'
```

Connection:MySQLdb.connect(),cursor(),commit(),rollback(),close()  
Cursor:execute(),fetchone(),fetchall(),close()

# MongoDB

### 数据库常用命令

 命令 | 作用
---- | ----
rs.status()| 查看数据库状态
rs.slaveOk()| 开启查看数据库状态
rs.stepDown(10)| 10s内让数据库降级
rs.initiate(config)| 执行数据库初始化
db.isMaster()| 查看本机是否是master
rs.reconfig()| 更新配置文件
db.serverStatus().connections| 查看连接数
数据库管理工具：robo 3T

### 启动数据库
```
service mongodb start
service mongodb stop
service mongodb restart
1. 通过配置启动 mongod -f my_mongo.conf
2. 直接启动 mongod &
参数说明：
--dbpath 数据库数据存放位置
--logpath 数据库日志存放位置
--port 启动端口
--fork 以守护进程方式启动
--auth 开启验证
--bind_ip 绑定启动IP
# 连接数据库
mongo localhost:27017
mongo --host 127.0.0.1 --port 27018 -u "myUserAdmin" -p "xxxx" --authenticationDatabase "admin"
--authenticationDatabase 需要验证的数据库
# 停止命令
service mongod stop  
db.shutdownServer() 
mongod -f /etc/mongo-m.conf  --shutdown
# 连接数据库
mongodb://admin:123456@localhost/test
```

### 启动文件配置
```shell
port=27017
bind_ip=0.0.0.0
logpath=/home/mongodb/log/root.log
dbpath=/home/mongodb/data/
logappend=true
fork=true
oplogSize=1024
#auth=true
```

### 一、数据库操作
```bash
db/db.getName() # 查询当前数据库
show dbs # 查询所有的数据库
use music  # 创建/切换数据库
db.dropDataBase()  # 删除当前数据库
db.stats()
db.version()
```

### 二、集合操作
```bash
db.createCollection('collectionName') 创建一个集合
db.getCollectionNames() 得到当前db的所有集合
```
### 三、文档操作

1. 插入数据
```bash
db.users.insertOne({"username": 1, password: 123})
db.users.insertMany([{username: 'gaojie', password: 'gj', email: 'gj@126.com'}, {username: 'xinyi', password: 123, email: 123}])
db.baoguo.insert([{name: 'm1', release: '2020-12-05'}])
db.baoguo.insert([{name: 'm2', release: '2020-12-05'}, {name: 'm3', release: '2020-12-06'}])
db.baoguo.save([{name: 'm4', release: '2020-12-07'}, {name: 'm5', release: '2020-12-08'}])
db.baoguo.insert([{name: 'm1', release: '2020-12-05', publishNum: 100}])
```

2. 修改数据
```bash
 db.collection.update(
   <query>,
   <update>, # $set设置的话， 后两个参数才有效
   {
     upsert: <boolean>, # 是否找不到就创建
     multi: <boolean>,
     writeConcern: <document>,
     collation: <document>,
     arrayFilters: [ <filterdocument1>, ... ],
     hint:  <document|string>        // Available starting in MongoDB 4.2
   }
)
db.users.update({username: 'gp145'}, {$set: {username: 'yl'}}, true, true)
db.users.updateMany({username: 'yl'}, {$set: {username: 'yangli'}})
db.baoguo.update({name: 'm1'}, {$set: {release:'2020-12-04'}})
db.baoguo.update({name: 'm100'}, {$inc: {publishNum: 200}}, true)
db.baoguo.update({name: 'm1000'}, {$inc: {publishNum: 200}}, true)
db.baoguo.update({name: 'm1'}, {$inc: {publishNum: 200}}, true, true)
```

3. 删除数据
```bash
db.baoguo.remove({name: 'm1000'})
db.col.deleteMany({'title': 'super'})
db.table_name.drop() # 删除表
```

4. 查询数据
```bash
db.baoguo.find().pretty()
db.baoguo.distinct('name')
db.baoguo.find({release: '2020-12-05'})
db.baoguo.find({release: {$gt: '2020-12-05'}})
db.baoguo.find({release: {$gte: '2020-12-04', $lte: '2020-12-06'}})
db.baoguo.find({name:/^1/})
db.baoguo.find({name:/1$/})
db.baoguo.find({}, {_id: 0, publishNum: 0})
db.baoguo.find({name:/1$/}, {_id: 0, publishNum: 0})
db.baoguo.find().sort({release: 1})
db.baoguo.find().sort({release: -1})
db.baoguo.find().sort({release: 1}).limit(3).skip(6)
db.baoguo.find().limit(3).skip(6).sort({release: 1})
db.col.find({},{"title":1,_id:0}).limit(1).skip(1).sort({"likes":-1}) # skip 跳过几个
db.col.find({post_text:{$regex:"runoob"}})
db.Student.find({},{}).limit().skip().sort().count().distinct()
db.baoguo.find({$or:[{release: '2020-12-04'}, {release: '2020-12-05'}]})
db.baoguo.findOne()
db.baoguo.find().count()
db.movies.find({rt: {$gte: '2020-01-01'}}, {nm: 1, _id: 0, rt: 1}).sort({rt: -1}).limit(3).skip(3)
```

```
$gt -------- greater than  >
$gte ------- gt equal  >=
$lt -------- less than  <
$lte ------- lt equal  <=
$ne -------- not equal  !=
$eq -------- equal  =
```

### 操作用户
```shell
db`use xxxxx`
db.createUser(
    {
        user:"username",
        pwd:"password",
        roles:[
            {role:"read", db:"xxxx"},
            {role:"readWrite", db:"test"}
        ]
    }
)
# 添加超级用户
use admin
db.createUser(
    {
        user:"username",
        pwd:"password",
        roles:[
            {role:"root", db:"admin"}
        ]
    }
)
# 删除用户
db.dropUser("username")
# 更新用户
db.updateUser("username",{
    pwd:"new password",
    customData:{
        "title":"PHP developer"
    }
})
# 更新用户密码
db.changeUserPassword("username","newpassword")
# 查看用户信息
db.getUser("username")
```

# js支持

```javascript
var MongoDB = require('shell/databases');
var MongoClient = MongoDB.MongoClient;
var Config = {
    dbUrl: 'mongodb://localhost:27017/',
    dbName: 'koa'
};

class Db {
    static getInstance() {
        if (!Db.instance) {
            Db.instance = new Db();
        }
        return Db.instance;
    }

    constructor() {
        this.dbClient = '';
        this.connect();
    }

    connect() {
        let _that = this;
        return new Promise((resolve, reject) => {
            if (!_that.dbClient) {
                MongoClient.connect(Config.dbUrl, (err, client) => {
                    if (err) {
                        reject(err)
                    } else {
                        _that.dbClient = client.db(Config.dbName);
                        resolve(_that.dbClient)
                    }
                })
            } else {
                resolve(_that.dbClient);
            }
        })
    }

    find(collectionName, json) {
        return new Promise((resolve, reject) => {
            this.connect().then((db) => {
                var result = db.collection(collectionName).find(json);
                result.toArray(function (err, docs) {
                    if (err) {
                        reject(err);
                    } else {
                        resolve(docs);
                    }
                })

            })
        })
    }

    update(collectionName, json1, json2) {
        return new Promise((resolve, reject) => {
            this.connect().then((db) => {
                //db.user.update({},{$set:{}})
                db.collection(collectionName).updateOne(json1, {$set: json2}, (err, result) => {
                    if (err) {
                        reject(err);
                    } else {
                        resolve(result);
                    }
                })
            })
        })
    }

    insert(collectionName, json) {
        return new Promise((resolve, reject) => {
            this.connect().then((db) => {
                db.collection(collectionName).insertOne(json, function (err, result) {
                    if (err) {
                        reject(err);
                    } else {
                        resolve(result);
                    }
                })
            })
        })
    }

    remove(collectionName, json) {
        return new Promise((resolve, reject) => {
            this.connect().then((db) => {
                db.collection(collectionName).removeOne(json, function (err, result) {
                    if (err) {
                        reject(err);
                    } else {
                        resolve(result);
                    }
                })
            })
        })
    }

    getObjectId(id) {   /*mongodb里面查询 _id 把字符串转换成对象*/
        return new MongoDB.ObjectID(id);
    }
}

module.exports = Db.getInstance();
// usage
/**
 DB=require('./db.js');
 router.post('/doEdit',async (ctx)=>{
    var id=ctx.request.body.id;
    let data=await DB.update('user',{"_id":DB.getObjectId(id)},{
        username:'a',age:23,sex:1
    });
    DB.find('user',{}).then((data)=>{
        console.log(data);
    });
    console.log(data);
});
 */



// mysql
var mysql = require('mysql');
var connection = mysql.createConnection({
    host: 'localhost',
    port: '3306',
    user: 'root',
    password: '123456',
    database: 'test'
});
connection.connect();

connection.query('SELECT 1 + 1 AS solution', function (error, results, fields) {
    if (error) throw error;
    console.log('The solution is: ', results[0].solution);
});
var delSql = 'DELETE FROM websites where id=6';
connection.query(delSql, function (err, result) {
    if (err) {
        console.log('[DELETE ERROR] - ', err.message);
        return;
    }
    console.log('DELETE affectedRows', result.affectedRows);
});
var addSql = 'INSERT INTO websites(Id,name,url,alexa,country) VALUES(0,?,?,?,?)';
var addSqlParams = ['菜鸟工具', 'https://c.runoob.com', '23453', 'CN'];
connection.query(addSql, addSqlParams, function (err, result) {
    if (err) {
        console.log('[INSERT ERROR] - ', err.message);
        return;
    }
    console.log('INSERT ID:', result);
});
var sql = 'SELECT * FROM websites';
connection.query(sql, function (err, result) {
    if (err) {
        console.log('[SELECT ERROR] - ', err.message);
        return;
    }
    console.log(result);
});
var modSql = 'UPDATE websites SET name = ?,url = ? WHERE Id = ?';
var modSqlParams = ['菜鸟移动站', 'https://m.runoob.com', 6];
connection.query(modSql, modSqlParams, function (err, result) {
    if (err) {
        console.log('[UPDATE ERROR] - ', err.message);
        return;
    }
    console.log('UPDATE affectedRows', result.affectedRows);
});
connection.end();

// mongoDB 数据库
var MongoClient = require('shell/databases').MongoClient;
var DBurl = 'mongodb://localhost:27017/student';
MongoClient.connect(DBurl, function (err, db) {
    if (err) {
        console.log('数据库连接失败' + err.message);
        return;
    }
    db.collection('user').insertOne({"name": "大地", "age": 10}, function (error, result) {
        db.close();
    });
    db.collection('user').updateOne({"name": "lisi"}, {$set: {"age": 666}}, function (error, data) {
        db.close();
    });
    db.collection('user').deleteOne({"name": name}, function (error, data) {
        db.close();
    });
    var list = [];
    var result = db.collection('user').find({});
    result.each(function (error, doc) {
        if (error) {
            console.log(error);
        } else {
            if (doc != null) {
                list.push(doc);
            } else {
                console.log('数据循环完成')
            }
        }
    });
    console.log(list)
});
```
# python支持
```python
# coding=utf-8
from bson import ObjectId
from pymongo import MongoClient
from pymongo.database import Collection, Database


class MongodbException(Exception):
    def __init__(self, msg):
        self.msg = msg


class MongoManager(object):
    def __init__(self, uri, db, client=None):
        self.client = client or MongoClient(uri, tz_aware=False, retryWrites=True)
        self.db = db

    def get_client(self) -> MongoClient:
        return self.client

    def check_connection_state(self) -> bool:
        try:
            return self.client["admin"].command("ping").get("ok") == 1
        except:
            return False

    def get_collection(self, table: str) -> Collection:
        return self.client[self.db][table]

    def get_db(self) -> Database:
        return self.client[self.db]

    def show_collections(self) -> List[str]:
        return self.get_db().collection_names()

    # 插入部分
    def single_insert(self, table: str, document) -> str:
        con = self.get_collection(table)
        result = con.insert_one(document)
        return str(result.inserted_id)

    def mul_insert(self, table, documents, has_return=False):
        if documents:
            con = self.get_collection(table)
            res = con.insert_many(documents)
            return [str(item) for item in res] if has_return else None

    # 修改部分
    def update(self, table, query, update):
        con = self.get_collection(table)
        data = {"$set": update}
        con.update_many(query, data)

    def cover(self, table, query, update):
        con = self.get_collection(table)
        con.replace_one(query, update)

    def custom_update(self, table, query, update):
        con = self.get_collection(table)
        con.update_many(query, update)

    # 查询部分
    def get_page_list(self, table, mfilter, mfields=None, msort=None, page=1, page_size=20):
        con = self.get_collection(table)
        fields = {item: 1 for item in mfields or []}
        sorts = list(map(lambda x: (x[1:], -1) if "-" in x else (x, 1), msort or []))
        offset = (page - 1) * page_size
        if fields:
            cursor = con.find(mfilter, fields).skip(offset).limit(page_size)
        else:
            cursor = con.find(mfilter).skip(offset).limit(page_size)
        if sorts:
            cursor = cursor.sort(sorts)
        res = []
        for document in cursor:
            document["_id"] = str(document["_id"])
            res.append(document)
        return res

    def get_page_list_full_key(self, table, mfilter, mfields=None, msort=None, page=1, page_size=20):
        """
        @attention: 列表查询(用于分页时的查询)，返回列表,如果查询key不存在,则用空填补
        @warning: 请不要使用该函数进行统计，统计请直接使用底层模块来处理
        """
        mfields = mfields or []
        con = self.get_collection(table)
        fields = {item: 1 for item in mfields}
        sorts = list(map(lambda x: (x[1:], -1) if "-" in x else (x, 1), msort or []))
        offset = (page - 1) * page_size
        if fields:
            cursor = con.find(mfilter, fields).skip(offset).limit(page_size)
        else:
            cursor = con.find(mfilter).skip(offset).limit(page_size)

        if sorts:
            cursor = cursor.sort(sorts)

        res = []
        for document in cursor:
            document["_id"] = str(document["_id"])
            temp = {item: "" for item in mfields}
            temp.update(document)
            res.append(temp)
        return res

    def get_find_cursor(self, table, mfilter, mfields=None, msort=None):
        con = self.get_collection(table)
        fields = {item: 1 for item in mfields or []}
        sorts = list(map(lambda x: (x[1:], -1) if "-" in x else (x, 1), msort or []))
        if fields:
            cursor = con.find(mfilter, fields)
        else:
            cursor = con.find(mfilter)
        if sorts:
            cursor = cursor.sort(sorts)
        return cursor

    def get_one_info(self, table, mfilter, mfields=None):
        con = self.get_collection(table)
        fields = {item: 1 for item in mfields or []}
        res = con.find_one(mfilter, fields)
        if res is None:
            return None
        else:
            res["_id"] = str(res["_id"])
            return res

    # 删除部分
    def delete_info(self, table, query):
        con = self.get_collection(table)
        con.delete_many(query)

    def count(self, table, query, key="", is_distinct=False):
        con = self.get_collection(table)
        if is_distinct:
            num = len(con.distinct(key, query))
        else:
            num = con.count(query)
        return num

    def get_field_distinct_list(self, table, query, key):
        con = self.get_collection(table)
        info = con.distinct(key, query)
        return info

    def get_distinct_number(self, table, query, key):
        pipeline = [
            {
                "$match": query
            },
            {
                "$group": {
                    "_id": "sum",
                    "times": {
                        "$addToSet": "$%s" % key
                    }
                }
            },
            {
                "$project": {
                    "times": {
                        "$size": "$times"
                    }
                }
            },
            {
                "$sort": {
                    "times": -1
                }
            },
        ]
        info = self.run_pipeline(table, pipeline)
        info = list(info)
        return info[0]["times"] if info else 0

    def run_pipeline(self, table, pipeline, allowDiskUse=True):
        con = self.get_collection(table)
        return con.aggregate(pipeline, allowDiskUse=allowDiskUse)

    def drop(self, table):
        con = self.get_collection(table)
        con.drop()

    def create_index(self, table, index_list):
        con = self.get_collection(table)
        con.create_index(index_list)

    def create_table(self, name):
        self.client[self.db].create_collection(name)

    def has_table(self, table):
        tables = self.client[self.db].collection_names()
        return table in tables

    # 复合类方法
    def update_or_create(self, table, query, update) -> str:
        res = self.get_one_info(table, query)
        if res:
            res["_id"] = ObjectId(res["_id"])
            self.update(table, res, update)
            pk = res["_id"]
        else:
            pk = self.single_insert(table, update)
        return str(pk)

    def sum(self, table, mfilter, keys):
        keys_group = {item: {"$sum": "$%s" % item} for item in keys}
        keys_group.update({"_id": "sum"})
        pipeline = [{"$match": mfilter}, {"$group": keys_group}]
        res = list(self.run_pipeline(table, pipeline))
        if res:
            return res[0]
        else:
            return {}.fromkeys(keys, 0)

    def top(self, table, query, classify_param, count_param, top=0, sort_tag=-1, has_space=False):
        """
        @attention: 某个指定字段分布情况
        @param table: 表名
        @param query: 过滤条件
        @param classify_param: 分类字段
        @param count_param: 分类字段对应的次数字段,注意该字段的值必须是数字
        @param top: 取值范围,0表示获取全部
        @param sort_tag: 排序标识,默认按数字大小倒叙排列(从大到小);1:从小到大,-1:从大到小,0:不排序
        """
        if isinstance(classify_param, list):
            if not has_space:
                for param in classify_param:
                    if param in query:
                        query[param]["$ne"] = ""
                    else:
                        query.update({param: {"$ne": ""}})
            id_group = {"_id": {item: "$%s" % item for item in classify_param}}
            show = {"_id": 0, count_param: 1}
            show.update({item: "$_id.%s" % item for item in classify_param})
        else:
            if not has_space:
                if classify_param in query:
                    query[classify_param]["$ne"] = ""
                else:
                    query.update({classify_param: {"$ne": ""}})
            id_group = {"_id": {classify_param: "$%s" % classify_param}}
            show = {"_id": 0, count_param: 1, classify_param: "$_id.%s" % classify_param}
        times_group = {count_param: {"$sum": "$%s" % count_param}}
        cgroup = {}
        cgroup.update(id_group)
        cgroup.update(times_group)
        pipeline = [{"$match": query},{"$group": cgroup}]
        if sort_tag != 0:
            pipeline.append({"$sort": {count_param: sort_tag}})
        if top > 0:
            pipeline.append({"$limit": top})
        pipeline.append({"$project": show},)
        info = self.run_pipeline(table, pipeline)
        return info

    def show_indexes(self, table):
        con = self.get_collection(table)
        return con.index_information()
```
