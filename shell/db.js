
var MongoDB=require('mongodb');
var MongoClient =MongoDB.MongoClient;
var Config={
    dbUrl: 'mongodb://localhost:27017/',
    dbName: 'koa'
};

class Db{
    static getInstance(){
        if(!Db.instance){
            Db.instance=new Db();
        }
        return  Db.instance;
    }
    constructor(){
        this.dbClient='';
        this.connect();
    }
    connect(){
        let _that=this;
        return new Promise((resolve,reject)=>{
            if(!_that.dbClient){
                MongoClient.connect(Config.dbUrl,(err,client)=>{
                    if(err){
                        reject(err)
                    }else{
                        _that.dbClient=client.db(Config.dbName);
                        resolve(_that.dbClient)
                    }
                })
            }else{
                resolve(_that.dbClient);
            }
        })
    }

    find(collectionName,json){
        return new Promise((resolve,reject)=>{
            this.connect().then((db)=>{
                var result=db.collection(collectionName).find(json);
                result.toArray(function(err,docs){
                    if(err){
                        reject(err);
                    }else{
                        resolve(docs);
                    }
                })

            })
        })
    }

    update(collectionName,json1,json2){
        return new Promise((resolve,reject)=>{
            this.connect().then((db)=>{
                //db.user.update({},{$set:{}})
                db.collection(collectionName).updateOne(json1,{$set:json2},(err,result)=>{
                    if(err){
                        reject(err);
                    }else{
                        resolve(result);
                    }
                })
            })
        })
    }

    insert(collectionName,json){
        return new  Promise((resolve,reject)=>{
            this.connect().then((db)=>{
                db.collection(collectionName).insertOne(json,function(err,result){
                    if(err){
                        reject(err);
                    }else{
                        resolve(result);
                    }
                })
            })
        })
    }

    remove(collectionName,json){
        return new  Promise((resolve,reject)=>{
            this.connect().then((db)=>{
                db.collection(collectionName).removeOne(json,function(err,result){
                    if(err){
                        reject(err);
                    }else{
                        resolve(result);
                    }
                })
            })
        })
    }

    getObjectId(id){   /*mongodb里面查询 _id 把字符串转换成对象*/
        return new MongoDB.ObjectID(id);
    }
}

module.exports=Db.getInstance();
// usage
/**
DB=require('./db.js');
router.post('/doEdit',async (ctx)=>{
    var id=ctx.request.body.id;
    let data=await DB.update('user',{"_id":DB.getObjectId(id)},{
        username:'a',age:23,sex:1
    });
    DB.find('user',{}).then((data)=>{
        console.log(data);
    });
    console.log(data);
});
 */



// mysql
var mysql      = require('mysql');
var connection = mysql.createConnection({
    host     : 'localhost',
    port     : '3306',
    user     : 'root',
    password : '123456',
    database : 'test'
});
connection.connect();

connection.query('SELECT 1 + 1 AS solution', function (error, results, fields) {
    if (error) throw error;
    console.log('The solution is: ', results[0].solution);
});
var delSql = 'DELETE FROM websites where id=6';
connection.query(delSql,function (err, result) {
    if(err){
        console.log('[DELETE ERROR] - ',err.message);
        return;
    }
    console.log('DELETE affectedRows',result.affectedRows);
});
var  addSql = 'INSERT INTO websites(Id,name,url,alexa,country) VALUES(0,?,?,?,?)';
var  addSqlParams = ['菜鸟工具', 'https://c.runoob.com','23453', 'CN'];
connection.query(addSql,addSqlParams,function (err, result) {
    if(err){
        console.log('[INSERT ERROR] - ',err.message);
        return;
    }
    console.log('INSERT ID:',result);
});
var sql = 'SELECT * FROM websites';
connection.query(sql,function (err, result) {
    if(err){
        console.log('[SELECT ERROR] - ',err.message);
        return;
    }
    console.log(result);
});
var modSql = 'UPDATE websites SET name = ?,url = ? WHERE Id = ?';
var modSqlParams = ['菜鸟移动站', 'https://m.runoob.com',6];
connection.query(modSql,modSqlParams,function (err, result) {
    if(err){
        console.log('[UPDATE ERROR] - ',err.message);
        return;
    }
    console.log('UPDATE affectedRows',result.affectedRows);
});
connection.end();

// mongoDB 数据库
var MongoClient = require('mongodb').MongoClient;
var DBurl = 'mongodb://localhost:27017/student';
MongoClient.connect(DBurl,function(err,db){
    if(err){
        console.log('数据库连接失败' + err.message);
        return;
    }
    db.collection('user').insertOne({"name":"大地", "age":10},function(error,result){
        db.close();
    });
    db.collection('user').updateOne({"name":"lisi"},{$set:{"age":666}},function(error,data){
        db.close();
    });
    db.collection('user').deleteOne({"name":name},function(error,data){
        db.close();
    });
    var list=[];
    var result=db.collection('user').find({});
    result.each(function(error,doc){
        if(error){
            console.log(error);
        }else{
            if(doc!=null){
                list.push(doc);
            }else{
                console.log('数据循环完成')
            }
        }
    });
    console.log(list)
});