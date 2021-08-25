# 一、环境安装
- 安装：
  ```bash
  brew install nodejs
  brew install yarn
  node -v
  yarn add $package_name
  node xxx.js
  ```
- 生成 package.json `npm init --yes` 

# 二、语法
```javascript
class Person{
    static getInstance(){   /*单例*/
        if(!Person.instance){
            Person.instance=new Person('a', 23);
        }
        return Person.instance;
    }
    constructor(name,age){ /*类的构造函数，实例化的时候执行，new的时候执行*/
        this.name=name;
        this.age=age;
    }
    static work(){   /*静态方法*/
        console.log('这是es6里面的静态方法');
    }
    run(){
        console.log('姓名:' + this.name + '年龄:' + this.age);
    }
}
class Web extends Person{  //继承了Person extends super(name,age);
    constructor(name,age,sex){
        super(name,age);   /*实例化子类的时候把子类的数据传给父类*/
        this.sex=sex;
    }
    print(){
        console.log(this.sex);
    }
}
var w=new Web('张三','30','男');
w.getInfo();
Person.work();
```

# 三、server
## 1. http
```javascript
var http = require('http');
var fs = require('fs');
var url = require('url');
http.createServer( function (request, response) {
    var pathname = url.parse(request.url).pathname;
    console.log("Request for " + pathname + " received.");
    fs.readFile(pathname.substr(1), function (err, data) {
        if (err) {
            console.log(err);
            response.writeHead(404, {'Content-Type': 'text/html'});
        }else{
            response.writeHead(200, {'Content-Type': 'text/html'});
            response.write(data.toString());
        }
        response.end();
    });
}).listen(8080);
console.log('Server running at http://127.0.0.1:8080/');
```

## 2. koa（不推荐）
koa应用生成器
```bash
npm install koa-generator -g
koa koa_demo
npm start
```
```javascript
var Koa=require('shell/koa');
path=require('path');
session = require('koa-session');
var router = require('koa-router')();
render = require('koa-art-template');
bodyParser=require('koa-bodyparser');
var app=new Koa();
render(app, {
    root: path.join(__dirname, 'views'),
    extname: '.html',  
    debug: process.env.NODE_ENV !== 'production'
});
app.keys = ['some secret hurr'];
const CONFIG = {
    key: 'koa:sess', 
    maxAge: 10000,
    overwrite: true,
    httpOnly: true,
    signed: true,
    rolling: true,
    renew: false
};
app.use(bodyParser());
app.use(session(CONFIG, app));
app.use(async (ctx,next)=>{
    console.log(new Date());
    next();
    console.log('匹配路由完成以后又会返回来执行中间件');
    if(ctx.status==404){ 
        ctx.status = 404;
        ctx.body="这是一个 404 页面"
    }else{
        console.log(ctx.url);
    }
});
app.use(async (ctx,next)=>{
    console.log('这是第二层中间件');
    await next();
    console.log('返回的时候先走第二层中间件再往上走');
})
router.get('/',async (ctx)=>{
    ctx.body="首页";
    //koa中没法直接设置中文的cookie 需要用buffer处理 英文不用
    var info=new Buffer('张三').toString('base64');
    ctx.cookies.set('userinfo',info,{maxAge:60*1000*60, httpOnly:false,});
    var userinfo=ctx.cookies.get('userinfo');
    var userinfo=new Buffer(userinfo, 'base64').toString();
    console.log(ctx.session.userinfo);
    ctx.session.userinfo='张三';
    let list={name:userinfo};
    await ctx.render('index',{list:list});
})
router.get('/news',async (ctx, next)=>{
    ctx.body="新闻列表页面";
    await next();
})
router.get('/news',async (ctx)=>{
    ctx.body="新闻列表页面";
})
router.get('/login',async (ctx)=>{
    ctx.body="新闻列表页面";
    // ctx.redirect(ctx.state.__ROOT__+'/admin');
})
// 子路由
// var subapi=require('./api.js');
// router.use('/api',subapi.routes());
app.use(router.routes());
app.use(router.allowedMethods());
app.listen(8080);
//增加socket通信功能
const IO = require('koa-socket');
const io = new IO();
io.attach(app);
app._io.on( 'connection', socket => {
    console.log('建立连接了');
    var roomid=url.parse(socket.request.url,true).query.roomid;
    socket.join(roomid);
    socket.on('addCart',function(data){
        console.log(data);
        //socket.emit('serverEmit','我接收到增加购物车的事件了');  /*发给指定用户*/
        //app._io.emit('serverEmit','我接收到增加购物车的事件了');  /*广播*/
        //app._io.to(roomid).emit('serverEmit','我接收到增加购物车的事件了');
        socket.broadcast.to(roomid).emit('serverEmit','我接收到增加购物车的事件了');
    })
});


/* 这是api.js里面写的代码用于配置子路由
var router=require('koa-router')();
router.get('/news',(ctx)=>{
    ctx.body='新闻管理'
});
module.exports=router;
*/
```
## 3. express（推荐使用）
```javascript
var express = require('shell/express');
var port = process.env.PORT || 8080;
var app = express();
var path = require('path');
app.use(express.static(path.resolve(__dirname, 'dist')));
app.get('*', function (req, res) {
    res.sendFile(__dirname + '/dist/index.html')
})
var cookieParser = require('cookie-parser')
var bodyParser = require('body-parser');
var multer  = require('multer');
var util = require('./util');
var session = require("express-session");
app.use(cookieParser())
// app.use(cookieParser('sign')); // 表示用加密
app.use(session({
    secret: 'this is string key',   
    name:'session_id',
    resave: false,   
    saveUninitialized: true,   
    cookie: {
        maxAge:5000    
    },  
    rolling:true, //在每次请求时强行设置 cookie，这将重置 cookie 过期时间（默认：false）
    // store:new MongoStore({
    //     url: 'mongodb://127.0.0.1:27017/shop', 
    //     touchAfter: 24 * 3600   //，您在24小时内只更新一次会话，不管有多少请求(除了在会话数据上更改某些内容的除外)
    // })
}));
var fs = require("fs");
var urlencodedParser = bodyParser.urlencoded({ extended: false })
app.use('/public', express.static('public'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(multer({ dest: '/tmp/'}).array('image'));
app.use(function(req,res,next){
    console.log(new Date());
    next(); // 路由继续向下匹配
});
app.use('/news',function(req,res,next){ 
    console.log('新闻路由中间件通过app.use');
    next();
});
app.get('/news',function(req,res,next){ 
    console.log('这是路由中间件');
    next();
});
app.get('/index.htm', function (req, res) {
    res.sendFile( __dirname + "/" + "index.htm" );
});
app.get('/process_get/\d*', function (req, res) {
    var response = {
        "first_name":req.query.first_name,
        "last_name":req.query.last_name
    };
    console.log(response);
    res.end(JSON.stringify(response));
})
app.get('/:id', function (req, res) {
    var user = {num: req.params.id}
    res.end( JSON.stringify(user));
})
app.post('/news', urlencodedParser, function (req, res) {
    var response = {
        "first_name":req.body.first_name,
        "last_name":req.body.last_name
    };
    console.log(response);
    res.end(JSON.stringify(response));
})
app.post('/file_upload', function (req, res) {
    console.log(req.files[0]); 
    var des_file = __dirname + "/" + req.files[0].originalname;
    fs.readFile(req.files[0].path, 'utf8', function (err, data) {
        fs.writeFile(des_file, data, function (err) {
            if(err){
                console.log(err);
            }else{
                response = {
                    message:'File uploaded successfully',
                    filename:req.files[0].originalname
                };
            }
            console.log(response);
            res.end(JSON.stringify(response));
        });
    });
})
app.get('/news', function (req, res) {
    console.log("Cookies: " + util.inspect(req.cookies));
    console.log(req.cookies);
    console.log(req.signedCookies);   
    // maxAge  过期时间 domain:'.aaa.com' 多个二级域名共享cookie
    // path  表示在哪个路由下面可以访问cookie signed属性设置成true 表示加密cookie信息
    res.cookie('username','cookie的值',{maxAge:60000});
    if(req.session.userinfo){
        res.send('你好'+req.session.userinfo+'欢迎回来');
    }else{
        res.send('未登录');
    }
    //销毁
    // req.session.destroy(function(err){
    //     console.log(err);
    // });
    // res.send('退出登录成功');
    req.session.userinfo="zhangsan";
    res.send('Hello World');
})
app.use(function(req,res){
    res.status(404).send('这是404 表示路由没有匹配到')
})
var server = app.listen(port, function () {
    var host = server.address().address;
    var port = server.address().port;
    console.log(host)
    console.log("应用实例，访问地址为 http://localhost:%s", port)
});

```
## 4. chat server
```javascript
let express = require('express')
let socket = require('socket.io')
let http = require('http')
let app = express()
let server = http.createServer(app)
let io = socket.listen(server)
let users = [];
// app.use('/', express.static(__dirname + '/www'));
server.listen(process.env.PORT || 3333);// publish to heroku
io.sockets.on('connection', function (socket) {
  socket.on('login', function (nickname) {
    if (users.indexOf(nickname) > -1) {
      socket.emit('nickExisted', nickname, users);
    } else {
      socket.nickname = nickname;
      users.push(nickname);
      socket.emit('loginSuccess', nickname, users);
      io.sockets.emit('system', nickname, users, 'login');
    }
  });
  socket.on('disconnect', function () {
    if (socket.nickname != null) {
      users.splice(users.indexOf(socket.nickname), 1);
      socket.broadcast.emit('system', socket.nickname, users, 'logout');
    }
  });
  socket.on('postMsg', function (msg, color) {
    console.log(msg)
    socket.broadcast.emit('newMsg', socket.nickname, msg, color);
  });
  socket.on('img', function (imgData, color) {
    socket.broadcast.emit('newImg', socket.nickname, imgData, color);
  });
});
```

## 5. socket
```javascript
var fs = require('fs');
var url = require('url');
var express=require('shell/express');
var http=require('http');
var exp=express();
var app = http.Server(exp);
exp.get('/',function(req,res){
    fs.readFile('app.html',function(err,data){
        res.writeHead(200,{"Content-Type":"text/html;charset='utf-8'"});
        res.end(data);
    })
});
app.listen(8000,'127.0.0.1');
var io = require('socket.io')(app);
io.on('connection', function (socket) {
    console.log('建立链接');
    socket.on('message',function(data){
        console.log(data);
        // io.emit('servermessage',data);  
        var msg=data||'';  
        socket.emit('servermessage',msg);
    });
    console.log(socket.request.url);
    var roomid=url.parse(socket.request.url,true).query.roomid;
    socket.join(roomid);
    socket.on('addCart',function(data){
        console.log(data);
        // socket.emit();   /*谁给我发信息我把信息广播给谁*/
        // io.emit() ;   /*群发  给所有连接服务器的客户都广播数据*/
        // socket.emit('to-client','我是服务器的数据'+data.client);
        // io.to(roomid).emit('servermessage','Server AddCart Ok'); //通知分组内的所有用户
        socket.broadcast.to(roomid).emit('servermessage','Server AddCart Ok'); //通知分组内的用户不包括自己
    })
});
```

## 6. WEBSOCKET
```javascript
const WebSocket = require('ws')
const ws = new WebSocket.Server({ port: 8081, host: '10.9.64.101' })
let clients = {}
let clientName = 0
ws.on('connection', (client) => {
  client.name = ++clientName
  clients[client.name] = client
  client.on('message', (msg) => {
    console.log(clients)
    for (var key in clients) {
      clients[key].send(client.name + ' 说：' + msg)
    }
  })
  client.on('close', () => {
    delete clients[client.name]
    console.log(client.name + ' 离开了~')
  })
})
```

## 7. net socket
```javascript
const net = require('net')
const server = new net.createServer()
let clients = {}
let clientName = 0
server.on('connection', (client) => {
  client.name = ++clientName
  clients[client.name] = client
  client.on('data', (msg) => {
    console.log('客户端传来：' + msg);
    for (var key in clients) {
      clients[key].write(client.name + ' 说：' + msg.toString())
    }
  })
  client.on('error', (e) => {
    console.log('client error' + e);
    client.end()
  })
  client.on('close', (data) => {
    delete clients[client.name]
    console.log(client.name + ' 下线了');
  })
})
server.listen(9000, 'localhost')
```
 
## 8. client socket
```javascript
    var net = require('net')
const readline = require('readline')
var socket = new net.Socket()
socket.setEncoding = 'UTF-8'
socket.connect(9000, '127.0.0.1', () => {
  socket.write('hello.')
})
socket.on('data', (msg) => {
  console.log(msg.toString())
  r1.question('请输入：\n', (inputMsg) => {
    if (inputMsg != 'bye') {
      socket.write(inputMsg + '\n')
    } else {
      socket.destroy()
      r1.close()
    }
  })
})
socket.on('error', function (err) {
  console.log('error' + err);
})

socket.on('close', function () {
  console.log('connection closeed');
})
const r1 = readline.createInterface({
  input: process.stdin,
  output: process.stdout
})
```

```html
<!DOCTYPE html>
<html>
  <head>
    <title>socket通信</title>
    <meta charset="UTF-8">
    <script src="http://127.0.0.1:8000/socket.io/socket.io.js"></script>
  </head>
  <body>
    <input type="text" id="msg"/><br/><br/>
    <button id="send">发送</button>
  </body>
</html>
<script>
    var socket = io.connect('http://127.0.0.1:8000/?roomid=1');
    var btn=document.getElementById('send');
    var msg=document.getElementById('msg');
    btn.onclick= function () {
        socket.emit('message',msg.value);
        socket.emit('addCart',{client:'我是客户端的数据'})
    };
    socket.on('servermessage',function(data){
        console.log(data)
    })
</script>
```
# 四、note
1. rem
```javascript
(function(doc, win) {
    var docEl = doc.documentElement,
        resizeEvt = 'orientationchange' in window ? 'orientationchange' : 'resize',
        recalc = function() {
            var clientWidth = docEl.clientWidth;
            if (!clientWidth) return;
            docEl.style.fontSize = 100 * (clientWidth / 1080) + 'px';
        };
    if (!doc.addEventListener) return;
    win.addEventListener(resizeEvt, recalc, false);
    doc.addEventListener('DOMContentLoaded', recalc, false);
})(document, window);
```
2. regular
```javascript
export const regExpConfig = {
  IDcard: /^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$|^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/, // 身份证
  mobile: /^1([3|4|5|7|8|])\d{9}$/, // 手机号码
  telephone: /^(\(\d{3,4}\)|\d{3,4}-|\s)?\d{7,14}$/, // 固定电话
  num: /^[0-9]*$/, // 数字
  phoneNo: /(^1([3|4|5|7|8|])\d{9}$)|(^(\(\d{3,4}\)|\d{3,4}-|\s)?\d{7,14}$)/, // 电话或者手机
  policeNo: /^[0-9A-Za-z]{4,10}$/, // 账号4-10位数字或字母组成
  pwd: /^[0-9A-Za-z]{6,16}$/, // 密码由6-16位数字或者字母组成
  isNumAlpha: /^[0-9A-Za-z]*$/, // 字母或数字
  isAlpha: /^[a-zA-Z]*$/, // 是否字母
  isNumAlphaCn: /^[0-9a-zA-Z\u4E00-\uFA29]*$/, // 是否数字或字母或汉字
  isPostCode: /^[\d\-]*$/i, // 是否邮编
  isNumAlphaUline: /^[0-9a-zA-Z_]*$/, // 是否数字、字母或下划线
  isNumAndThanZero: /^([1-9]\d*(\.\d+)?|0)$/, // 是否为整数且大于0/^[1-9]\d*(\.\d+)?$/
  isNormalEncode: /^(\w||[\u4e00-\u9fa5]){0,}$/, // 是否为非特殊字符（包括数字字母下划线中文）
  isTableName: /^[a-zA-Z][A-Za-z0-9\#\$\_\-]{0,29}$/, // 表名
  isInt: /^-?\d+$/, // 整数
  isTableOtherName: /^[\u4e00-\u9fa5]{0,20}$/, // 别名
  isText_30: /^(\W|\w{1}){0,30}$/, // 匹配30个字符，字符可以使字母、数字、下划线、非字母，一个汉字算1个字符
  isText_50: /^(\W|\w{1}){0,50}$/, // 匹配50个字符，字符可以使字母、数字、下划线、非字母，一个汉字算1个字符
  isText_20: /^(\W|\w{1}){0,20}$/, // 匹配20个字符，字符可以使字母、数字、下划线、非字母，一个汉字算1个字符
  isText_100: /^(\W|\w{1}){0,100}$/, // 匹配100个字符，字符可以使字母、数字、下划线、非字母，一个汉字算1个字符
  isText_250: /^(\W|\w{1}){0,250}$/, // 匹配250个字符，字符可以使字母、数字、下划线、非字母，一个汉字算1个字符
  isNotChina: /^[^\u4e00-\u9fa5]{0,}$/, // 不为中文 
  num1: /^[1-9]*$/, // 数字
  companyNO: /^qqb_[0-9a-zA-Z_]{1,}$/, // 公司人员账号
  imgType: /image\/(png|jpg|jpeg|gif)$/, // 上传图片类型
  isChina: /^[\u4e00-\u9fa5]{2,8}$/,
  isNozeroNumber: /^\+?[1-9]\d*$/, // 大于零的正整数
  float: /^\d+(\.?|(\.\d+)?)$/, // 匹配正整数或者小数 或者0.这个特殊值
}
```
3. utils
```javascript
// 1. 工具
var md5=require('md5-node');
var sd = require('silly-datetime');
var tools={
    md5,
    date_str: (date) => {
        return sd.format(date, 'YYYY-MM-DD');
    },
    add:function(x,y){
        return x+y;
    }
};
// 2. 网络请求
var http = require('http');
var options = {host: 'localhost', port: '8080', path: '/index.html'};
var callback = function(response){
    var body = '';
    response.on('data', function(data) {
        body += data;
    });
    response.on('end', function() {
        console.log(body);
    });
}
var req = http.request(options, callback);
req.end();

// 3. eventEmitter
var events = require('events');
var eventEmitter = new events.EventEmitter();
var connectHandler = function connected() {
    console.log('连接成功。');
    eventEmitter.emit('data_received');
}
eventEmitter.on('data_received', function(){
    console.log('数据接收成功。');
});
eventEmitter.on('connection', connectHandler);
eventEmitter.emit('connection');
console.log("程序执行完毕。");

// 4. 生成验证码从web返回
var svgCaptcha = require('svgCaptcha');
const captcha = svgCaptcha.create( {
    size:6, fontSize: 50, width: 100, height:40, background:"#cc9966"
});
ctx.session.code=captcha.text;
ctx.response.type = 'image/svg+xml';
ctx.body=captcha.data;

// 5. 文件操作
const fs = require('fs');
/*
1. fs.stat  检测是文件还是目录
2. fs.mkdir  创建目录
3. fs.writeFile  创建写入文件
4. fs.appendFile 追加文件
5. fs.readFile 读取文件
6. fs.readdir读取目录
7. fs.rename 重命名
8. fs.rmdir  删除目录
9. fs.unlink删除文件
*/
//a. 流的方式读取文件
var readStream=fs.createReadStream('input.txt');
var str='';
readStream.on('data',function(chunk){
    str+=chunk;
})
readStream.on('end',function(chunk){
    console.log(str);
})
readStream.on('error',function(err){
    console.log(err);
})
//b. 流的方式写入文件
var data = '我是从数据库获取的数据，我要保存起来11\n';
var writerStream = fs.createWriteStream('output.txt');
for(var i=0;i<100;i++){
    writerStream.write(data,'utf8');
}
writerStream.end();
writerStream.on('finish',function(){
    console.log('写入完成');
});
writerStream.on('error',function(){
    console.log('写入失败');
});
//c. 管道读写操作
var readerStream = fs.createReadStream('input.txt');
var writerStream = fs.createWriteStream('output.txt');
readerStream.pipe(writerStream);
console.log("程序执行完毕");
module.exports=tools;
```
