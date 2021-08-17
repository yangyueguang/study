# node.js 说明
## 1. 前提说明
- 安装：`brew install nodejs && brew install yarn`, `node -v`, `yarn add $package_name`
- node.js 语法与js语法完全一致。
- node.js 用于写服务器后台应用。跟python一样可以单独运行。`node $name.js`
- 生成 package.json `npm init --yes` 
- cnpm 比 npm 更快。`npm install -g cnpm --registry=https://registry.npm.taobao.org`
- 有点: 开发周期短、开发成本 低、学习成本低。
## 2. 面向对象
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





