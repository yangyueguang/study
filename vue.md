# 一、环境安装
```bash
brew install npm
brew install nodejs
npm install -g cnpm
npm install -g yarn
npm install -g vue
npm install -g vue-cli
npm install -g webpack
npm install -g electron
npm install -g @vue/vue-cli
```

# 二、开发平台
1. [electron](https://www.electronjs.org)
2. [平台介绍](https://ask.dcloud.net.cn/docs)
3. [uni-app](https://uniapp.dcloud.io)
4. [uni-app插件市场](https://ext.dcloud.net.cn)

## 1. VUE
```bash
vue init webpack my-project
cd my-project
yarn install
yarn run dev
yarn serve
yarn build
yarn start
```

### 1.1. 目录解析
```
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
│    │    └── home
│    │        ├── Header.vue
│    │        └── Index.vue
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
```
# 2. electron
electron 就是一个壳，可以用vue开发网页，然后替换掉rander里面的文件即可。或用脚手架创建替换掉里面的东西或者直接在这个脚手架上开发

[electron-vue](https://simulatedgreg.gitbooks.io/electron-vue/content/cn/)
```bash
npm install electron -g
vue init simulatedgreg/electron-vue my-project
cd my-project
yarn 
yarn run dev 
```

## 3. uni-app
```shell
vue create -p dcloudio/uni-preset-vue project_name
cd project_name
yarn
yarn run serve
npm run dev:h5
npm run dev:mp-weixin
npm run build:h5
npm run build:mp-weixin
```
1. 根据生成的build文件夹，用微信开发者工具软件打开该目录。
2. 用手机扫描测试验证调试与开发。
3. 发布上线
4. 编译后目录 # dist下dev和build下的mp-weixin分别为开发和正式环境编译后的项目文件夹

### 3.1. 目录结构
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

## 4. package.json
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

# 5. 常用库
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


# 三、html
## 1. 常用标签

标签 | 解释 
--- | --- 
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

## 2. DOM
### 2.1 Node对象的属性：
```bash
nodeType
nodeName
nodeValue
parentNode
childNodes
firstChild
lastChild
nextSibling
previousSibling
parentElementNode
children
firstElementChild
lastElementChild
nextElementSibling
previousElementSibling
```

### 2.2 DOM操作
```javascript
document.createElement(‘div’)
document.createAttribute(‘class’);
document.createTextNode(‘文本’)   e.innerHTML 
document.createComment(‘注释内容’); 
document.createDocumentFragment();
document.getElementById()
document.documentElement
document.body
document.all[‘’]
e.setAttributeNode(newAttr)
e.appendChild(newTxt/newElement/fragment)
e.insertBefore(newTxt/newElement/fragment, existingChild)
e.removeChild( existingChild );
e.replaceChild( newChild,  existingChild );
e.removeAttribute(‘属性名’);
e.removeAttributeNode(attrNode);
e.innerHTML
e.innerText
e.textContent
e.getAttribute(‘’)
e.attributes[‘’]
e.setAttributeNode()
e.removeAttribute()
e.hasAttribute()
e.getElementsByTagName()
e.getElementsByName()
e.getElementsByClassName()
e.querySelector(): Node
e.querySelectorAll() : NodeList
```

### 2.3 window操作
```javascript
window.alert(‘’)	//弹出一个警告框
window.prompt(‘’)	//弹出一个输入提示框
window.confirm()	//弹出一个确认框
window.close()		//关闭当前窗口
window.open(url, name, features)
window.screen
Window.window = new Window();	
Window.document = new Document();
Window.screen = new Screen();
Window.history = new History();
Window.location = new Location();
Window.navigator = new Navigator();
Window.event = new Event();
setInterval() / clearInterval() / setTimeout() / clearTimeout
```

### 2.4 客户端可以实现页面跳转的方法：
```html
<a href=”url”></a>
<form action="url"></form>
location.href=”url”;    
location.assign(‘url’);
window.open(‘url’);
<meta http-equiv=”Refresh” content=”3;url”/>
```

### 2.5 window.history对象的使用
- length  访问历史中共有多少个页面
- back()	退回到访问历史中的上一个页面
- forward()  前进到访问历史中的下一页页面
- go(num)  直接跳转到访问历史中的下num个页面；go(1)<=>forward(); go(-1)<=>back();

### 2.6 event的类型
```javascript
onclick
ondblclick
onmousedown
onmouseup
onmouseover
onmouseout
onmousemove
touchstart
touchmove
touchcancel
touchend
tap
longtap
onkeydown  // 按键被按下，按键的值尚未被目标接收到
onkeypress // 按键被按下，按键的值已经被目标接收到
onkeyup    // 按键松开
onfocus    // 获得焦点
onblur     // 失去焦点
onchange   // 当表单中的输入项的值发生改变，如select元素。
onsubmit   // 表单被提交时
onload     // 一般用于body元素，指当页面所有元素加载完成
onerror    // 可以用于body、img元素，当发生解析错误时会调用onerror处理方法。
```

### 2.7 H5手册
1. [HTML5新标签](https://www.w3school.com.cn/tags/html_ref_byfunc.asp)
2. [HTML5标准属性](https://www.w3school.com.cn/html5/html5_ref_standardattributes.asp)
3. [HTML5事件属性](https://www.w3school.com.cn/tags/html_ref_eventattributes.asp)

## 3. HTML语法
```html
<!DOCTYPE html>
<html xmlns=””>
<head>
    <base href=””/><!--base标签用于指定当前页面的相对地址的资源的URL基准值-->
    <title></title>
    <meta />
</head>
<body>
    <header>
        <ul>
            <li></li>
        </ul>
        <ol>
            <li></li>
        </ol>
        <dl>
            <li></li>
        </dl>
    </header>
    <nav></nav>
    <aside></aside>
    <footer></footer>
    <article>
        <h1></h1>
        <p></p>
        <pre></pre>
        <hr/>
        <textarea></textarea>
        <b></b><i></i><strong></strong><em></em><u></u><s></s><sub></sub><sup></sup>
        <img/><a></a>
        <br/>
        <font color=’red’ id=”” class=”” style=””  title=””></font>
        <form method=”POST” action="">
            <input type=”file” name=””/>
            <button type="submit"></button>
        </form>
    </article>
    <section>
        <table>
            <caption>2014年达内部门绩效表</caption>
            <thead>
                <tr>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <tr><td></td></tr>
                ....
                <tr><td></td></tr>
            </tbody>
            <tfoot>
                <tr>
                    <td></td>
                </tr>
            </tfoot>
        </table>
    </section>
</body>
</html>
```
HTML转义字符
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

# 四、CSS
## 4.1 尺寸单位

单位|说明
--- | ---
%   |  父元素的百分比
px  |	像素
em  | 标准字体的倍率 
cm  | 厘米
mm  | 毫米
in  | 英寸
pt  | 磅(72磅=1英寸)
upx | uni-app单位0.5px
vw  | 屏幕宽度百分比
vh  | 屏幕高度百分比

## 4.2 选择器

语法 | 样例 | 描述 
--- | --- | ---
.class| .intro |选择所有class="intro"的元素 
#id |#firstname| 选择所有id="firstname"的元素
`*` |`*` |选择所有元素
element |p| 选择所有<p>元素 
element,element| div,p| 选择所有<div>元素和<p>元素 
element element| div p| 选择<div>元素内的所有<p>元素 
element>element| div>p| subviews 选择所有父级是 <div> 元素的 <p> 元素 
element+element| div+p| firstView 选择所有紧接着<div>元素之后的<p>元素 
[attribute]| [target]| 选择所有带有target属性元素 
[attribute=value]| [target=-blank]| 选择所有使用target="-blank"的元素 
[attribute~=value]| [title~=flower]| 选择标题属性包含单词"flower"的所有元素 
:link| a:link| 选择所有未访问链接 
:visited| a:visited| 选择所有访问过的链接 
:active| a:active| 选择活动链接 
:hover| a:hover| 选择鼠标在链接上面时 
:first-letter| p:first-letter| 选择每一个<P>元素的第一个字母 
:first-line| p:first-line| 选择每一个<P>元素的第一行 
:first-child| p:first-child| 指定只有当<p>元素是其父级的第一个子级的样式。 
:before| p:before| 在每个<p>元素之前插入内容 
:after| p:after| 在每个<p>元素之后插入内容
element1~element2| p~ul| 选择p元素之后的每一个ul元素 
[attribute^=value]| a[src^="https"]| 选择每一个src属性的值以"https"开头的元素 
[attribute$=value]| a[src$=".pdf"] |选择每一个src属性的值以".pdf"结尾的元素 
:root| :root |选择文档的根元素 
:empty| p:empty| 选择每个没有任何子级的p元素（包括文本节点）
:not(selector)| :not(p)| 选择每个并非p元素的元素 
:required| :required| 用于匹配设置了 "required" 属性的元素

## 4.3 样式属性
属性 | 可选值 | 说明
--- | --- | ---
align | left, right, center|水平对齐方式
Valign | top, middle, bottom|垂直对齐方式
position|static,float(left/right),relative,ablolute,fixed|元素定位
Display|none,block,inline,inline-block,list-item,table,table-row-group,table-column-group,table-cell,inherit|显示方式
LineType| solid, dotted|线条类型
Border| radius,type,color,image|边框
BoxShadow|x,y,z,color| 阴影
transform|rotate(30deg),translate(50px,100px),scale(2,3),skew(30deg,20deg),matrix,translate3d(x,y,z),scale3d(x,y,z),rotate3d(x,y,z,angle)|变换
Align-content|stretch, center, flex-start, flex-end, space-between, space-around, initial, inherit|内容对齐方式
Align-items|stretch, center, flex-start, flex-end, baseline, initial, inherit|子元素对齐方式
Flex-wrap |nowrap, wrap, wrap-reverse, initial, inherit|子元素换行方式
float| left, right, center|浮动方式
OverFlow |scroll, hidden|超出区域的处理方式
width,height,top,bottom,left,right,font-size,flex|5px|尺寸大小
marging,padding|top,bottom,left|外边框，内边框
color|#FFFFFF rgba(255,0,0,0.5) rgb(255,255,255)|颜色
cursor |·pointer小手 ,·move ,·text,·crosshair十字|设定光标效果
animation| name duration timing-function delay iteration-count direction fill-mode play-state|动画

弹性盒子
```scss
div {
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  align-items: flex-start;
  flex-wrap: wrap;
  align-content: center;
  flex: 1;
}
```
动画
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
div{
  animation: myfirst 3s;
}
```
变形函数: transform
```css
·translate(x)/ translate(x,y)
·translateX(x) / translateY(y)
·scale(x) / scale(x, y) 
·scaleX(x) / scaleY(y)
·rotate(deg) 
·skew(x) / skew(x,y)  
·skewX(x) / skewY(y)
·rotateX(deg) / rotateY(deg) / rotateZ(deg) 沿轴旋转
·translateZ(z)  
·scaleZ(z)  Z轴上进行缩放，需配合X/Y旋转
```
文字特效
```scss
div {
  text-shadow: 0 0 black;
  flex-wrap: nowrap;
  white-space: nowrap;
  text-align: left;
  font-size: 5px;
}
```
箭头
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
背景
```css
background: #00ff00 url('smiley.gif') left top no-repeat fixed center;
background:bg-color bg-image position(right bottom,left top)/bg-size bg-repeat(no-repeat, repeat) bg-origin(content-box padding-box border-box) bg-clip bg-attachment initial|inherit;
background: linear-gradient(to bottom right, red , blue,yellow, green);
background: linear-gradient(180deg, red, blue);
background: radial-gradient(red 5%, green 15%, blue 60%)
```

columns
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

盒子模型
- X轴总空间=MarginLeft + BorderLeft + PaddingLeft + Width+ PaddingRight + BorderRight + MarginRight
- Y轴总空间=MarginTop + BorderTop + PaddingTop + Height+ PaddingBottom + BorderBottom + MarginBottom

border
- border:5px solid #a1a1a1; dotted
- border-radius: 15px 50px 30px 5px;
- border-image:url(border.png) 30 30 round;

animation
- transition: width 2s, height 2s, transform 2s;
- transition: property  duration  timing-function(linear | ease | ease-in | ease-out)  delay;

# 五、小程序教程
## 5.1. 开发资源
1. [开发工具介绍和下载](https://mp.weixin.qq.com/debug/wxadoc/dev/devtools/devtools.html)
2. [注册流程](https://mp.weixin.qq.com/debug/wxadoc/introduction/index.html)
3. [设计规范](https://mp.weixin.qq.com/debug/wxadoc/design/index.html)
4. [开发框架](https://mp.weixin.qq.com/debug/wxadoc/dev/framework/MINA.html)
5. [开发组件](https://mp.weixin.qq.com/debug/wxadoc/dev/component/)
6. [开发API](https://mp.weixin.qq.com/debug/wxadoc/dev/api/)

## 5.2. 小程序公共设置
app.json
```json
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

### 5.3.1 注册程序
function | desc
--- | ---
data |页面的初始数据
onLoad| 监听页面加载
onReady| 监听页面渲染完成
onShow |监听页面显示
onHide |监听页面隐藏
onUnload| 监听页面卸载

### 5.3.2 注册页面
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

## 5.3.3. 语法
```wxml
  <template name="msgItem">
  <view>
    <text> {{index}}: {{msg}} </text>
    <text> Time: {{time}} </text>
    <view wx:if="{{length > 5}}"> 1 </view>
    <view wx:elif="{{length > 2}}"> 2 </view>
    <view wx:else> 3 </view>
    <view wx:for="{{[zero, 1, 2, 3, 4]}}" wx:for-index="idx" wx:for-item="itemName"> {{item}} </view>
    <switch wx:for="{{objectArray}}" wx:key="unique" style="display: block;"> {{item.id}} </switch>
  </view>
</template>
<!-- 这里代表把item对象传入模板 -->
<import src="item.wxml"/>
<template is="msgItem" data="{{...item}}"/>
```

## 5.4. API接口
```javascript
  wx.request({url: 'test.php', data: {x: '' , y: ''}, header: {'Content-Type': 'application/json'}, success: function(res) {
  console.log(res.data)
  }
  })
  wx.uploadFile({url: 'http://example.com/upload', filePath: tempFilePaths[0], name: 'file', formData:{'user': 'test'}})
  wx.downloadFile({url: 'http://example.com/audio/123', type: 'audio', success: function(res) {}})
  wx.connectSocket({url: 'test.php', data:{x: '', y: ''}, header:{'content-type': 'application/json'}, method:"GET"})
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
  wx.onBackgroundAudioPlay(CALLBACK)
  wx.onBackgroundAudioPause(CALLBACK)
  wx.onBackgroundAudioStop(CALLBACK)
  wx.getBackgroundAudioPlayerState(OBJECT)
  wx.playBackgroundAudio(OBJECT)
  wx.pauseBackgroundAudio()
  wx.seekBackgroundAudio(OBJECT)
  wx.stopBackgroundAudio()
  wx.saveFile(OBJECT)
  wx.chooseVideo(OBJECT)
  wx.setStorage({key:"key"data:"value"})
  wx.getStorage({key: 'key', success: function(res) {
  	console.log(res.data)
  }})
  wx.clearStorage()
  wx.getLocation({type: 'wgs84', success: function(res) {
	  var latitude = res.latitude
	  var longitude = res.longitude
	  var speed = res.speed
	  var accuracy = res.accuracy
  }})
  wx.openLocation({latitude: latitude, longitude: longitude, scale: 28})
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
  wx.setNavigationBarTitle({title: '当前页面'})
  wx.showNavigationBarLoading()
  wx.hideNavigationBarLoading()
  wx.navigateTo({url: 'test?id=1'})
  wx.redirectTo({url: 'test?id=1'})
  wx.navigateBack()
  var animation = wx.createAnimation({transformOrigin: "50% 50%", duration: 1000, timingFunction: "ease", delay: 0})
  wx.hideKeyboard()
  wx.stopPullDownRefresh()
  wx.login({success: function(res) {
	  if (res.code) {
		wx.request({url: 'https://test.com/onLogin', data: {code: res.code}})
	  } else {
		console.log('获取用户登录态失败！' + res.errMsg)
	  }
  }});
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
