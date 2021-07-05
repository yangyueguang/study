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