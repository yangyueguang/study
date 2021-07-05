## 常用标签
```
<article>	标记定义一篇文章
<aside>	    标记定义页面内容部分的侧边栏
<audio>	    标记定义音频内容
<canvas> 	标记定义图片
<command>	标记定义一个命令按钮
<datalist>	标记定义一个下拉列表
<details> 	标记定义一个元素的详细内容
<dialog> 	标记定义一个对话框(会话框)
<embed> 	标记定义外部的可交互的内容或插件
<figure> 	标记定义一组媒体内容以及它们的标题
<footer>    标记定义一个页面或一个区域的底部
<header> 	标记定义一个页面或一个区域的头部
<hgroup> 	标记定义文件中一个区块的相关信息
<mark> 	    标记定义有标记的文本
<meter> 	标记定义 measurement within apredefined range
<nav> 	    标记定义导航链接
<output> 	标记定义一些输出类型
<progress> 	标记定义任务的过程
<rp> 	    标记是用在Ruby annotations 告诉那些不支持 Ruby元素的浏览器如何去显示
<rt> 	    标记定义对rubyannotations的解释
<ruby> 	    标记定义 ruby annotations.
<section> 	标记定义一个区域
<source> 	标记定义媒体资源
<time> 	    标记定义一个日期/时间
<video> 	标记定义一个视频 
```
## DOM
### Node对象的属性：
```
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
(1)	Server
(2)	Client/Browser
(3)	HTTP/HTTPS
http://IP/path/xx.html

HTML语法
<b>hello</b>
<br/>
<i>...</i>
<font color=’red’ id=”” class=”” style=””  title=””>

HTML文档的基本结构
<!DOCTYPE html>
<html>
	<head>
		<title></title>
	</head>
	<body>
	</body>
</html>

1.HTML转义字符
 基本格式：  &xxxx;
	<		&lt;
	>		&gt;
	空格	&nbsp;
	&		&amp;
	©		&copy;
	®		&reg;
	™		&trade;

 HTML注释：不需要浏览器处理或显示，可用于以后调试或源码读取方便。注意：注释不能嵌套


2.HTML元素的类型：
  (1)区块元素(block)：必须处于独立的一行中
  (2)内联元素(inline)：可以与其他内容处在一行中

3.Web开发用到的图片格式
  bmp：未经压缩的bit图，一般不用于Web开发
  psd：photoshop doc原始文档，支持层，页面中不直接使用
  tiff：出版印刷
  raw：太大
  --------
  jpeg：经过压缩的图片，保真度高，色彩丰富，适用于Web中的照片，1024*768大压缩到100k甚至更小完全可以接受
  png：色彩没有jpg丰富，但透明度支持的好，压缩比例大，适合于图标
  gif：色彩比较丰富，支持动画效果，也在一定程度支持透明度。
  
4.页面中使用的资源的路径
  HTML页面中可能用到资源：
“图片”、“CSS”、“JS”、“另一个页面
  要使用这些资源必须指定资源URL，URL有如下三种：
(1)	绝对路径：已协议名开头的路径，如http://www.baidu.com/logo.png
(2)	相对路径：不以协议名开头，如g.jpg  ./g.jpg  images/g.jpg   ../g.jpg   ../../../images/g.jpg
(3)	根相对路径：以/开头的路径，相对于当前站点的根路径，而与当前页面所在路径无关
补充：<head><base href=”http://www.baidu.com/”/></head>
base标签用于指定当前页面的相对地址的资源的URL基准值

5.TABLE的使用——重点
  (1)显示批量的数据
  (2)作页面布局——过时(Deprecated)
  <table>
	<tr>
		<td></td>
	</tr>  
</table>
表格的最完整形式
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

6.页面布局
   
(1)	TABLE作布局：表格嵌套可能导致页面很复杂不易编辑，浏览体验不好(要么一片空白，要么一次性全部出来)
(2)	DIV+CSS：当前主流
(3)	HTML5布局标签：未来趋势
所过的HTML标签

meta data：元数据—描述数据的数据
BookName		Price		AuthorPhone
tom   			38    		6565
复习：
block：独立占一行，div
inline：可与其它共处一行，span

HTML文档的基本结构
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

页面布局的三种方式——重点
(1)	TABLE布局：过时
(2)	DIV+CSS：当前主流，表达的语义不清
(3)	HTML5布局标签：未来趋势
HTML5中为了页面布局新增了如下标签：
<header></header>
<nav></nav>
<aside></aside>
<footer></footer>
<article></article>
<section></section>
上述标签本质与DIV完全一样，无显示效果，仅仅是一个最简单的区块元素——见名知义

TABLE的两个用途：
(1)	显示批量的数据
(2)	作页面布局
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

1.HTML中的列表
  (1)无序列表：ul，UnorderedList
  (2)有序列表：ol，OrderedList
  (3)定义列表：dl，DefinitionList
  列表项：li， List Item

2.表单标签的使用——重点/难点
  表单(form)：用于收集用户的数据，提交给服务器上某个页面，该页面可以对表单中提交的数据进行保存或查询(由php/jsp/aspx来担当)。


3.表单中实现文件上传必须满足：
  (1)表单中使用<input type=”file” name=””/>选择文件
  (2)表单必须使用POST提交 method=”POST”
  (3)表单的编码类型必须声明为  enctype=”multipart/form-data”

4.HTML中的按钮
  (1)<button></button>   在表单外调用一个js函数时使用
  (2)<input type=”button” value=””/>  在表单内调用一个js函数时使用
  (3)<input type=”submit” value=””/>  在表单内提交表单
  (4)<input type=”reset” value=””/>  在表单内重置所有输入域为初始值
  (5)<input type=”image” src=””/>  在表单内显示一个图片按钮，可用于提交表单，作用于<input type=”submit”/>一样

常用的HTML标签

注意：Textarea只是纯文本编辑框，要想输入各种样式的文本、图片、表格等需要使用“富文本编辑器”——可使用第三方工具(KindEdtitor / FCKEdtior / CuteEditor)实现此效果
撰稿人——负责内容(Content)
排版人——负责表现(Presentation)
内容是抽象的，必须以某种样式来呈现
样式：字体、前景色、背景色、背景图、间距、边框.......

1.HTML的历史
  Netscape Navigator，Microsoft IE分别添加很多标签——彼此不兼容；W3C对HTML标签进行了统一。 
  HTML1.0
  HTML2.0
  HTML3.0
  HTML4.0 
  XHTML1.0   XML  eXtensiable
	严格版(strict)：(1)使用严格XML语法(2)禁用样式相关的标签和属性
	过渡版(transitional)：(1)使用严格的XML语法(2)允许使用废弃的样式相关标签和属性
  HTML5

2.面试题：XHTML1.0对HTML4.0的改进
  (1)借鉴了XML的写法，语法更加严格
  (2)把页面的内容和样式分离了：废弃了HTML4中的表示样式的标签和属性，推荐使用CSS来描述页面的样式
 	 
  HTML4.0中为了丰富显示效果，设计的很多标签和属性把页面的“内容”和“表现”混杂在一起：导致页面内容杂乱，不便于理解和修改。
  

3.CSS
  Cascade Style Sheet 级联样式单/表，层叠样式表，一个元素若附加了某样式，其中的内容及其中的子元素/孙子元素都会施用此样式。
  CSS样式可以在如下有如下三种编写方式：
(1)	内联样式(inline)：使用style属性声明在元素中
<div style=””></div>
(2)	内部样式(inner)：
<head><style type=”text/css”>...</style></head
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
	

面试题：CSS样式的优先级
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












  

复习：
XHTML:(1)语法严格 (2)废弃了样式标签和属性，只负责内容   H2  P  TABLE  IMG

CSS编写位置：
内联	内部  	外部

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





复习：
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
@keysframes  myAnim2{
	from{/*起始关键帧*/
}
40%{ /*一个关键帧*/
}
to{ /*结束关键帧*/
}
}

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
	@import url(xxx.css);
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



