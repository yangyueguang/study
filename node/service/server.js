import fs from 'fs';
const { hash, compare, sign } = require('../plugin')
const { User } = require('../models')

// 注册用户
const register = async (req, res, next) => {
    const { username, password } = req.body
    const bcryptPassword = await hash(password)
    let findResult = await User.findOne({username})
    if (findResult) {
        res.json({message: '用户名已存在。'})
    } else {
        const user = new User({username, bcryptPassword})
        user.save()
        res.json({message: '注册成功！'})
    }
}

// 用户登录
const login = async (req, res, next) => {
    const { username, password } = req.body
    let result = await User.findOne({username})
    if (result) {
        let { password: hash } = result
        let compareResult = await compare(password, hash)
        if (compareResult) {
            const token = sign(username)
            res.set('Access-Control-Expose-Headers', 'X-Access-Token')
            res.set('X-Access-Token', token)
            req.session.token=token;
            res.json({username})
        } else {
            res.json({message: '用户名或密码错误。'})
        }
    } else {
        res.json({message: '用户名或密码错误。'})
    }
}

// 退出登录
const logout = async (req, res, next) => {
    console.log(req.cookies);
    console.log(req.signedCookies);
    res.cookie('username','cookie的值',{maxAge:60000});
    if(req.session.token){
        console.log('你好'+req.session.token+'欢迎回来');
    }else{
        res.send('未登录');
    }
    req.session.destroy();
    res.json({message: '成功退出登录。'})
}

// 用户列表
const list = async (req, res, next) => {
    const listResult = await User.find().sort({_id: -1})
    res.json(listResult)
}

// 删除用户
const remove = async (req, res, next) => {
    await User.deleteOne({_id: req.body.id})
    res.json({message: '用户删除失败。'})
}

const getFile = async (req, res, next) => {
    // res.sendFile(__dirname + '/dist/index.html')
    fs.readFile('app.html',function(err,data){
        res.writeHead(200,{"Content-Type":"text/html;charset='utf-8'"});
        res.end(data);
    })
}

const uploadFile = async (req, res, next) => {
    const des_file = __dirname + "/" + req.files[0].originalname;
    fs.readFile(req.files[0].path, 'utf8', function (err, data) {
        fs.writeFile(des_file, data, function (err) {
            res.end(JSON.stringify({msg: 'OK'}));
        });
    });
}


module.exports = {
    register,
    login,
    logout,
    list,
    remove,
    getFile,
    uploadFile
}

