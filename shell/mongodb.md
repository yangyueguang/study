
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


