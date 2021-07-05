var fs = require('fs');
var url = require('url');
var express=require('express');
var http=require('http');
var exp=express();
// 通过原生代码建立服务
// var app=http.createServer((req,res)=>{
//     fs.readFile('app.html',function(err,data){
//         res.writeHead(200,{"Content-Type":"text/html;charset='utf-8'"});
//         res.end(data);
//     })
// });
// 通过express建立服务
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
        // io.emit('servermessage',data);   /*服务器给客户端发送数据*/
        var msg=data||'';  /*获取客户端的数据*/
        socket.emit('servermessage',msg);
    });

    //获取客户端建立连接的时候传入的值
    console.log(socket.request.url);
    var roomid=url.parse(socket.request.url,true).query.roomid;   /*获取房间号/ 获取桌号*/
    socket.join(roomid);  /*加入房间/加入分组*/
    socket.on('addCart',function(data){
        console.log(data);
        // socket.emit();   /*谁给我发信息我把信息广播给谁*/
        // io.emit() ;   /*群发  给所有连接服务器的客户都广播数据*/
        // socket.emit('to-client','我是服务器的数据'+data.client);
        // io.to(roomid).emit('servermessage','Server AddCart Ok'); //通知分组内的所有用户
        socket.broadcast.to(roomid).emit('servermessage','Server AddCart Ok'); //通知分组内的用户不包括自己
    })
});
