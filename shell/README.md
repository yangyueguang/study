# VUE框架
## 创建方式
```bash
$ npm install -g vue-cli
$ vue init webpack my-project
$ cd my-project
$ yarn install
$ yarn run dev
```

## 启动方式
```bash
yarn install
yarn serve
```
或者
```bash
yarn install 
yarn build
yarn start
```

## 部署方式
`sh deploy.sh`或者拷贝dist文件夹和server.js文件以及nginx_config文件夹配置好nginx之后执行`node server.js`



# HTML项目 项目采用VUE框架
## 1. 启动方式
1. git clone $git_url
2. 用WebStorm打开
3. 全局安装一些文件。`brew install npm && brew install nodejs && npm install -g yarn && npm install -g vue && npm install -g vue-cli`
4. 安装项目配置的依赖库。 `npm install` or `yarn install`  
5. 查看package.json配置的scripts脚本配置。
5. 启动项目。`npm run start` or `npm run dev` or `npm run build`
6. 点开生成的url，就可以在浏览器中看到效果了。

## 2. 目录解析
├── Dockerfile               # docker部署的配置文件 
├── LICENSE                  # 版权说明
├── README.md                # 项目说明文件
├── build                    # 编译构建配置文件包括各个环境的配置文件
├── build.sh                 # docker编译配置文件
├── config                   # 全局配置文件
├── dist                     # 项目build完后生成的网页文件
├── node_modules	         # npm自动加载的项目依赖模块
├── index.html               # 模版文件
├── package-lock.json        # 略
├── package.json             # 启动脚本和三方库的依赖
├── release_version.json     # 发布版本 略
├── server                   # 服务配置文件
├── src                      # 这里是我们要开发的目录，基本上要做的事情都在这个目录里。
│   ├── App.vue              # app界面入口文件
│   ├── assets               # 字体图片样式等文件
│   ├── conf.json            # 配置文件
│   ├── config               # 项目具体配置文件
│   ├── main.js              # 项目启动入口文件
│   ├── model                # 路由、网络请求方法和模型文件
│   │   ├── CommonModel.js
│   │   ├── api.js
│   │   └── index.js
│   ├── page                # 页面文件
│   │   ├── header-nav.vue
│   │   ├── home
│   │   │   ├── Header.vue
│   │   │   └── Index.vue
│   ├── plugins             # 写的一些方法
│   │   └── CircleChart.js
│   ├── router              # 路由与界面的配置
│   │   └── index.js
│   ├── store               # vuex用来界面间传值和存储的
│   │   ├── home
│   │   │   └── state.js
│   │   └── store.js
│   ├── supreme-core        # 第三方库
│   ├── util                # 工具类
│   │   ├── rem.js
│   │   └── util.js
│   └── view                # 界面文件
│       ├── homePage
│       │   ├── AuthorizationLayer.vue
│       │   ├── ContentList.vue
│       │   └── Index.vue
│       └── detailPage
│           ├── Index.vue
│           └── MorePage.vue
├── static                  # 静态资源文件 略
└── test                    # 测试文件

## 3. 项目说明
1. 项目依赖node.js和vue、vue-cli、npm、yarn。
2. 编译出来的文件在dist文件夹，部署就用dist文件夹，可以采用nginx部署或docker部署。

## 4. 常用技巧
1. debug调试就在vue里面写上debugger，项目运行的时候就会暂停在这里，在浏览器鼠标悬停可以查看各个对象属性，也可在console中查看。
2. 项目保存自动刷新。

## 5. 常用库
1. axios 网络请求库
2. vue 前端界面框架
3. vue-awesome-swiper 轮播图
4. vue-pickers 
5. vue-router 路由
6. vuex  界面间传值和存储
7. webpack

