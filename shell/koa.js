// koa应用生成器
/**
npm install koa-generator -g
koa koa_demo
npm start
*/
/**
{
  "dependencies": {
    "express": "^4.17.1",
    "cookie-parser": "^1.4.4",
    "mongodb": "^3.5.3",
    "koa": "^2.5.0",
    "koa-router": "^7.4.0",
    "koa-session": "^5.8.1",
    "art-template": "^4.12.2",
    "koa-art-template": "^1.1.1",
    "koa-bodyparser": "^4.2.0",
    "koa-static": "^4.0.2",
    "socket.io": "^2.1.0",
    "url": "^0.11.0",
    "http": "^0.0.0"
  }
}
*/
var Koa=require('shell/koa');
path=require('path');
session = require('koa-session');
var router = require('koa-router')();
render = require('koa-art-template');
bodyParser=require('koa-bodyparser');
var app=new Koa();
// 用后端渲染的配置
render(app, {
    root: path.join(__dirname, 'views'),   // 视图的位置
    extname: '.html',  // 后缀名
    debug: process.env.NODE_ENV !== 'production'  //是否开启调试模式
});
//配置session的中间件
app.keys = ['some secret hurr'];   /*cookie的签名*/
const CONFIG = {
    key: 'koa:sess', // 默认
    maxAge: 10000,
    overwrite: true, // 没有效果，默认
    httpOnly: true,
    signed: true,
    rolling: true, // 在每次请求时强行设置 cookie
    renew: false
};
app.use(bodyParser());
app.use(session(CONFIG, app));
app.use(async (ctx,next)=>{
    console.log(new Date());
    next();
    console.log('匹配路由完成以后又会返回来执行中间件');
    if(ctx.status==404){   /*如果页面找不到*/
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
    // var userinfo=new Buffer(userinfo, 'base64').toString();
    console.log(ctx.session.userinfo);//获取session
    ctx.session.userinfo='张三';//设置session
    let list={name:userinfo};
    // 后段直接渲染界面
    await ctx.render('index',{
        list:list
    });
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











