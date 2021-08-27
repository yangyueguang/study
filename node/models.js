'use strict';
import chalk from 'chalk';
import mongoose from 'mongoose'
const Schema = mongoose.Schema;
const mongoUrl = 'mongodb://localhost:27017/elm'
mongoose.connect(mongoUrl, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    useFindAndModify: true,
    useCreateIndex: true
});
const db = mongoose.connection;

db.once('open' ,() => {
    console.log(chalk.green('连接数据库成功'));
})

db.on('error', function(error) {
    console.error(chalk.red('Error in MongoDb connection: ' + error));
    mongoose.disconnect();
});

db.on('close', function() {
    console.log(chalk.red('数据库断开，重新连接数据库'));
    mongoose.connect(mongoUrl, {server:{auto_reconnect:true}});
});

let user = new Schema({
    username: String,
    password: String
})
let order = new Schema({
    id: Number,
    specs: [],
    name: {type: String, default: '苹果'},
    arrange: {
        num: {type: Number, default: 2},
        free: {type: Boolean, default: false},
    },
    products: [
        {
            id: Number,
            name: {type: String, default: ''},
        }
    ]
})
order.index({id: 1}); // primary_key 主键
let User = mongoose.model('user', user)
let Order = mongoose.model('order', order)

module.exports = {
    User,
    Order,
}
