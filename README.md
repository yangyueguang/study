# Study 学习资料
## 第三方库
### [1. 讯飞输入法](https://www.xfyun.cn) 
与语音有关的人工智能与智慧解决方案
### [2. 必应](https://cn.bing.com)
必应搜索必应翻译等
### [3. MobTech](http://www.mob.com)
推送、分享与手机验证码
### [4. LeanCloud](https://www.leancloud.cn)
数据存储、即时通讯、推送与短信
### [5. 融云](https://developer.rongcloud.cn)
即时通讯
### [6. Google](https://developers.google.com/products)
谷歌、人类科技的未来
### [7. 聚合数据](https://www.juhe.cn)
综合API

## 数据来源
1. [百度指数](http://index.baidu.com)
2. [阿里指数](https://alizs.taobao.com)
3. [微博指数](https://data.weibo.com)
4. [腾讯大数据](https://data.qq.com)
5. [国家数据](http://data.stats.gov.cn)
6. [国家统计局](http://www.stats.gov.cn)
6. [联合国数据](http://data.un.org)
7. [NASA数据](https://www.nasdaq.com)
9. [世界银行数据](https://data.worldbank.org.cn)
10. [艾瑞咨询](https://www.iresearch.com.cn)
11. [麦肯锡](https://www.mckinsey.com.cn)
12. [数据堂](https://datatang.com)
13. [贵阳大数据](http://www.gbdex.com/website)
14. [国家企业信用信息公示系统](http://www.gsxt.gov.cn/index.html)
15. [谷歌学术](https://www.gugexueshu.com)



import socket
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# 2.绑定本地端口
server_socket.bind(("", 9090))
# 3.设置为监听模式 1>把主动套接字转为被动套接字  2>告诉操作系统创建一个等待连接队伍
server_socket.listen(128)
# 4.等待客户端的链接 accept会阻塞等待，直到有客户端链接
client_socket, client_address = server_socket.accept()  # 返回一个新的套接字和客户端的地址
print("一个新客户端已经链接。。。。")
# 5.接收来自客户端的数据
date = client_socket.recv(1024)
print("接收到的数据：", date.decode(encoding="utf-8"))
# 6.回送数据给客户端
client_socket.send("世界之巅".encode(encoding="utf-8"))
# 7.关闭服务客户端的套接字
client_socket.close()


123、设计一个高并发
1. 部署至少2台以上的服务器构成集群，既防止某台服务器突然宕机，也减轻单台服务器的压力。
2. 页面进行动静分离，比如使用Nginx反向代理处理静态资源，并实现负载均衡。
3. 对于查询频繁但改动不大的页面进行静态化处理。
4. 在代理前添加web缓存，在数据库前增加缓存组件；比如可以使用Redis作为缓存，采用Redis主从+哨兵机制防止宕机，也可以启用Redis集群。
5. 对应用服务所在的主机做集群，实现负载均衡。
6. 对数据库进行读写分离，静态文件做共享存储。
7. 对数据库按照业务不同进行垂直拆分；分库分表：将一张大表进行水平拆分到不同的数据库当中；对于数据文件使用分布式存储。
8. 使用消息中间件集群，用作于请求的异步化处理，实现流量的削锋效果。比如对于数据库的大量写请求时可以使用消息中间件。
9. 将后端代码中的阻塞、耗时任务使用异步框架进行处理，比如celery。


124、怎样解决数据库高并发的问题？
1. 缓存式的 Web 应用程序架构：在 Web 层和 DB(数据库)层之间加一层 cache 层，主要目的：减少数据库读取负担，提高数据读取速度。cache 存取的媒介是内存，可以考虑采用分布式的 cache 层，这样更容易破除内存容量的限制，同时增加了灵活性。
2. 增加 Redis 缓存数据库
3. 增加数据库索引
4. 页面静态化：效率最高、消耗最小的就是纯静态化的 html 页面，所以我们尽可能使我们的网站上的页面采用静态页面来实现，这个最简单的方法其实也是最有效的方法。用户可以直接获取页面，不用像 MVC结构走那么多流程，比较适用于页面信息大量被前台程序调用，但是更新频率很小的情况。
5. 使用存储过程：处理一次请求需要多次访问数据库的操作，可以把操作整合到储存过程，这样只要一次数据库访问即可。
6. MySQL 主从读写分离：当数据库的写压力增加，cache 层（如 Memcached）只能缓解数据库的读取压力。读写集中在一个数据库上让数据库不堪重负。使用主从复制技术（master-slave 模式）来达到读写分离，以提高读写性能和读库的可扩展性。
7. 分表分库，在 cache 层的高速缓存，MySQL 的主从复制，选择适当的分表策略（尽量避免分出来的多表关联查询），使得数据能够较为均衡地分布到多张表中，并且不影响正常的查询。对数据库进行拆分，从而提高数据库写入能力，即分库【垂直拆分】
8. 负载均衡集群，将大量的并发请求分担到多个处理节点。由于单个处理节点的故障不影响整个服务，负载均衡集群同时也实现了高可用性。

