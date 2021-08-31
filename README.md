# Study 学习资料
## 第三方库
### [wewechat](https://github.com/trazyn/weweChat) electron wechat


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

# markdown语法
![][foryou]
## 目录
* [横线](#横线)
* [标题](#标题)
* [文本](#文本)
    * 文本块
    * 高亮
    * 换行
    * 斜体、粗体、删除线
* [图片](#图片)
* [链接](#链接)
* [列表](#列表)
* [引用](#块引用)
* [表格](#表格)
* [表情](#表情)
* [声明变量](#声明变量)

## 横线
***、---、___可以显示横线效果

------------------
******************
__________________

## 标题
# 一级标题
## 二级标题
### 三级标题
#### 四级标题
##### 五级标题
###### 六级标题

## 文本
### 文本块
    hello
    hello
    hello
 ```
hello
hello
hello
 ```

### 高亮
`linux` `网络编程` `socket` `epoll`
`'''shell`
 ```shell
 echo "hello GitHub" # shell
 ```
 ```js
 document.getElementById("myH1").innerHTML="Welcome to my Homepage"; //javascipt
 ```

### 换行
直接回车不能换行  
可以在上一行文本后面补两个空格

### 斜体、粗体、删除线
语法|效果
 :-----:|:-----:
`*斜体1*`|_斜体1_
`_斜体2_`|_斜体2_
`**粗体1**`|**粗体1**
`__粗体2__`|**粗体2**
`~~删除线~~`|~~删除线~~
`***~~斜粗体删除线1~~***`|_**~斜粗体删除线1~**_
`~~***斜粗体删除线2***~~`|~~_**斜粗体删除线2**_~~

## 图片
基本格式：`![alt](URL focus)`
1. `![baidu](http://www.baidu.com/img/bdlogo.gif "百度logo")`  
   ![baidu](http://www.baidu.com/img/bdlogo.gif "百度logo")
2. `![][foryou]`在文末有foryou的定义  
   ![][foryou]
3. `仓库地址/raw/分支名/图片路径`  
   ![](https://github.com/guodongxiaren/ImageCache/raw/master/Logo/foryou.gif)

## 链接
语法|效果
 ---- | -------------  
`[我的博客](url "悬停显示")`|[我的博客](http://www.baidu.com)
`[我的简介](/vue/read.md)`|[我的简介](/vue/read.md)
`[回到顶部](#readme)`|[回到顶部](#目录)
`[![我的空间][baidu]][foryou]`|[![我的空间][baidu]][foryou]

## 列表
### 无序列表
* 昵称
* 别名
* 英文名

### 多级无序列表
* 编程语言
    * 脚本语言
        * Python

### 有序列表
1. 封装
2. 继承
3. 多态

### 多级有序列表
1. 这是一级的有序列表
    1. 这是二级变成了罗马数字
        1. 这是三级的变成了英文字母
            1. 四级的依旧是英文字母

### 复选框列表
* [x]  分析
* [x]  设计
* [ ]  测试
* [ ]  交付

## 块引用
> **鸡蛋问题**
《关于鸡蛋问题的研究》是张小虫创作的网络小说，发表于17K小说网

数据结构
> 树
> > 二叉树
> > > 平衡二叉树
> > > > 满二叉树

## 表格 对齐方式(:--|:--:|--:) 混合语法
表头|表头
:---: | ---:
![][baidu]|表格<br>单元
**加粗**|[回到首页](#markdown语法)

## 表情
[表情的符号码](http://www.emoji-cheat-sheet.com)  
💚 💔 💓 💗 💕 💞   
:blush::imp::smiling_imp::neutral_face::no_mouth::innocent::alien:  
:yellow_heart::blue_heart::purple_heart::heart::green_heart::broken_heart::heartbeat::heartpulse::two_hearts::revolving_hearts::cupid::sparkling_heart:  
:sparkles::star::star2::dizzy::boom::collision::anger::exclamation::question::notes::running::love_letter::bangbang::o::x::link::radio_button:  
:eyes::snowflake::whale::rose::sunflower::palm_tree::maple_leaf::earth_asia::octocat::gift_heart::gift::tada:  
:cd::dvd::camera::christmas_tree::email::key::mag_right::moneybag::package:  
:chart_with_upwards_trend::calendar::orange_book::soccer::telescope::dart::art::guitar::birthday::hamburger:  
:house::airplane::rocket::warning::cn::recycle::clock1::telephone_receiver::lock::white_check_mark::fire:
## 声明变量
`[foryou]:https://github.com/yangyueguang/Freedom/blob/master/Freedom/Resources/UserData/userLogo.png`

[baidu]:http://www.baidu.com/img/bdlogo.gif
[foryou]:https://github.com/yangyueguang/Freedom/blob/master/Freedom/Resources/UserData/userLogo.png
## [回到顶部](#markdown语法)


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

