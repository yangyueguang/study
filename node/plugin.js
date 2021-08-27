'use strict';
import fs from 'fs';
import ejs from "ejs";
import path from 'path';
import cors from 'cors';
import chalk from 'chalk';
import logger from 'morgan';
import winston from 'winston';
import express from 'express';
import Socket from 'socket.io';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import session from 'express-session';
import bodyParser from 'body-parser';
import cookieParser from 'cookie-parser'
const MongoStore = require('connect-mongo')(session);
import expressWinston from 'express-winston';
import history from 'connect-history-api-fallback';

function addHeader(req, res, next) {
    const { origin, Origin, referer, Referer } = req.headers;
    res.header("X-Powered-By", 'Express');
    res.header("Access-Control-Allow-Credentials", true);
    res.header("Access-Control-Allow-Methods", "PUT,POST,GET,DELETE,OPTIONS");
    res.header("Access-Control-Allow-Origin", origin || Origin || referer || Referer || '*');
    res.header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept, Authorization, X-Requested-With");
    if (req.method === 'OPTIONS') res.sendStatus(200);
    next();
}

function modifyResponseBody(req, res, next) {
    const oldSend = res.send;
    res.send = function(data){
        if (Array.isArray(data)) {
            arguments[0] = JSON.stringify({
                code: 200,
                msg: 'OK',
                data: data
            })
        }else if (typeof data  === 'string' && data.indexOf('</html>') < 0){
            arguments[0] = JSON.stringify({
                code: 200,
                msg: 'OK',
                data: JSON.parse(data)
            })
        }
        oldSend.apply(res, arguments);
    }
    next();
}

exports.beforeRouter = (app) => {
    app.all('*', addHeader);
    app.use(modifyResponseBody)
    app.use(session({
        name:'session_id',
        secret: 'this is string key',
        resave: false,
        saveUninitialized: true,
        cookie: {
            maxAge:5000
        },
        rolling:true,
        store:new MongoStore({
            url: 'mongodb://localhost:27017/session',
            touchAfter: 24 * 3600
        })
    }));
    app.set("views", path.join(__dirname, "./public"));
    app.set('view engine', 'ejs');
    app.set('view options', {debug: process.env.NODE_ENV !== 'production', escape: false})
    app.engine('ejs', ejs.__express);
    app.use(logger('dev'));
    app.use(express.json());
    app.use(bodyParser.urlencoded({extended: false}))
    app.use(express.urlencoded({extended: false}));
    app.use(bodyParser.json())
    app.use(bodyParser.raw())
    app.use(bodyParser.text())
    app.use(cookieParser());
    app.use(express.static(path.join(__dirname, 'static')));
    app.use(cors())
    app.use(function (req, res, next) {
        console.log(chalk.green(req.path))
        next();
    });
    app.use(expressWinston.logger({
        transports: [
            new (winston.transports.Console)({json: true, colorize: true}),
            new winston.transports.File({filename: 'public/success.log'})
        ]
    }));
}

exports.afterRouter = (app) => {
    app.use(expressWinston.errorLogger({
        transports: [
            new winston.transports.Console({json: true, colorize: true}),
            new winston.transports.File({filename: 'public/error.log'})
        ]
    }));
    app.use(history());
    app.use('/static', express.static('./public'));
    app.get('*', function (req, res){
        console.log(chalk.red('404 handler..', req.path))
        res.render('home', {title: 'very good'});
    });
    app.use(function(err, req, res, next) {
        res.locals.message = err.message;
        res.locals.error = req.app.get('env') === 'development' ? err : {};
        res.status(err.status || 500);
        res.json({data: err.message});
    });
}

exports.socket = (server) => {
    const io = Socket(server, {
        cors: {
            origin: "http://.*",
            methods: ["GET", "POST"]
        }
    })
    var users = []
    io.sockets.on('connection', function (socket) {
        process.socket = socket
        socket.on('message',function(data){
            console.log(data);
            const msg=data||'';
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
}

exports.checkAdmin = (req, res, next) => {
    const admin_id = req.session.admin_id;
    if (!admin_id || !Number(admin_id)) {
        res.send({status: 0, message: '亲，您还没有登录',})
    }
    next()
}

exports.auth = (req, res, next) => {
    let token = req.get('X-Access-Token')
    try {
        const publicKey = fs.readFileSync(path.join(__dirname, './rsa_public_key.pem'))
        jwt.verify(token, publicKey)
        next()
    } catch(e) {
        res.json({message: '请登录。'})
    }
}

exports.hash = (myPlaintextPassword) => {
    return new Promise((resolve, reject) => {
        bcrypt.genSalt(10, function(err, salt) {
            bcrypt.hash(myPlaintextPassword, salt, function(err, hash) {
                if (err) reject(err)
                resolve(hash)
            })
        })
    })
}

exports.compare = (myPlaintextPassword, hash) => {
    return new Promise((resolve, reject) => {
        bcrypt.compare(myPlaintextPassword, hash, function(err, result) {
            resolve(result)
        })
    })
}

exports.sign = (username) => {
    const privateKey = fs.readFileSync(path.join(__dirname, './keys/rsa_private_key.pem'))
    const token = jwt.sign({username}, privateKey, { algorithm: 'RS256' })
    return token
}

