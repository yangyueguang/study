
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
    constructor(name,age){
        this.name=name;
        this.age=age;
    }
    static work(){   
        console.log('这是静态方法');
    }
    run(){
        console.log('姓名:' + this.name + '年龄:' + this.age);
    }
}
class Student extends Person{  
    constructor(name,age,sex){
        super(name,age);  
        this.sex=sex;
    }
    print(){
        console.log(this.sex);
    }
}
var s=new Student('张三','30','男');
s.run();
Person.work();
```

# 三、note
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
2. 客户端socket

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

3. utils
```javascript
// 1. 网络请求
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

// 2. eventEmitter
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

// 3. 生成验证码从web返回
var svgCaptcha = require('svgCaptcha');
const captcha = svgCaptcha.create( {
    size:6, fontSize: 50, width: 100, height:40, background:"#cc9966"
});
ctx.session.code=captcha.text;
ctx.response.type = 'image/svg+xml';
ctx.body=captcha.data;

// 4. 文件操作
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

# 四、接口文档
## 目录：
1. [获取城市列表](#1获取城市列表)
2. [获取所选城市信息](#2获取所选城市信息)

## 接口列表：
### 1、获取城市列表
request:
```http request
POST https://elm.cangdu.org/v1/cities

{
   "id": 1
}
```
response:
```json
{
  "id": 1,
  "name": "上海"
}
```

|参数|说明|
|:---|:---|
|id|主键ID|
|name|名字|
