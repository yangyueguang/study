# VUE框架
## 环境安装
```bash
brew install npm
brew install nodejs
npm install -g cnpm
npm install -g yarn
npm install -g vue
npm install -g vue-cli
npm install -g webpack
npm install -g @vue/vue-cli
```
## VUE创建方式
```bash
vue init webpack my-project
cd my-project
yarn install
yarn run dev
```

## 启动方式
```bash
yarn install
yarn serve
yarn build
yarn start
```

## 部署方式
`sh deploy.sh`或者拷贝dist文件夹和server.js文件以及nginx_config文件夹配置好nginx之后执行`node express.js`

# uni-app
## 开始
```shell
vue create -p dcloudio/uni-preset-vue project_name
cd project_name
yarn
yarn run serve
# 运行并发布uni-app
npm run dev:h5
npm run dev:mp-weixin
npm run build:h5
npm run build:mp-weixin
```
1. 根据生成的build文件夹，用微信开发者工具软件打开该目录。
2. 用手机扫描测试验证调试与开发。
3. 发布上线
4. 编译后目录 # dist下dev和build下的mp-weixin分别为开发和正式环境编译后的项目文件夹

## 目录结构
```
┌─components            uni-app组件目录
│  └─comp-a.vue         可复用的a组件
├─hybrid                存放本地网页的目录
├─platforms             存放各平台专用页面的目录
├─pages                 业务页面文件存放的目录
│  ├─index
│  │  └─index.vue       index页面
│  └─list
│     └─list.vue        list页面
├─static                存放应用引用静态资源（如图片、视频等）的目录，注意：静态资源只能存放于此
├─wxcomponents          存放小程序组件的目录
├─main.js               Vue初始化入口文件
├─App.vue               应用配置，用来配置App全局样式以及监听 应用生命周期
├─manifest.json         配置应用名称、appid、logo、版本等打包信息
└─pages.json            配置页面路由、导航条、选项卡等页面类信息

```

# package.json
```json
{
  "name": "Vue-storeFront",
  "version": "0.1.0",
  "description": "xxx",
  "author": "2829969299@qq.com",
  "private": true,
  "scripts": {
    "serve": "vue-cli-service serve",
    "build": "vue-cli-service build",
    "start": "node server.js",
    "lint": "vue-cli-service lint"
  },
  "dependencies": {
    "express": "^4.16.4",
    "vue": "^2.5.17",
    "vue-fullscreen": "^2.1.6",
    "vue-router": "^3.0.1",
    "vue-slider-component": "^2.8.0",
    "vuex": "^3.0.1",
    "vuex-persistedstate": "^2.5.4",
    "axios": "^0.16.2",
    "compressing": "^1.4.0",
    "copy-dir": "^0.3.0",
    "vconsole": "^3.3.0"
  },
  "devDependencies": {
    "@vue/cli-plugin-babel": "^3.1.1",
    "@vue/cli-plugin-eslint": "^3.1.5",
    "@vue/cli-service": "^3.1.4",
    "vue-template-compiler": "^2.5.17",
    "webpack-cli": "^3.1.2",
    "mint-ui": "^2.2.7",
    "chalk": "^2.0.1"
  },
  "eslintConfig": {
    "root": true,
    "env": {
      "node": true
    },
    "extends": [
      "plugin:vue/essential",
      "eslint:recommended"
    ],
    "rules": {},
    "parserOptions": {
      "parser": "babel-eslint"
    }
  },
  "postcss": {
    "plugins": {
      "autoprefixer": {}
    }
  },
  "engines": {
    "node": ">= 4.0.0",
    "npm": ">= 3.0.0"
  },
  "browserslist": [
    "> 1%",
    "last 2 versions",
    "not ie <= 8"
  ]
}
```

# HTML项目 项目采用VUE框架
## 1. 启动方式
1. git clone $git_url
2. 用WebStorm打开
3. 安装项目配置的依赖库。 `yarn install`  
4. 查看package.json配置的scripts脚本配置。
5. 启动项目。`yarn run start` or `yarn run dev` or `yarn run build`
6. 点开生成的url，就可以在浏览器中看到效果了。

## 2. 目录解析
├── Dockerfile               # docker部署的配置文件 
├── LICENSE                  # 版权说明
├── README.md                # 项目说明文件
├── build                    # 编译构建配置文件包括各个环境的配置文件
├── build.sh                 # docker编译配置文件
├── config                   # 全局配置文件
├── dist                     # 项目build完后生成的网页文件
├── node_modules	         # npm自动加载的项目依赖模块
├── index.html               # 模版文件
├── package-lock.json        # 略
├── package.json             # 启动脚本和三方库的依赖
├── release_version.json     # 发布版本 略
├── server                   # 服务配置文件
├── src                      # 这里是我们要开发的目录，基本上要做的事情都在这个目录里。
│    ├── App.vue              # app界面入口文件
│    ├── assets               # 字体图片样式等文件
│    ├── conf.json            # 配置文件
│    ├── config               # 项目具体配置文件
│    ├── main.js              # 项目启动入口文件
│    ├── model                # 路由、网络请求方法和模型文件
│    │    ├── CommonModel.js
│    │    ├── api.js
│    │    └── index.js
│    ├── page                # 页面文件
│    │    ├── header-nav.vue
│    │    ├── home
│    │    │    ├── Header.vue
│    │    │    └── Index.vue
│    ├── plugins             # 写的一些方法
│    │    └── CircleChart.js
│    ├── router              # 路由与界面的配置
│    │    └── index.js
│    ├── store               # vuex用来界面间传值和存储的
│    │    ├── home
│    │    │    └── state.js
│    │    └── store.js
│    ├── supreme-core        # 第三方库
│    ├── util                # 工具类
│    │    ├── rem.js
│    │    └── util.js
│    └── view                # 界面文件
│        ├── homePage
│        │    ├── AuthorizationLayer.vue
│        │    ├── ContentList.vue
│        │    └── Index.vue
│        └── detailPage
│          ├── Index.vue
│          └── MorePage.vue
├── static                  # 静态资源文件 略
└── test                    # 测试文件

## 4. 开发平台
1. [electron](https://www.electronjs.org)
2. [平台介绍](https://ask.dcloud.net.cn/docs)
1. [uni-app](https://uniapp.dcloud.io)
2. [uni-app插件市场](https://ext.dcloud.net.cn)

## 5. 常用库
1. axios 网络请求库
2. [vue](https://cn.vuejs.org) 前端界面框架
3. vue-awesome-swiper 轮播图
4. vue-pickers 
5. vue-router 路由
6. vuex  界面间传值和存储
7. [webpack](https://webpack.js.org)前端打包工具[github](https://github.com/webpack/webpack)
8. [view-design](https://iviewui.com) i-view视图主要服务于PC界面[源码](https://github.com/iview/iview)
9. [vant](https://youzan.github.io/vant/#/zh-CN)移动端组件库
10. [vant-weapp](https://youzan.github.io/vant-weapp/#/intro) Vant的小程序版本
11. [mint-ui](http://mint-ui.github.io/#!/zh-cn)移动端组件库[源码](https://github.com/ElemeFE/mint-ui)[链接地址](http://elemefe.github.io/mint-ui/#/)
12. [MUI](https://dev.dcloud.net.cn/mui)最接近原生APP体验的高性能框架[源码](https://github.com/dcloudio/mui)
13. [element-ui](https://element.eleme.cn/#/zh-CN)桌面端组件库[源码](https://github.com/ElemeFE/element)
14. [echarts vue-echarts](https://github.com/ecomfe/vue-echarts)e-charts图表
15. [v-charts](https://v-charts.js.org)基于ECharts封装种类更多。[源码](https://github.com/ElemeFE/v-charts)
16. [jqwidgets](https://www.jqwidgets.com/vue/)跨平台跨框架适配的前端UI

## 6. 好的项目
1. [顺风约车](https://github.com/chengzhx76/service-mpvue-mini/)
2. [滴滴打车](https://github.com/QinZhen001/didi)
3. [微信定时发送消息](https://github.com/Mcbai/WeChat-bot)
4. [微信每日说](https://github.com/gengchen528/wechatBot)

# electron
electron 就是一个壳，可以用vue开发网页，然后替换掉rander里面的文件即可。或者使用下面的electron-vue脚手架创建替换掉里面的东西或者直接在这个脚手架上开发

[electron-vue](https://simulatedgreg.gitbooks.io/electron-vue/content/cn/)
```bash
npm install electron -g
npm install vue-cli -g 
npm install webpack -g
vue init simulatedgreg/electron-vue my-project
```
```bash
cd my-project
yarn 
yarn run dev 
```


# html
# 常用标签

标签 | 解释 
----- | --- 
article|标记定义一篇文章
aside|标记定义页面内容部分的侧边栏
audio	|    标记定义音频内容
canvas|	标记定义图片
command|	标记定义一个命令按钮
datalist|	标记定义一个下拉列表
details|	标记定义一个元素的详细内容
dialog|	标记定义一个对话框(会话框)
embed|	标记定义外部的可交互的内容或插件
figure|	标记定义一组媒体内容以及它们的标题
footer|   标记定义一个页面或一个区域的底部
header|	标记定义一个页面或一个区域的头部
hgroup|	标记定义文件中一个区块的相关信息
mark|	    标记定义有标记的文本
meter|	标记定义 measurement within apredefined range
nav|	    标记定义导航链接
output|	标记定义一些输出类型
progress|	标记定义任务的过程
rp|   标记是用在Ruby annotations 告诉那些不支持 Ruby元素的浏览器如何去显示
rt|    标记定义对rubyannotations的解释
ruby|	    标记定义 ruby annotations.
section|	标记定义一个区域
source|	标记定义媒体资源
time|    标记定义一个日期/时间
video|	标记定义一个视频

## DOM
### Node对象的属性：
```bash
nodeType
nodeName
nodeValue
------------------
parentNode
childNodes
firstChild
lastChild
nextSibling
previousSibling
---------------------
parentElementNode
children
firstElementChild
lastElementChild
nextElementSibling
previousElementSibling
-----------------------
e.innerHTML
e.innerText
e.textContent
------------------------
e.getAttribute(‘’)
e.attributes[‘’]
e.setAttributeNode()
e.removeAttribute()
e.hasAttribute()
-------------------------
document.getElementById()
document/e.getElementsByTagName()
document.getElementsByName()
document/e.getElementsByClassName()
e.querySelector(): Node
e.querySelectorAll() : NodeList
document.documentElement
document.body
document.all[‘’]
```
### DOM操作
```
document.createElement(‘div’)
document.createAttribute(‘class’);
document.createTextNode(‘文本’)   e.innerHTML 
document.createComment(‘注释内容’); 
document.createDocumentFragment();
e.setAttributeNode(newAttr)
e.appendChild(newTxt/newElement/fragment)
e.insertBefore(newTxt/newElement/fragment, existingChild)
var deletedChild = parentNode.removeChild( existingChild );
var replacedChild = parentNode.replaceChild( newChild,  existingChild );
element.removeAttribute(‘属性名’);
element.removeAttributeNode(attrNode);
window.alert(‘’)		//弹出一个警告框
window.prompt(‘’)		//弹出一个输入提示框，返回值可能是null / ‘’ / ‘用户输入的字符串’
window.confirm()		//弹出一个确认框，返回值可能是true / false
window.close()		//关闭当前窗口
window.screen
Window.window = new Window();	
Window.document = new Document();
Window.screen = new Screen();
Window.history = new History();
Window.location = new Location();
Window.navigator = new Navigator();
Window.event = new Event();
Window.alert(123);
alert() / prompt() / confirm() 
close() / open(url, name, features) 
setInterval() / clearInterval() / setTimeout() / clearTimeout
window.navigator
window.location
客户端可以实现页面跳转的方法：
(1)<a href=”url”></a>
(2)<form action=”url”></form>
(3)location.href=”url”;    location.assign(‘url’);
(4)window.open(‘url’);
(5)<meta http-equiv=”Refresh” content=”3;url”/>
3.window.history对象的使用
length：访问历史中共有多少个页面
back()	退回到访问历史中的上一个页面
forward()  前进到访问历史中的下一页页面
go(num)  直接跳转到访问历史中的下num个页面； go(1) <=> forward();   go(-1) <=>back();
```
### 节点操作
```
getElementById() / ...ByName() / ...ByClassName() / ...ByTagName() / querySelector() / ...All() / 
createElement() / createTextNode() / createAttribute() / createDocumentFragment()
appendChild() / insertBefore() / setAttributeNode()
removeChild() / removeAttribute()
replaceChild() / setAttributeNode()
```

### event的类型
```
onclick
ondblclick
onmousedown
onmouseup
onmouseover
onmouseout
onmousemove
onkeydown： 按键被按下，按键的值尚未被目标接收到
onkeypress：按键被按下，按键的值已经被目标接收到
onkeyup：按键松开
onfocus：获得焦点
onblur：失去焦点
onchange：当表单中的输入项的值发生改变，如select元素。
onsubmit：表单被提交时
onload：一般用于body元素，指当页面所有元素加载完成
onerror：可以用于body、img元素，当发生解析错误时会调用onerror处理方法。
```


### H5手册
1. [HTML5新标签](https://www.w3school.com.cn/tags/html_ref_byfunc.asp)
2. [HTML5标准属性](https://www.w3school.com.cn/html5/html5_ref_standardattributes.asp)
3. [HTML5事件属性](https://www.w3school.com.cn/tags/html_ref_eventattributes.asp)


复习：
Web三要素：
1. Server
2. Client/Browser
3. HTTP/HTTPS  
http://IP/path/xx.html

HTML语法
```html
<b>hello</b>
<br/>
<i>...</i>
<font color=’red’ id=”” class=”” style=””  title=””>
```
HTML文档的基本结构
```html
<!DOCTYPE html>
<html>
	<head>
		<title></title>
	</head>
	<body>
	</body>
</html>
```
1.HTML转义字符
```
基本格式		&xxxx;
<		&lt;
>		&gt;
空格		&nbsp;
&		&amp;
©		&copy;
®		&reg;
™		&trade;
```
HTML注释：不需要浏览器处理或显示，可用于以后调试或源码读取方便。注意：注释不能嵌套

2.HTML元素的类型：
1. 区块元素(block)：必须处于独立的一行中
2. 内联元素(inline)：可以与其他内容处在一行中

3.Web开发用到的图片格式

格式 | 说明
---- | ----
bmp|未经压缩的bit图，一般不用于Web开发
psd|photoshop doc原始文档，支持层，页面中不直接使用
tiff|出版印刷
raw|太大
jpeg|经过压缩的图片，保真度高，色彩丰富，适用于Web中的照片，1024*768大压缩到100k甚至更小完全可以接受
png|色彩没有jpg丰富，但透明度支持的好，压缩比例大，适合于图标
gif|色彩比较丰富，支持动画效果，也在一定程度支持透明度。

4.页面中使用的资源的路径
* HTML页面中可能用到资源： “图片”、“CSS”、“JS”、“另一个页面

要使用这些资源必须指定资源URL，URL有如下三种：
1. 绝对路径：已协议名开头的路径，如http://www.baidu.com/logo.png
2. 相对路径：不以协议名开头，如g.jpg  ./g.jpg  images/g.jpg   ../g.jpg   ../../../images/g.jpg
3. 根相对路径：以/开头的路径，相对于当前站点的根路径，而与当前页面所在路径无关
* 补充：<head><base href=”http://www.baidu.com/”/></head>base标签用于指定当前页面的相对地址的资源的URL基准值


-------------------------------------



5.TABLE的使用——重点
```html
<table>
	<caption>2014年达内部门绩效表</caption>
	<thead>
		<tr></tr>
	</thead>
	<tbody>
		<tr></tr>
		....
		<tr></tr>
	</tbody>
	<tfoot>
		<tr></tr>
	</tfoot>
</table>
```
6.页面布局

1. TABLE作布局：表格嵌套可能导致页面很复杂不易编辑，浏览体验不好(要么一片空白，要么一次性全部出来)
2. DIV+CSS：当前主流
3. HTML5布局标签：未来趋势


HTML文档的基本结构
```html
<!DOCTYPE html>
<html xmlns=””>
	<head>
		<base href=””/>
		<title></title>
		<meta />
	</head>
	<body>
		<h1></h1>
		<p></p>
		<pre></pre>
		<hr/>
		<table></table>
		<b></b><i></i>
		<strong></strong><em></em>
		<u></u><s></s>
		<sub></sub><sup></sup>
		<img/><a></a>
	</body>
</html>
```
页面布局的三种方式——重点

1. TABLE布局：过时
2. DIV+CSS：当前主流，表达的语义不清
3. HTML5布局标签：未来趋势

HTML5中为了页面布局新增了如下标签：
```html
<header></header>
<nav></nav>
<aside></aside>
<footer></footer>
<article></article>
<section></section>
```
上述标签本质与DIV完全一样，无显示效果，仅仅是一个最简单的区块元素——见名知义

TABLE的两个用途：
(1)	显示批量的数据
(2)	作页面布局
```html
<table>
	<tr>
		<td></td>
	</tr>
</table>
<table>
	<thead>
		<tr><th></th></tr>
	</thead>
	<tbody>
		<tr><td></td></tr>
<tr><td></td></tr>
	</tbody>
	<tfoot>
		<tr><td></td></tr>
	</tfoot>
</table>
```
1.HTML中的列表
1. 无序列表：ul，UnorderedList
2. 有序列表：ol，OrderedList
3. 定义列表：dl，DefinitionList
列表项：li， List Item

2.表单标签的使用——重点/难点
表单(form)：用于收集用户的数据，提交给服务器上某个页面，该页面可以对表单中提交的数据进行保存或查询(由php/jsp/aspx来担当)。


3.表单中实现文件上传必须满足：
1. 表单中使用`<input type=”file” name=””/>`选择文件
2. 表单必须使用POST提交 method=”POST”
3. 表单的编码类型必须声明为  enctype=”multipart/form-data”


常用的HTML标签

注意：Textarea只是纯文本编辑框，要想输入各种样式的文本、图片、表格等需要使用“富文本编辑器”——可使用第三方工具(KindEdtitor / FCKEdtior / CuteEditor)实现此效果
撰稿人——负责内容(Content)
排版人——负责表现(Presentation)
内容是抽象的，必须以某种样式来呈现
样式：字体、前景色、背景色、背景图、间距、边框.......


3.CSS
Cascade Style Sheet 级联样式单/表，层叠样式表，一个元素若附加了某样式，其中的内容及其中的子元素/孙子元素都会施用此样式。
CSS样式可以在如下有如下三种编写方式：
(1)	内联样式(inline)：使用style属性声明在元素中
<div style=""></div>
(2)	内部样式(inner)：
<head><style type=”text/css”></style></head>
(3)	外部样式(outer)：创建一个独立的.css文件
<head>
<link rel=”stylesheet” type=”text/css” href=”x.css”/>
</head>
  使用原则：
·内联样式只对当前元素有效；内部样式对当前整个页面有效；外部样式对所有引用它的页面都有效(可用于控制全站的风格)
·内联样式尽量少用；内部样式可以适量使用(全站中只有一个页面中使用的样式)；推荐使用外部样式(外部文件不要太多)

4.CSS基本语法：
属性名: 属性值;
内部/外部CSS：
选择器{ 	/*该样式的作用*/
属性名: 属性值;
...
属性名: 属性值;
}

5.CSS选择器——重点
说明：JavaScript/jQuery中也可以使用类似于CSS中的选择器进行元素的选择。
(1)通用选择器： *{...}  选择页面中的所有元素
(2)元素选择器：元素名{...} 选择指定的元素 如div{...}
(3)ID选择器：#ID值{...} 仅选择具有指定ID的元素 如#p2{...}
(4)类别选择： .类名{...}选择具有指定class的所有元素  .mark{}
(5)并列/过滤选择器：选择器1选择器2{...} 选择可被两个选择器同时选定的元素  如p.mark{...}  或 .product.mark{...}
(6)子元素选择器：选择器1  选择器2{...}   选择可被选择器1选择的元素下的所有子元素中可被选择器2选中的元素 如div span{...}    		.product  .mark{...}
(7)直接子元素选择器  选择器1>选择器2{...}  选中选择器1中的直接子元素中可被选择器2选中的  如div > span{...} IE6不支持
(8)多选/群组选择器：选择器1,选择器2,...选择器n{...}  选择可被任何一个选择器选中的元素   h2,#main,.mark{...}
(9)伪类选择器： :伪类名{...}  
a:link{...}		选择所有未访问过的超链接
a:visited{...}	选择所有访问过的超链接
元素:hover{...} 当鼠标悬停于元素上方时  IE6只支持a:hover
元素:active{...} 当元素被激活时
input:foucs{...} 当元素获得输入焦点  IE7前都不支持


CSS样式的优先级
!important > 内联样式 > #ID选择器 > 类选择器/伪类选择器 > 元素选择器 > 浏览器预定义样式


6.CSS中的尺寸
相对尺寸：
%:  所占父元素的百分比  如div{width: 50%;}
px:	像素，指屏幕上的一个点  如div{width: 500px;}
em: 倍率，表示标准字体大小的倍率 如div{height: 3em}
绝对尺寸：  在屏幕上使用的Web页面尺寸几乎不用绝对尺寸
cm：厘米
mm：毫米
in：英寸
pt：磅(72磅=1英寸)

7.CSS中的颜色
(1)英文字符表示  如red  green  silver
RGB表示法：
(2)三位整数 rgb(xxx, xxx, xxx)   如span{color: rgb(255,0,0);}
(3)三位百分比  rgb(xx%, xx%, xx%)   如span{color: rgb(30%, 50%,0%);}
(4)六位十六进制数  #XXXXXX  如span{color:#FF0000;}
(5)三位十六进制数  #XXX		如span{color: #FC0;}  => #FFCC00


色彩理论：
原色：能够以一定的比例调配出其它颜色的颜色
加色系：以RedGreenBlue为原色的色彩体系。主动发光的物体发出来的颜色使用加色系，如太阳、火焰、灯、显示屏等。颜色越多越白。
减色系：以CyneMegatonYellow为原色的色彩体系。不会主动发光，而是发射其它光线的物体，使用减色系，如月亮、纸张、油画笔等。颜色越多越黑。
计算机中颜色表示法——加色系：
任意一个颜色都要使用Red、Green、Blue三个原色以一定的比例混合调配出来。
32位真彩色：使用8bit(0-255/00-FF)来描述一个原色的配比量
2^24
64位真彩色：使用16bit(0-65535/0000-FFFF)来描述一个原色的配比量
2^48

练习：配出下列颜色块：红色蓝青品黄白 浅灰 深灰 黑，以及一个和谐色组


8.CSS常用属性——重点/难点



尺寸单位：px  em  %
颜色：	#FF0000  #00FF00   #0000FF
#00FFFF	 #FF00FF	   #FFFF00
#FFF  #000
#FAFAFA		#222	#888
CSS选择器：
*{}	div{}	  #d1{}   .main{}
div.main{}  div .main{}  div>span{}
div,span{}  :link :visited :hover :active :focus
!important>内联>#ID>.class|:hover>DIV>默认
CSS属性：
```css
*{}
div{}
#d1{}
.main{}
div.main{}
div  span{}
div > span{}
div + span{}
div ~ span{}
[href]
[type=submit]
[class~=main]
:target
:enabled
:disabled
:checked
:first-child
:last-child
:only-child
:empty
:not()
:first-letter
:first-line
::selection
```
内容生成
p:before{
content:  ‘’ / url() / counter(xx);
}
p:after{
content: ;
}
-----------
body{
counter-reset: myc1;
}
p:before{
counter-increment: myc1;
content: counter(myc1);
}

多列：
div{
column-count: 4;
column-gap: 10px;
column-rule: 1px solid #aaa;
}


1.变形/转换相关的CSS属性
transform:  none / 2d-3d-func;
transform:  func1()  func2()  func3();
transform-origin: left/center/right  top/center/bottom;  指定变形的原点
注意：(1)所有的变形效果都不会释放或改变原始占用的空间！——与相对定位有点类似。(2)注意Safari的兼容性问题。
1)常见的2D变形函数：
·translate(x)/ translate(x,y)  位移函数
·translateX(x) / translateY(y)
·scale(x) / scale(x, y)  缩放函数，参数是一个表示百分比的小数，如1表100%、0.5表50%、2表200%
·scaleX(x) / scaleY(y)
·rotate(deg)  旋转变形，参数是角度值
·skew(x) / skew(x,y)  倾斜，参数是角度值
·skewX(x) / skewY(y)
2)常见的3D变形函数：
·rotateX(deg) / rotateY(deg) / rotateZ(deg) 沿轴旋转
·translateZ(z)  Z轴位移
·scaleZ(z)  Z轴上进行缩放，需配合X/Y旋转

2.过渡效果
(1)transition-property: none  |  all  |  p1 p2 ; 针对属性
(2)transition-duration：100ms | 3s; 持续时间
(3)transition-timing-function: linear | ease | ease-in | ease-out
(4)transition-delay：100ms | 3s;  延迟时间
(5)transition: property  duration  timing-function  delay ;




变形：transform: 2d-3d-func();
2D变形函数：
translate(x,y)
scale(x,y)
rotate(deg)
skew(deg, deg)
3D变形函数：
rotateX(deg) / rotateY() / rotateZ()
translateZ()
scaleZ()

过渡：由一个状态慢慢的变化到第二个状态
transition: property duration timing-func delay;



3.帧动画
帧动画：在一段比较短的时间内，连续的展示一系列内容变化的图片，就可以实现一个动画的效果；其中的每张图片称为一个“帧(frame)”；电影播放时，1s会播放16帧相关的图片。
补间动画：只需要指定动画变化过程中的“关键帧(keyframe)”，两个关键帧中间的过渡帧由系统来自动填充若干个补间帧。
CSS可使用animation属性实现上述的补间动画效果。
  <style>
	/*定义一个关键帧集合——一个动画*/
@keyframes  myAnim1{ 
0%{	/*起始关键帧帧*/
}
20%{ /*一个关键帧*/
}
30%{
}
80%{
}
100%{ /*结束时的关键帧*/
}
}
/*@keysframes  myAnim2{*/
/*	from{}*/
/*	40%{}*/
/*	to{}*/
/*}*/

div{
	animation: myAnim2  3s;
}
  </style>

与动画调用相关的CSS属性：
·animation-name：动画的名称，即某个@keyframes后声明的动画名。
·animation-duration：动画的持续时间
·animation-timing-function：动画播放速度函数 linear / ease-in / ease-out / ease-in-out
·animation-delay: 播放的延时时间
·animation-iteration-count: 动画播放次数，如3、10、infinite
·animation-direction: 播放方向 normal(第二次播放时从第一帧重新开始)；alternate(第偶数次播放时从最后一帧倒序播放)
·animation：集合属性，按顺序指定name duration timing-function delay count direction

·animation-fill-mode:
-backwards: 动画尚未开始时即处于第一帧的状态
-forwards: 动画完后后保持最后一帧的状态
-both: 上述二者的效果都要
·animation-play-state: paused(动画处于暂停状态) running(动画处于运行状态)
说明：过渡(transition)可以看做一种特殊的动画(animation)——只有开始和结束两个关键帧。


4.CSS Hack
CSS Hack：由于浏览器对于CSS属性有不同的理解或支持程度不同，为了屏蔽这种浏览器方面的不同实现统一的显示效果，或者专门利用这样的不同的显示效果，可以在编写CSS时，针对特定的浏览器或者特定的版本给予特别的代码。
CSS Hack的实现方式：
(1)IE条件语句：只在IE9-有效
<!--[if IE]> 小于IE10的浏览器会看到此句<![endif]-->
<!--[if IE 6]> IE6看到此句<![endif]-->
<!--[if lt IE 8]> 小于IE8的浏览器会看到此句 <![endif]-->
<!--[if lte IE 8]> 小于等于IE8的浏览器会看到此句 <![endif]-->
上述条件语句中可以放置任何CSS/HTML/JS语句。
(2)选择器前缀
<style>
.content{ }	所有浏览器都能理解的选择器
*html  .content{}			只有IE6能理解的选择器
*+html	.content{}		只有IE7能理解的选择器
</style>
(3)属性前缀
<style>
.content{
-webkit-animation: anim1  3s;
-moz-animation: anim1  3s;
-o-animation: anim1  3s;
background: red;		/*所有浏览器都能识别*/
*background:green;	/*IE6/IE7能识别*/
_background:blue;		/*IE6/IE7能识别*/
+background:yellow;	/*IE能识别*/
background: yellow\9\0;	 /*IE9+能识别*/
background: pink !important;  /*IE6无法识别*/
}
</style>


5.页面访问速度优化
(0)硬件/网络优化
(1)数据库优化
(2)服务器优化
(3)前端优化: HTML优化、CSS优化、JS优化
CSS优化方案：
优化原则：尽可能减少HTTP请求数量；尽可能减少每次请求的数据大小
优化方法：
(1)CSS Sprites：背景图滑动门、把很多的小背景图拼接为一副大图——百度“CSS Sprites在线”可以找到很多这样的工具
(2)把CSS放到页面顶部，多用<link href=”x.css”/>代替@import url(x.css)
(3)避免使用CSS表达式
(4)避免空的src和href值
(5)巧用浏览器缓存，把CSS放在尽可能少的HTML外部文件
(6)首页中尽量不用外部CSS
(7)不要在HTML中缩放图像
(8)对JavaScript文件和CSS文件进行压缩(剔除空白/换行/注释等)，减小文件大小。可使用类似YUI Compressor等工具    Yahoo UI Libary




<a href=””></a>
<style>
	body{...}
	/*@import url('xxx.css');*/
</style>



面试题：
<link>和@import引入CSS文件的区别？






复习：
盒子模型：
间距+边框+填充+内容
注意：
(1)	对于内联元素的padding，下排的padding会侵占上排的内容
(2)	对于内联元素的margin，两个元素的水平方向的间距不会合并；竖直方向上间距无效，想更改间距只能使用line-height
(3)	对于内联元素的width和height指定是无效的。

border
background-color:
background-image:

box-shadow: 10px 10px 5px 5px #aaa;
border-radius:5px;
border-image: url() round
background-image: linear-gradient/radial-gradient


1.文本相关的CSS属性
推荐：使用CSS文本属性替代HTML中涉及样式的标签，如B / I / 	NT / CENTER / PRE / U / S / SUB / SUP等
注意：CSS中所有的字体系统的指定都是指让客户端使用本地的某种字体——服务器根本无法得知客户端有无某种字体！

User-Agent：用户代理，一般就是指浏览器
字符编码方式：UTF-8、GBK、Latin-1等，指字符在计算机中保存时对应的数字、编码方式，如GBK中汉字编码为2个字节的二进制；而UTF-8编码中汉字会编码为3个字节的二进制数字。
字体：Arial、Times、宋体、黑体、楷体等


2.与表格相关的CSS属性——重点


3.元素的浮动定位——重点&难点
元素定位的方式：
(1)	流定位：区块元素从上到下一个挨一个紧密排列、内联元素从左到右一个挨一个的紧密排列——元素流；流定位中的元素不能通过left/top属性指定其X/Y坐标。
流定位中，上下排布的区块元素的纵向间距会合并；左右排布的内联元素的横向间距不会合并，需要各自独立计算。
(2)	浮动定位：元素使用float:left/right实现一个“飘起来”的效果，从原始的元素流中脱离，飘到父元素的左/右边框或之前一个飘起来的元素；其它非浮动元素要补上空缺——浮动起来的元素的不占用页面布局空间。
(3)	相对定位
(4)	绝对定位











CSS中的元素定位：
(1)	流定位
(2)	浮动定位		float	   clear

1.元素的显示模式——重点
常用的元素默认有三种显示(display)模式：
(1)	block：如div，独立占一整行，可以指定width/height
(2)	inline：如span，可与其它元素同处一行，不能指定width/height
(3)	inline-block：如img，可与其它元素同处一行，但可以指定width/height
(4)	none：元素消失，且不占用页面流布局空间
(5)	table / table-cell： 就可以像td一样使用vertical-align属性了，IE6-不支持

2.元素的可见性
visibility属性指定元素是否可见，取值：
·visible  元素可见
·hidden  元素隐藏，但不释放所占的页面空间

3.元素的不透明度
opacity:  0.0~1.0之间的小数，  0.0彻底透明(隐藏)   1.0(彻底可见)

4.vertical-align两种应用场合：
(1)用在td/th中或display:table-cell元素中：让当前元素中的文本内容在竖直方向上居中
(2)用在IMG/TEXTAREA等inline-block元素中：让当前元素同一行中的其他元素与自己的竖直方向上的对齐方式

5.设定光标效果
cursor：
·pointer	小手
·move		可移动指示
·text		可在此处进行文本输入
·crosshair	显示为十字

6.列表相关的属性：
list-style-type: 列表项前的提示符号
none / disc / circle / square / decimal / lower-alpha / upper-alpha / lower-roman / upper-roman
list-style-image: 使用图片来代替默认列表项提示符号
list-style-position: outside/inside，列表项的标号处于li外部还是内部
list-style: type image position 集合属性

7.元素的定位——重点
元素的定位方式(position)：
(1)	流定位：无法手动定位，不能指定元素的left/top等属性
(2)	浮动定位(float)：无法手动定位，不能指定元素的left/top等属性
(3)	静态定位(static)：就是流定位
(4)	相对定位(relative)：元素可以指定“相对于其自己作为静态元素时所处位置”的偏移位置；相对定位的元素其原始空间仍然会保留

(5)	绝对定位(absolute)：元素可以指定“相对于已定位的最近的祖先元素的padding位置作为原点”的偏移位置；绝对定位的元素不再占用页面布局空间

(6)	固定定位(fixed)：元素可以指定“相对于最祖先元素(body)的位置作为原点”的偏移位置；且不随着页面内容的滚动而滚动；固定定位的元素不占用页面空间

注意：
(1)static/float定位的元素无法修改z-index(默认是auto，实际值为)；relative/absolute/fixed定位的元素可以修改z-index，值越大越靠近观众，可以为负值。








www.liulanmi.com   浏览迷
百度数据统计 浏览器




作业：
(1)IE8-如何实现半透明？




复习：
盒子模型
X轴总空间=MarginLeft + BorderLeft + PaddingLeft + Width+ PaddingRight + BorderRight + MarginRight
Y轴总空间=MarginTop + BorderTop + PaddingTop + Height+ PaddingBottom + BorderBottom + MarginBottom
区块元素：
·无浮动：竖直方向上排布，相邻元素的Margin会合并，Padding各自独立；
·浮动之后：Padding各自独立；竖直/水平方向Margin上都各自独立
内联元素：水平方向上排布，一行不够自动排布到下一行，
Margin：水平方向上各自独立，不合并；竖直方向上无效。
Padding：水平方向上各自独立；竖直方向上有效但不占用页面空间(即上下两行的padding可能会重叠)


元素的定位
(1)	流/静态定位： 默认/position:static;   不能指定位置
(2)	浮动定位:  float:left/right;	  不能严格指定位置
(3)	相对定位:	position:relative;  使用left/top/right/bottom进行定位
仍占用页面空间；以“其自己的静态定位点”为定位原点
(4)	绝对定位:	position:absolute; 使用left/top/right/bottom进行定位。
不占用页面空间；以“最近的已定位的祖先元素的padding起点”为定位原点，且随着页面内容的滚动而滚动。
(5)	固定定位:	position:fixed;	   使用left/top/right/bottom进行定位
不占用页面空间；以“body”为定位原点，且不随着页面内容的滚动而滚动。

*{}
div{}
#main{}
.product{}
div, span, #d1, .str{}
span.title{}
div  span{}
div > span{}

1.CSS复杂选择器
提示：复杂选择器的使用可以减少页面中id和class的出现频率；使用jQuery可以兼容所有下述复杂选择器。
说明：     :xxx  伪类选择器     ::xxx 伪元素选择器

2.内容生成选择器
XHTML规定：页面内容交给标签来处理；页面表现交给CSS来处理。
但CSS3有些“内容生成”选择器不单单可以呈现样式，还可以向页面中添加内容。
选择器1:before{
.....
content: 纯文本/图像/计数器;
}
选择器1:after{
.....
content: 纯文本/图像/计数器;
}
content属性必须配合:before/:after选择器使用。
计数器的使用：
body{
counter-reset: 计数器名 初始值 [计算器2名 初始值]...;
}
p:before{
content: ‘《’ counter(计数器名) ’》’;
counter-increment: 计数器名 [步增值];
}




3.与内容多列显示相关的CSS样式
column-count: 竖直方向上列的数量
column-gap: 内容列与列间距
column-style: 集合属性  width style color
注意浏览器的兼容性：
·IE11直接使用上述属性
·FF添加-moz-前缀
·Chrome/Safari/Opera添加-webkit-前缀



import UIKit
import Foundation

// 水平对齐方式
enum Alignment {case left, right, center}
// 垂直对齐方式
enum Valign {case top, middle, bottom}
enum specialCode: String {
case lt = "<"
case gt = ">"
case nbsp = " "
case copy = "©"
case trade = "™"
case reg = "®"
}

class HTML: NSObject {
// 横线
class hr: NSObject {
var width: Float?
var size: Float?
var color: UIColor?
var align: Alignment?
}
// 列表
class list: NSObject {
// 列表元素
class li: NSObject {

        }
        // order list
        class ol: NSObject {
            enum olType {// 数字，字母，罗马数字
                case a1, a, A, i, I
            }
            var type: olType?
            var start: Int = 0 // 从第几个顺序开始
            
        }
        // unorder list
        class ul: NSObject {
            enum ulType {
                case disc, circle, square
            }
            var type: ulType?
        }
        // define list
        class dl: NSObject {
            // define item title
            class dt: NSObject {

            }
            // define item detail
            class dd: NSObject {

            }

        }
    }

    // 表单
    class form: NSObject {
        var action: String?
        var method: inputMethod?
        var enctype: String = "multipart/form-data"//text/plain  application/x-www-form-urlencoded
        enum inputMethod {
            case get, post
        }
        class input: NSObject {
            enum inputType {
                case text, submit, password, radio, file, hidden, phone
            }
            var type: inputType?
            var name: String?
            var value = "请输入用户名"
            var style: script?
            var maxlenght: Int? // 最大输入长度
            var disabled: bool? // 不可修改不可提交
            var readOnly: bool? // 不可修改可以提交
            var checked: bool? // radio才有的
        }
    }

    // 标签框 输入域集合
    class fieldset: NSObject {
        // div ...
        // 标签框文本
        class legend: NSObject {

        }
    }

    // 文本输入
    class textarea: NSObject {
        var name: String?
        var rows: Int? // 行数
        var cols: Int? // 列数
        var readOnly: bool?
        var disabled: bool?

    }
    //MARK 富文本编辑器——可使用第三方工具(KindEdtitor / FCKEdtior / CuteEditor)

    // 下拉框
    class select: NSObject {
        var name: String?
        var size: Int?// 行数 不设可以点击展开
        var multiple: bool? // 多选

        class optgroup: NSObject {
            var label: String?

            class option: NSObject {
                var value: String?
                var selected: bool?
            }
        }
    }

    // 嵌入网页
    class iframe: UIWebview {
        var src: String?
        var width: Float?
        var height: Float?
    }


    // 超链接
    class a: NSObject {// <a href="5.html#ch3">
        var href: String?//#：跳到name为某某某的地方
        var target: String?// _blank, _self 打开新的网页还是原有网页跳转
        var name: String?
    }

    // 表格
    class table: NSObject {
        var width: Float?
        var height: Float?
        var align: Alignment?
        var border: Float?
        var cellpadding: Float? // 内边距
        var cellspacing: Float? // 外边距
        var bgcolor: UIColor?
        // 表格名称
        class caption: NSObject {}
        // 表头
        class thead,tbody,tfoot,tr: NSObject {
            var align: Alignment?
            var valign: Valign?
            var bgcolor: UIColor?

            // 标题加粗的cell
            class th: NSObject {}

            // tableDetail cell
            class td: NSObject {
                var align: Alignment?
                var valign: Valign?
                var width: Float?
                var height: Float?
                var colspan: Int? // 跨列
                var rowspan: Int? // 跨行
            }
        }
    }
}

// 字体样式
class textStyle: NSObject {
// 上标字
class sup,sub,mark,b,Strong,i,em,s,u,p
}


import UIKit
import Foundation
# CSS
### 元素的定位
position | desc
---- | ----

//1.流/静态定位:默认/position:static; 不能指定位置
//2.浮动定位:float:left/right; 不能严格指定位置
//3.相对定位:position:relative; 使用left/top/right/bottom进行定位，仍占用页面空间
//4.绝对定位:position:ablolute; 使用left/top/right/bottom进行定位，不占用页面空间
//5.固定定位:position:fixed; 使用left/top/right/bottom进行定位，不占用页面空间
/*
CSS选择器
*/
class picker: NSObject {
/*
.class .intro 选择所有class="intro"的元素 1
#id #firstname 选择所有id="firstname"的元素 1
* * 选择所有元素 2
    element p 选择所有<p>元素 1
    element,element div,p 选择所有<div>元素和<p>元素 1
    element element div p 选择<div>元素内的所有<p>元素 1
    element>element div>p subviews 选择所有父级是 <div> 元素的 <p> 元素 2
    element+element div+p firstView 选择所有紧接着<div>元素之后的<p>元素 2
    [attribute] [target] 选择所有带有target属性元素 2
    [attribute=value] [target=-blank] 选择所有使用target="-blank"的元素 2
    [attribute~=value] [title~=flower] 选择标题属性包含单词"flower"的所有元素 2
    :link a:link 选择所有未访问链接 1
    :visited a:visited 选择所有访问过的链接 1
    :active a:active 选择活动链接 1
    :hover a:hover 选择鼠标在链接上面时 1
    :first-letter p:first-letter 选择每一个<P>元素的第一个字母 1
    :first-line p:first-line 选择每一个<P>元素的第一行 1
    :first-child p:first-child 指定只有当<p>元素是其父级的第一个子级的样式。 2
    :before p:before 在每个<p>元素之前插入内容 2
    :after p:after 在每个<p>元素之后插入内容
    element1~element2 p~ul 选择p元素之后的每一个ul元素 3
    [attribute^=value] a[src^="https"] 选择每一个src属性的值以"https"开头的元素 3
    [attribute$=value] a[src$=".pdf"] 选择每一个src属性的值以".pdf"结尾的元素 3
    :root :root 选择文档的根元素 3
    :empty p:empty 选择每个没有任何子级的p元素（包括文本节点） 3
    :not(selector) :not(p) 选择每个并非p元素的元素 3
    :required :required 用于匹配设置了 "required" 属性的元素 3
    */
    }
    /*
    CSS属性
    */
    class CSS: NSObject {
    // 显示方式
    enum Display {
    case none// 此元素不会被显示。
    case block// 此元素将显示为块级元素，此元素前后会带有换行符。
    case inline// 默认。此元素会被显示为内联元素，元素前后没有换行符。
    case inline-block// 行内块元素。（CSS2.1 新增的值）
    case list-item// 此元素会作为列表显示。
    case table// 此元素会作为块级表格来显示（类似 <table>），表格前后带有换行符。
    case table-row-group// 此元素会作为一个或多个行的分组来显示（类似 <tbody>）。
    case table-column-group// 此元素会作为一个或多个列的分组来显示（类似 <colgroup>）。
    case table-cell// 此元素会作为一个表格单元格显示（类似 <td> 和 <th>）
    case inherit// 规定应该从父元素继承 display 属性的值。
    }

    // 尺寸
    enum Size {
    case px
    case percent // %
    case em
    case auto
    case inherit
    }

    enum LineType {
    case solid, dotted
    }

    // 列数
    enum Columns {
    case column-count// 指定元素应该被分割的列数。
    case column-fill// 指定如何填充列
    case column-gap// 指定列与列之间的间隙
    case column-rule// 所有 column-rule-* 属性的简写
    case column-rule-color// 指定两列间边框的颜色
    case column-rule-style// 指定两列间边框的样式
    case column-rule-width// 指定两列间边框的厚度
    case column-span// 指定元素要跨越多少列
    case column-width// 指定列的宽度
    case columns// 设置 column-width 和 column-count 的简写
    }

    // 背景 包括图片，颜色等
    enum Background {
    //        background: #00ff00 url('smiley.gif') left top no-repeat fixed center;
    //        background:bg-color bg-image position/bg-size bg-repeat bg-origin bg-clip bg-attachment initial|inherit;
    //        background-image: url(img_flwr.gif), url(paper.gif);
    //        background-position: right bottom, left top;
    //        background-repeat: no-repeat, repeat;
    //        background-origin:content-box padding-box border-box;
    //        background-size:100% 100%;
    //        background: linear-gradient(to bottom right, red , blue,yellow, green);
    //        background: linear-gradient(180deg, red, blue);
    //        background: radial-gradient(red 5%, green 15%, blue 60%)
    }

    // 边框
    class Border: NSObject {
    var radius: CGRect?
    var type: LineType?
    var color: UIColor?
    var image: URL?

    }

    // 阴影
    class BoxShadow: NSObject {
    var x: Size?
    var y: Size?
    var z: Size?
    var color: UIColor?
    }

    class transform: NSObject {
    //        transform: rotate(30deg);
    //        transform: translate(50px,100px);
    //        transform: scale(2,3);
    //        transform: skew(30deg,20deg);倾斜
    //        matrix 方法有六个参数，包含旋转，缩放，移动（平移）和倾斜功能
    //        translate3d(x,y,z)
    //        scale3d(x,y,z)
    //        rotate3d(x,y,z,angle)
    }

    // 内容对齐方式
    enum Align-content {
    case stretch, center, flex-start, flex-end, space-between, space-around, initial, inherit
    }
    // 子元素对齐方式
    enum Align-items {
    case stretch, center, flex-start, flex-end, baseline, initial, inherit
    }
    // 子元素换行方式
    enum Flex-wrap {
    case nowrap, wrap, wrap-reverse, initial, inherit
    }
    // 浮动方式
    enum CSFloat {
    case left, right, center
    }
    // 超出区域的处理方式
    enum OverFlow {
    case scroll, hidden
    }


    var display: Display?
    var width  : Size?
    var height  : Size?
    var top  : Size?
    var bottom   : Size?
    var left   : Size?
    var right   : Size?
    var fontsize : Size?
    var marging : CGRect?
    var padding : CGRect?
    var columns : Columns?
    var background: Background?
    var border : Border?
    var font: Size?
    var color: UIColor?
    var box-shadow: BoxShadow?

    /* 不常用的 */
    //    func animation: name duration timing-function delay iteration-count direction fill-mode play-state;
    var align-items: Align-items?
    var flex-flow: NSObject?
    var align-content: Align-content?
    var animation: NSObject?
    var flex: Int?
    var float: CSFloat?
    var overflow: OverFlow?
    var text-decoration = "underline"
    var box-sizing = "border-box"//考虑了padding和bord之后的尺寸大小

    /*弹性盒子*/
    var display: CSS.Display?
    var flex-direction = "row"
    var justify-content: Align-content?
    var align-items: Align-items?
    var flex-wrap: Flex-wrap?
    var align-content: Align-content?
    var flex: Int?// 比例比重

    /*文字特效*/
    var text-shadow: CSS.BoxShadow?
    var text-wrap = "break-word"//   break-all;
    var white-space = "nowrap"// 不换行
    var text-align: Align-content?
    var font-size: Size?

}


# 小程序教程
## 开发资源
1. [开发工具介绍和下载](https://mp.weixin.qq.com/debug/wxadoc/dev/devtools/devtools.html)
2. [注册流程](https://mp.weixin.qq.com/debug/wxadoc/introduction/index.html)
3. [设计规范](https://mp.weixin.qq.com/debug/wxadoc/design/index.html)
4. [开发框架](https://mp.weixin.qq.com/debug/wxadoc/dev/framework/MINA.html)
5. [开发组件](https://mp.weixin.qq.com/debug/wxadoc/dev/component/)
6. [开发API](https://mp.weixin.qq.com/debug/wxadoc/dev/api/)

## 配置
1. app.js  小程序逻辑
2. app.json  小程序公共设置
```jsonpath
{
	"pages":[
		"pages/index/index",
		"pages/logs/index"
	],
	"window":{
		"navigationBarTitleText":"标题",
		"navigationBarBackgroundColor":"#000000",
		"navigationBarTextStyle":"white",
		"backgroundColor":"#ffffff",
		"backgroundTextStyle":"light",
		"enablePullDownRefresh":true
	},
	"tabBar":{
		"color":"#000000",
		"selectedColor":"green",
		"backgroundColor":"red",
		"borderStyle":"black",
		"list":[
			{
				"pagePath":"pages/index/index",
				"text":"首页",
				"iconPath":"images/home.png",
				"selectedIconPath":"images/homeHL.png"
			},
			{
				"pagePath":"pages/logs/logs",
				"text":"日志",
				"iconPath":"images/home.png",
				"selectedIconPath":"images/homeHL.png"
			}
		]
	},
	"networkTimeout":{
		"request":10000,
		"downloadFile":10000
	},
	"debug":true
}
```


3. app.wxss  小程序公共样式表

### 注册程序
function | desc
--- | ---
data |页面的初始数据
onLoad| 监听页面加载
onReady| 监听页面渲染完成
onShow |监听页面显示
onHide |监听页面隐藏
onUnload| 监听页面卸载

### 注册页面
function|desc
---|---
data |页面数据
onLoad|  监听页面加载
onReady| 页面加载成功
onShow |页面显示
onHide |页面隐藏
onUnload| 页面卸载
onPullDownRefresh | 监听页面下拉动作
onReachBottom| 页面上拉触底
onShareAppMessage| 用户点击右上角分享
Any |其他函数

### wxss
- display: inline;
- 从父元素继承: inherit
- 居中: margin: auto;
- 横向浮动布局: float: left;
- 按钮禁用 .disabled {opacity: 0.6;cursor: not-allowed;}
- 箭头
```css
li:after {
    position: absolute;
    right: 10px;
    top: 50%;
    display: inline-block;
    content: "";
    width: 7px;
    height: 7px;
    border: solid #999;
    border-width: 1px 1px 0 0;
    -webkit-transform: translate(0,-50%) rotate(45deg);
    transform: translate(0,-50%) rotate(45deg);
}
```
### 选择器
语法 | 案例 | 说明
--- | --- | ---
.class| .intro	|选择所有class="intro"的元素
#id	|#firstname	|选择所有id="firstname"的元素
*	|*	|选择所有元素
element|	p|	选择所有<p>元素
element,element	|div,p	|选择所有<div>元素和<p>元素
element element	|div p	|选择<div>元素内的所有<p>元素
element>element	|div>p	|subviews 选择所有父级是 <div> 元素的 <p> 元素
element+element	|div+p	|firstView 选择所有紧接着<div>元素之后的<p>元素
[attribute]	|[target]	|选择所有带有target属性元素
[attribute=value]	|[target=-blank]|	选择所有使用target="-blank"的元素
[attribute~=value]|	[title~=flower]|	选择标题属性包含单词"flower"的所有元素
:link|	a:link|	选择所有未访问链接
:visited	|a:visited|	选择所有访问过的链接
:active	|a:active|	选择活动链接
:hover	|a:hover|	选择鼠标在链接上面时
:first-letter|	p:first-letter|	选择每一个<P>元素的第一个字母
:first-line|	p:first-line	|选择每一个<P>元素的第一行
:first-child	|p:first-child|	指定只有当<p>元素是其父级的第一个子级的样式。
:before	|p:before	|在每个<p>元素之前插入内容
:after	|p:after	|在每个<p>元素之后插入内容
element1~element2|	p~ul	|选择p元素之后的每一个ul元素
[attribute^=value]|	a[src^="https"]	|选择每一个src属性的值以"https"开头的元素
[attribute$=value]|	a[src$=".pdf"]	|选择每一个src属性的值以".pdf"结尾的元素
:root	|:root	|选择文档的根元素
:empty	|p:empty|	选择每个没有任何子级的p元素（包括文本节点）
:not(selector)	|:not(p)|	选择每个并非p元素的元素
:required|	:required|	用于匹配设置了 "required" 属性的元素

### 对象属性

display| description
--- | ---
none	|此元素不会被显示。
block	|此元素将显示为块级元素，此元素前后会带有换行符。
inline	|默认。此元素会被显示为内联元素，元素前后没有换行符。
inline-block|	行内块元素。（CSS2.1 新增的值）
list-item	|此元素会作为列表显示。
table	|此元素会作为块级表格来显示（类似 ），表格前后带有换行符。
table-row-group|	此元素会作为一个或多个行的分组来显示
table-column-group|	此元素会作为一个或多个列的分组来显示。
table-cell|	此元素会作为一个表格单元格显示
inherit	|规定应该从父元素继承 display 属性的值。

	- width  width  top  right bottom   left   fontsize   marging   padding auto length	% inherit

	- columns

		- column-count	指定元素应该被分割的列数。
		- column-fill	指定如何填充列
		- column-gap	指定列与列之间的间隙
		- column-rule	所有 column-rule-* 属性的简写
		- column-rule-color	指定两列间边框的颜色
		- column-rule-style	指定两列间边框的样式
		- column-rule-width	指定两列间边框的厚度
		- column-span	指定元素要跨越多少列
		- column-width	指定列的宽度
		- columns	设置 column-width 和 column-count 的简写

	- background

		- background: #00ff00 url('smiley.gif') left top no-repeat fixed center;
		- background:bg-color bg-image position/bg-size bg-repeat bg-origin bg-clip bg-attachment initial|inherit;
		- background-image: url(img_flwr.gif), url(paper.gif);
		- background-position: right bottom, left top;
		- background-repeat: no-repeat, repeat;
		- background-origin:content-box padding-box border-box;
		- background-size:100% 100%;
		- background: linear-gradient(to bottom right, red , blue,yellow, green);
		- background: linear-gradient(180deg, red, blue);
		- background: radial-gradient(red 5%, green 15%, blue 60%)

	- border

		- border:5px solid #a1a1a1; dotted
		- border-radius: 15px 50px 30px 5px;
		- border-image:url(border.png) 30 30 round;

	- font   opacity
		- font:15px
	- color
		- color: #FFFFFF rgba(255,0,0,0.5) rgb(255,255,255)
	- box-shadow: 10px 10px 5px #888888;
	- transform
		- transform: rotate(30deg);
		- transform: translate(50px,100px);
		- transform: scale(2,3);
		- transform: skew(30deg,20deg);
	- 倾斜
		- matrix 方法有六个参数，包含旋转，缩放，移动（平移）和倾斜功能
		- translate3d(x,y,z)
		- scale3d(x,y,z)
		- rotate3d(x,y,z,angle)

	- animation
		-     transition: width 2s, height 2s, transform 2s;
		-   transition: all 2s;
		- 动画组
```css
@keyframes myfirst {
    from {background: red;}
    to {background: yellow;}
}
animation: myfirst 5s;
@keyframes myfirst{
    0%   {background: red;}
    25%  {background: yellow;}
    50%  {background: blue;}
    100% {background: green;}
}
animation: myfirst 5s linear 2s infinite alternate;
```
	- position
		- absolute	
		- fixed
		- align-content
			- align-content: stretch|center|flex-start|flex-end|space-between|space-around|initial|inherit;
		- align-items
			- align-items: stretch|center|flex-start|flex-end|baseline|initial|inherit;
		- animation
			- animation: name duration timing-function delay iteration-count direction fill-mode play-state;
		- flex
			- 1
		- float
			- float:right;
		- overflow
			- overflow: scroll hidden;
		- text-decoration
			- text-decoration:underline
		- box-sizing: border-box;
			- 考虑了padding和bord之后的尺寸大小
		- box-sizing:border-box;
	- 弹性盒子
		- display: flex;
		- flex-direction: row;
		- justify-content: flex-start | flex-end | center | space-between | space-around
			- 对齐方式
		- align-items: flex-start | flex-end | center | baseline | stretch
			- 子视图对齐方式
		- flex-wrap: nowrap|wrap|wrap-reverse|initial|inherit;
			- 子元素换行方式
		- align-content: flex-start | flex-end | center | space-between | space-around | stretch
		-  flex: 1;
			- 比例比重
	- 文字特效
		- text-shadow: 5px 5px 5px #FF0000;
		- text-wrap:break-word   break-all;
			- 长文本换行
		- white-space: nowrap;
			- 不换行
		- text-align: center;
		- font-size: 40px;
### wxml
- 数据绑定`<view> {{ message }} </view>`

- 条件渲染
```wxml
<view wx:if="{{length > 5}}"> 1 </view>
<view wx:elif="{{length > 2}}"> 2 </view>
<view wx:else> 3 </view>
```

- 列表渲染
```wxml
<view wx:for="{{[zero, 1, 2, 3, 4]}}" wx:for-index="idx" wx:for-item="itemName"> {{item}} </view>
<switch wx:for="{{objectArray}}" wx:key="unique" style="display: block;"> {{item.id}} </switch>
```

- 模板
```wxml
  <template name="msgItem">
  <view>
    <text> {{index}}: {{msg}} </text>
    <text> Time: {{time}} </text>
  </view>
</template>
<!-- 这里代表把item对象传入模板 -->
<import src="item.wxml"/>
<template is="msgItem" data="{{...item}}"/>
```

- 事件
    - touchstart	手指触摸动作开始
    - touchmove	手指触摸后移动
    - touchcancel	手指触摸动作被打断，如来电提醒，弹窗
    - touchend	手指触摸动作结束
    - tap	手指触摸后马上离开
    - longtap	手指触摸后，超过350ms再离开

- 引用
    - .class	.intro	选择所有拥有 class="intro" 的组件
    - #id	#firstname	选择拥有 id="firstname" 的组件
    - element	view	选择所有 view 组件
    - element, element	view,.header	checkbox	选择所有文档的 view 组件和所有的 checkbox 组件
    - ::after	view::after	在 view 组件后边插入内容
    - ::before	view::before	在 view 组件前边插入内容

## API接口

### 1 网络

- 发起请求
```javascript
  wx.request({url: 'test.php', data: {x: '' , y: ''}, header: {'Content-Type': 'application/json'},
  success: function(res) {
  console.log(res.data)
  }
  })
```

- 上传下载
```javascript
  wx.uploadFile({url: 'http://example.com/upload', filePath: tempFilePaths[0], name: 'file', formData:{'user': 'test'}})
  wx.downloadFile({url: 'http://example.com/audio/123', type: 'audio', success: function(res) {}})
```
- WebSocket

```javascript
  wx.connectSocket({url: 'test.php', data:{x: '', y: ''},
  header:{'content-type': 'application/json'}, method:"GET"})
  wx.connectSocket({url: 'test.php'})
  wx.onSocketOpen(function(res){
  console.log('WebSocket 连接已打开！')
  })
  wx.onSocketClose(function(res) {
  console.log('WebSocket 已关闭！')
  })
  wx.onSocketError(function(res){
  console.log('WebSocket 连接打开失败，请检查！')
  })
```
### 2 媒体

```javascript
  wx.chooseImage({count: 1, sizeType: ['original', 'compressed'], sourceType: ['album', 'camera'], success: function (res) {
  	var tempFilePaths = res.tempFilePaths
  }})
  wx.previewImage({current: '', urls: []})
  wx.starRecord({success: function(res) {
  	var tempFilePath = res.tempFilePath
  }, fail: function(res) {}
  })
  wx.stopRecord()
// 音频播放控制
  wx.playVoice({filePath: tempFilePath})
  wx.pauseVoice()
  wx.stopVoice()
// 音乐播放控制
  wx.onBackgroundAudioPlay(CALLBACK)
  监听音乐播放。
  wx.onBackgroundAudioPause(CALLBACK)
  监听音乐暂停。
  wx.onBackgroundAudioStop(CALLBACK)
  监听音乐停止
  wx.getBackgroundAudioPlayerState(OBJECT)
  wx.playBackgroundAudio(OBJECT)
  wx.pauseBackgroundAudio()
  wx.seekBackgroundAudio(OBJECT)
  wx.stopBackgroundAudio()
// 文件
  wx.saveFile(OBJECT)
 // 视频
  wx.chooseVideo(OBJECT)
  ```

### 3 数据


```javascript
  wx.setStorage({key:"key"data:"value"})
  wx.getStorage({key: 'key', success: function(res) {
  	console.log(res.data)
  }})
  wx.clearStorage()
```
### 4 位置

```javascript
  wx.getLocation({type: 'wgs84', success: function(res) {
	  var latitude = res.latitude
	  var longitude = res.longitude
	  var speed = res.speed
	  var accuracy = res.accuracy
  }})
  wx.openLocation({latitude: latitude, longitude: longitude, scale: 28})
```
### 5 设备

```javascript
// 网络状态
  wx.getNetworkType({success: function(res) {
  	var networkType = res.networkType // 返回网络类型 2g，3g，4g，wifi
  }
  })
// 系统信息
  wx.getSystemInfo({success: function(res) {
  	console.log(res)
  }})
// 重力感应
  wx.onAccelerometerChange(function(res) {
  	console.log(res)
  })
// 罗盘
  wx.onCompassChange(function (res) {
  	console.log(res.direction)
  })
```
### 6 界面
```javascript
// 设置导航条
  wx.setNavigationBarTitle({title: '当前页面'})
  wx.showNavigationBarLoading()
  wx.hideNavigationBarLoading()
// 导航
  wx.navigateTo({url: 'test?id=1'})
  wx.redirectTo({url: 'test?id=1'})
  wx.navigateBack()
// 动画
  var animation = wx.createAnimation({transformOrigin: "50% 50%", duration: 1000, timingFunction: "ease", delay: 0})
// 收起键盘
  wx.hideKeyboard()
// 下拉刷新
  wx.stopPullDownRefresh()
```
### 7 开放接口

```javascript
// 登录
  wx.login({success: function(res) {
	  if (res.code) {
		wx.request({url: 'https://test.com/onLogin', data: {code: res.code}})
	  } else {
		console.log('获取用户登录态失败！' + res.errMsg)
	  }
  }});

// 用户信息
  wx.getUserInfo({success: function(res) {
	  var userInfo = res.userInfo
	  var nickName = userInfo.nickName
	  var avatarUrl = userInfo.avatarUrl
	  var gender = userInfo.gender //性别 0：未知、1：男、2：女
	  var province = userInfo.province
	  var city = userInfo.city
	  var country = userInfo.country
  }})

// 微信支付
  wx.requestPayment({'timeStamp': '', 'nonceStr': '', 'package': '', 'signType': 'MD5', 'paySign': '',
  'success':function(res){},
  'fail':function(res){}
  })
```

### 模板消息
```wxml
  <template name="item">
	  <text>{{text}}</text>
  </template>
  在 index.wxml 中引用了 item.wxml，就可以使用 item 模板：
  <import src="item.wxml"/>
  <template is="item" data="{{text: 'forbar'}}"/>
```
