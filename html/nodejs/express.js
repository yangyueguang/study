// express web 服务
var express = require('express');
var cookieParser = require('cookie-parser')
var bodyParser = require('body-parser');
var multer  = require('multer');
var util = require('./util');
var session = require("express-session");
app.use(cookieParser())
// app.use(cookieParser('sign')); // 表示用加密
app.use(session({
    secret: 'this is string key',   // 可以随便写。 一个 String 类型的字符串，作为服务器端生成 session 的签名
    name:'session_id',/*保存在本地cookie的一个名字 默认connect.sid  可以不设置*/
    resave: false,   /*强制保存 session 即使它并没有变化,。默认为 true。建议设置成 false。*/
    saveUninitialized: true,   //强制将未初始化的 session 存储。  默认值是true  建议设置成true
    cookie: {
        maxAge:5000    /*过期时间*/
    },   /*secure https这样的情况才可以访问cookie*/
    rolling:true, //在每次请求时强行设置 cookie，这将重置 cookie 过期时间（默认：false）
    // store:new MongoStore({
    //     url: 'mongodb://127.0.0.1:27017/shop',  //数据库的地址
    //     touchAfter: 24 * 3600   //time period in seconds  通过这样做，设置touchAfter:24 * 3600，您在24小时内只更新一次会话，不管有多少请求(除了在会话数据上更改某些内容的除外)
    // })
}));
var fs = require("fs");
var urlencodedParser = bodyParser.urlencoded({ extended: false })
var app = express();
app.use('/public', express.static('public'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(multer({ dest: '/tmp/'}).array('image'));
// 监听所有路由的中间件
app.use(function(req,res,next){
    console.log(new Date());
    next(); // 路由继续向下匹配
});
app.use('/news',function(req,res,next){ // 监听路由news的中间件
    console.log('新闻路由中间件通过app.use');
    next();
});
app.get('/news',function(req,res,next){ // 监听路由news的中间件
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
    console.log(req.files[0]);  // 上传的文件信息
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
    console.log(req.signedCookies);   /*获取加密的cookie信息*/
    // maxAge  过期时间 domain:'.aaa.com' 多个二级域名共享cookie
    // path  表示在哪个路由下面可以访问cookie signed属性设置成true 表示加密cookie信息
    res.cookie('username','cookie的值',{maxAge:60000});
    if(req.session.userinfo){  // 获取 session 内容
        res.send('你好'+req.session.userinfo+'欢迎回来');
    }else{
        res.send('未登录');
    }
    //销毁
    // req.session.destroy(function(err){
    //     console.log(err);
    // });
    // res.send('退出登录成功');
    req.session.userinfo="zhangsan"; // 设置session
    res.send('Hello World');
})
/*匹配所有的路由  404*/
app.use(function(req,res){
    res.status(404).send('这是404 表示路由没有匹配到')
})
var server = app.listen(8888, function () {
    var host = server.address().address;
    var port = server.address().port;
    console.log(host)
    console.log("应用实例，访问地址为 http://localhost:%s", port)
});
