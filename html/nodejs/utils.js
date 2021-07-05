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

// 1. 创建web服务
var http = require('http');
var url = require('url');
http.createServer(function (request, response) {
    response.writeHead(200, {'Content-Type': 'text/plain'});
    var pathname = url.parse(request.url, true).pathname;
    console.log("Request for " + pathname + " received.");
    response.write("Hello, world!\n");
    response.end();
}).listen(8888);
console.log('Server running at http://127.0.0.1:8888/');

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
    size:6,
    fontSize: 50, width: 100, height:40, background:"#cc9966"
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
var str='';/*保存数据*/
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