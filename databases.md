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

# 插入
mysql:insert into Student(name) values(abc)
mongo:db.Student.insert({})

# 更新
mysql:update Student set name=abc where id > 2
mongo:db.Student.update({id == 2},{$set},{name: abc})

# 删除
mysql:delete from Student where ....
mongo:db.Student.remove({id:2},{name: abc})

# 查找
db.stu.find({},{})
$where
limit(),skip(),sort(),count(),distinct()


db,show dbs,use Student,drop names
db.Student.insert({})
db.Student.update({},{$set:{}},{multi:true})
db.Student.remove({})
db.Student.find({},{}).limit().skip().sort().count().distinct()

db,show dbs,use Student,drop Teacher
db.Student.insert({})
db.Student.update({},{$set:{}},{multi:true})
db.Student.remove({})
db.Student.find({},{}).limit().skip().sort().count().distinct()
mysql	insert update delete select
redis	set	set	del	get
mongodb	insert	update	remove	find,aggregate
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


### 添加普通用户
1. 切换到需要添加用户的db`use xxxxx`
```shell
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
```

### 添加超级用户
1. 切换到admin数据库`use admin`
```shell
db.createUser(
    {
        user:"username",
        pwd:"password",
        roles:[
            {role:"root", db:"admin"}
        ]
    }
)
```
### 删除用户
1. 切换到用户授权的db`use xxx`
`db.dropUser("username")`

### 更新用户
1. 切换到用户授权的db`use xxx`
```shell
db.updateUser("username",{
    pwd:"new password",
    customData:{
        "title":"PHP developer"
    }
})
```
### 更新用户密码
```shell
use xx
db.changeUserPassword("username","newpassword")
```
### 查看用户信息
```
use admin
db.getUser("username")
```
---
## **角色操作**
### 添加用户角色
```
use xx
db.grantRolesToUser(
    "reportsUser",
    [
      { role: "read", db: "accounts" }
    ]
)
```

### 删除用户角色
```
use xx
db.revokeRolesFromUser(
    "usename",
    [
      { role: "readWrite", db: "accounts" }
    ]
)
```
### 查看角色信息
```
use admin
db.getRole("rolename",{showPrivileges:true})
```

### 删除角色
```
use admin
db.dropRole("rolename")
```

### 自定义角色
自定义角色保存在admin数据库system.roles集合中
```
use admin
db.createRole(
   {
     role: "manageOpRole",
     privileges: [
       { resource: { cluster: true }, actions: [ "killop", "inprog" ] },
       { resource: { db: "", collection: "" }, actions: [ "killCursors" ] }
     ],
     roles: []
   }
)
```


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

### 启动数据库
```
1. 通过配置启动 mongod -f my_mongo.conf
2. 直接启动 mongod &
参数说明：
--dbpath 数据库数据存放位置
--logpath 数据库日志存放位置
--port 启动端口
--fork 以守护进程方式启动
--auth 开启验证
--bind_ip 绑定启动IP
```
### 连接数据库
```
mongo localhost:27000
mongo --port 27018 -u "myUserAdmin" -p "xxxx" --authenticationDatabase "admin"
参数说明：
--port 端口
-u 用户名
-p 密码
--authenticationDatabase 需要验证的数据库
-- host 数据库地址
```

### 停止命令
```
1. kill XXX
2. service mongod stop
3. 数据库内部关闭： db.shutdownServer()
4. 通过配置关闭： mongod -f /etc/mongo-m.conf  --shutdown
5. 强行关闭：kill -9 XXX  数据库直接关闭，可能导致数据丢失
```

### 启动文件配置
```shell
port=27000
bind_ip=0.0.0.0
logpath=/home/mongodb/log/27000.log
dbpath=/home/mongodb/data/27000
logappend=true
pidfilepath=/home/mongodb/data/27000/27000.pid
fork=true
oplogSize=1024
replSet=haribol
#auth=true
#keyFile=/ExtendDisk/mongodb/mongodb_key
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
