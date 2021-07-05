[TOC]
## 前言：
MongoDB默认是没有开启用户认证的，也就是说游客也拥有超级管理员的权限。所以，如果涉及到在公网暴露数据库，一定需要检查数据库是否真正开启验证。

### 对于新数据库：
1. 启动数据库，创建管理员用户。
2. 重启数据库，并开启验证。
3. 使用管理员用户创建，其他用户，并且分配权限。

### mongodb认证解决2个问题
1. Authentication 解决我是谁
2. Authorization 解决我能做什么

### mongodb 用户权限以数据库为单位
1. 创建一个数据库
2. 围绕这个数据库，创建管理员，用户，并且划分相应权限。
3. A数据库管理员，是不能操作B数据各种内容的。需要在B数据库添加A才能操作。

---
## **数据库角色及权限**
角色|名称|权限
--|:--|--
数据库用户：| user | read、readWrite 非系统集合有查询和修改权限
**数据库管理角色类**|||
-|dbAdmin | 数据库管理相关，比如索引管理，schema管理，统计收集等，不包括用户和角色管理
-|dbOwner | 提供数据库管理，读写权限，用户和角色管理相关功能 
-|userAdmin| 提供数据库用户和角色管理相关功能
**集群管理角色类**|||
-|clusterAdmin | 提供最大集群管理权限
-|clusterManager| 提供集群管理和监控权限
-|clusterMonitor| 提供对监控工具只读权限
-|hostManager| 提供监控和管理severs权限
**备份恢复角色**|||
-|backup | 提供数据库备份权限
-|restore | 提供数据恢复权限
**所有数据库角色类**|||
-|readAnyDatabase| 提供读取所有数据库的权限除了local和config数据库之外
-|readWriteAnyDatabase|和readAnyDatabase一样，除了增加了写权限
-|userAdminAnyDatabase|管理用户所有数据库权限，单个数据库权限和userAdmin角色一样
-|dbAdminAnyDatabase|提供所有用户管理权限，除了local,config
超级用户：   | root | 数据库所有权限
内部角色：  | __system  不建议使用 |提供数据库所有对象任何操作的权限，不能分配给用户，非常危险
|读写权限：|   read/readWrite |读写库的权限|


---
## **用户管理**
### 添加用户
可以通过mongo shell终端操作，用户保存在admin数据库system.user集合中

### 添加普通用户
1. 切换到需要添加用户的db
`use xxxxx`
2. 执行添加
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
1. 切换到admin数据库
`use admin`
2. 执行添加
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
1. 切换到用户授权的db
`use xxx`
2. 执行删除操作
`db.dropUser("username")`

### 更新用户
1. 切换到用户授权的db
`use xxx`
2. 执行更新，字段会覆盖原来的内容
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


[TOC]
### 数据库常用命令
|命令|作用|
:--|--|
rs.status()| 查看数据库状态
rs.slaveOk()| 开启查看数据库状态
rs.stepDown(10)| 10s内让数据库降级
rs.initiate(config)| 执行数据库初始化
db.isMaster()| 查看本机是否是master
rs.reconfig()| 更新配置文件
db.serverStatus().connections| 查看连接数---{ "current" : 109, "available" : 838751, "totalCreated" : 42527 }
-| Current表示当前到实例上正在运行的连接数。
-|Available表示当前实例还可以支持的并发连接数。
-|TotalCreated表示当前实例从启动到现在一共创建的连接数，包括历史已经关闭了的。

ps: 数据库内部增删改查，和外部命令有些出入。尤其是数据库内部更新。需要使用$set，否则会出现删掉其他数据的现象。

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
ps：python 连接数据库请参考demo


### 停止命令
```
1. kill XXX
2. service mongod stop
3. 数据库内部关闭： db.shutdownServer()
4. 通过配置关闭： mongod -f /etc/mongo-m.conf  --shutdown
5. 强行关闭：kill -9 XXX  数据库直接关闭，可能导致数据丢失
```

### 集群配置1（外网环境，节点在不同物理机）：
```
# 节点1
config = {
_id:"haribol",
members:[
{_id:0,host:"114.80.116.140:27000"},
{_id:1,host:"114.80.116.140:27001",hidden:true,priority:0,slaveDelay:43200},
{_id:3,host:"114.80.116.141:27000"},
{_id:4,host:"114.80.116.141:27001",hidden:true,priority:0,slaveDelay:7200},
{_id:6,host:"114.80.116.144:27000",arbiterOnly:true},
]
}
# 节点2
config = {
_id:"haribol",
members:[
{_id:0,host:"192.168.0.1:27000"},
{_id:1,host:"192.168.0.1:27001",hidden:true,priority:0,slaveDelay:43200},
{_id:3,host:"192.168.0.2:27000"},
{_id:4,host:"192.168.0.2:27001",hidden:true,priority:0,slaveDelay:7200},
{_id:6,host:"192.168.0.4:27000",arbiterOnly:true},
]
}
```

### 集群配置2（本地集群，所有节点在一个主机上）
```
# 节点1，2，3
config = {
_id:"haribol",
members:[
{_id:0,host:"192.168.0.36:27000"},
{_id:1,host:"192.168.0.36:27001"},
{_id:2,host:"192.168.0.36:27002",hidden:true,priority:0,slaveDelay:43200},
]
}
```
### 启动文件配置
```shell
>>>>>>>>>>>>>>>>>数据库启动文件1>>>>>>>>>>>>>>>>>
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

>>>>>>>>>>>>>>>>>数据库启动文件2>>>>>>>>>>>>>>>>>
port=27003
bind_ip=0.0.0.0
logpath=/ExtendDisk/mongodb/log/27003.log
dbpath=/ExtendDisk/mongodb/data/27003
logappend=true
pidfilepath=/ExtendDisk/mongodb/data/27003/27003.pid
fork=true
oplogSize=1024
replSet=haribol
#auth=true
#keyFile=/ExtendDisk/mongodb/mongodb_key
```



### 用户配置
```
>>>>>>>>>>>>>>>>>使用者>>>>>>>>>>>>>>>>>
use OptimusPrime
db.createUser(
  {
    user: "caturbhuja",
    pwd: "wevdsgea",
    roles: [ { role: "readWrite", db: "OptimusPrime" }]
  }
)
>>>>>>>>>>>>>>>>>超级管理员>>>>>>>>>>>>>>>>>
use admin
db.createUser(
  {
    user: "myRoot",
    pwd: "afewfsdaf",
    roles: [ { role: "root", db: "admin" } ]
  }
)
```

### 集群选举原理介绍
采用半数原则，详情略

### 常见问题
1. 在数据库创建用户时，输入后，没有反应。退出时会提示是否需要修改信息。
实际上，创建的用户，已经写入数据库的admin中。我自己查看能看到。所以这个每次添加一下，然后重启即可。

2. 日志显示 permissions on /home/mongodb/mongodb_key are too open, 通过修改权限解决。
chmod 600 /Users/caturbhuja/mongodb/mongodb-keyfile

3. 遇到配置失败，或者其他原因，导致集群没有master怎么办？
如果在前期，可以删除数据库，重新来过。但是在后期该如何处理？
后期可以手动备份数据，然后重建数据库。

[TOC]

ps：⚠️mongodb4.0 和mongodb3.6 区别非常大。目前生产环境中，尽量使用mongodb3.6.*

## 集群配置步骤
### 1. 配置文件内，不添加auth，keyfile 开启服务。
`mongod -f /home/caturbhuja/mongodb/conf/28001.conf`
### 2. 连接到数据库。
`mongo --port 28001 --host 192.168.0.35`
### 3. 为新数据库 创建新用户
```
use admin
db.createUser(
  {
    user: "caturbhuja",
    pwd: "haribol",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  }
)
```
### 4. 生成keyfile，并将这个Key复制到每个节点上,切记一定需要修改keyfile权限，否则不报错，但是命令也无法执行，而且mongodb还会说（Automatically disabling TLS 1.0, to force-enable TLS 1.0 specify --sslDisabledProtocols 'none'）来误导你。这个其实是成功后出现的标示。
```
______ubuntu版本_______
》生成keyfile
openssl rand -base64 741 > /home/caturbhuja/mongodb/mongodb-keyfile
》修改keyfile权限。
chmod 600 /home/caturbhuja/mongodb/mongodb-keyfile
______mac版本_______
》生成keyfile
openssl rand -base64 741 > /Users/caturbhuja/mongodb/mongodb-keyfile
》修改keyfile权限。
chmod 600 /Users/caturbhuja/mongodb/mongodb-keyfile
```
### 5. 修改配置文件：添加authorization: enabled(3.6版本，不认识这个命令，只认识下面的auth=true)
```
auth=true
keyFile=/home/caturbhuja/mongodb/mongodb-keyfile
```

### 6.为数据库创建用户
```
use OptimusPrime
db.createUser(
  {
    user: "caturbhuja",
    pwd: "Haribol",
    roles: [ { role: "readWrite", db: "OptimusPrime" }]
  }
)

db.createUser(
  {
    user: "caturbhujadas",
    pwd: "Haribol",
    roles: [ { role: "dbAdmin", db: "OptimusPrime" }]
  }
)
-------------
use admin
db.createUser(
  {
    user: "myRoot",
    pwd: "haribol",
    roles: [ { role: "root", db: "admin" } ]
  }
)
use HappyMoon
db.createUser(
  {
    user: "happymoon",
    pwd: "Haribol",
    roles: [ { role: "readWrite", db: "HappyMoon" }]
  }
)
```

### 7.关闭原来的mongod服务，通过新的配置文件启动服务。
`mongod -f /home/caturbhuja/mongodb/conf/28001.conf`

再次登录，发现需要验证了。
```
mongo 192.168.0.35:28001
use OptimusPrime
db.auth("caturbhuja", "Haribol") 
```
可以通过这样的方法，手动查看数据库。
`rs.slaveOk()` 开启查看数据库状态

`mongo 192.168.0.35:28001 -u "caturbhuja" -p "Haribol" --authenticationDatabase "OptimusPrime"`

### 8.首次搭建复制集，需要初始化工作。
```
>>>>>>>>>>>>>节点分布在不同服务器》》》》》》》》
config = {
_id:"haribol",
members:[
{_id:0,host:"192.168.0.36:28001"},
{_id:1,host:"192.168.0.35:28001"},
{_id:2,host:"192.168.0.34:28001"},
{_id:3,host:"192.168.0.33:28001",arbiterOnly:true},
]
}
>>>>>>>>>>>>>节点分布在一台服务器》》》》》》》》
config = {
_id:"haribol",
members:[
{_id:0,host:"61.147.172.171:27000"},
{_id:1,host:"61.147.172.171:27001"},
{_id:2,host:"61.147.172.171:27002",hidden:true,priority:0,slaveDelay:43200},
]
}
rs.initiate(config) 执行数据库初始化
```

#### 9. 数据库权限控制 角色划分
#### 9.1需要创建一个角色，能够管理数据库。集群在创建用户时，需要在主节点上操作。
`use admin`  # 这个必须是admin才能创建root。root是内建的超级用户。
`db.createUser({user:'caturbhuja',pwd:'Haribol',roles:[{ "role" : "root", "db" : "admin" }]});`

#### 9.2创建dbOwner 数据库拥有者，包括dbAdmin,userAdmin
`db.createUser({user:'root_caturbhuja',pwd:'Haribol',roles:[{ "role" : "dbOwner", "db" : "OptimusPrime" }]});`

---
## 集群配置常见问题解决
### 1.分片名变成OTHER，primary&secondary 的第三种状态。
ps:副本集之间不能连通，因为没有配置key_file导致。数据库会显示OTHER。

### 2.不开启验证时，需要注释掉 keyfile，否则会导致各个节点连接不上，导致各种设置（创建用户，添加数据库等）失败，反馈 no master。

### 3.mac上，创建用户时，说no master，清除数据库文件后，直接启动（不使用配置），然后添加相应用户。
然后添加各种配置，最后再开启验证。

### 4.在原来的数据库上配置集群，副本会不会自动同步原来的数据库？不会，因为之前没有oplog。
然后，之前数据库上创建的数据库，暂时不可见？那就重新创建一次吧，现在有了主次节点。
### 5.mongodb4.0 会报错
Support for replication protocol version 0 was removed in MongoDB 4.0. Downgrade to MongoDB version 3.6 and upgrade your protocol version to 1 before upgrading your MongoDB version"

### 6. 基本方法：先开启集群，等待集群内不有master后，在master上配置各种内容。添加各种用户，最后开启验证。并添加验证的key。

如果报配置版本错误，可以使用下面这个处理
cfg = rs.conf();
cfg.protocolVersion=1;
rs.reconfig(cfg);

### ubuntu16.04 mongodb默认配置文件地址
```
/usr/bin/mongod --config
vi /etc/mongod.conf
systemLog:
  path: /var/log/mongodb/mongod.log
storage:
  dbPath: /var/lib/mongodb
```