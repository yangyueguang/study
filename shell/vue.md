# HTML项目 项目采用VUE框架
# VUE框架
## 创建方式
```bash
$ npm install -g @vue/vue-cli
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
`sh deploy.sh`或者拷贝dist文件夹和server.js文件以及nginx_config文件夹配置好nginx之后执行`node express.js`



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


# 创建方式
`vue create -p dcloudio/uni-preset-vue project_name`
# 启动方式
1. git clone $git_url
2. 用WebStorm打开
3. yarn install
4. 查看package.json配置的scripts脚本配置。
5. yarn server
6. yarn build
7. 根据生成的build文件夹，用微信开发者工具软件打开该目录。
8. 用手机扫描测试验证调试与开发。
9. 发布上线

```
编译后目录 # dist下dev和build下的mp-weixin分别为开发和正式环境编译后的项目文件夹
```

## 创建方式
```bash
npm install --global @vue-cli
vue init webpack project_name
cd project_name
yarn install
yarn run dev
```
## 1. 启动方式
1. git clone $git_url
2. 用WebStorm打开
3. 全局安装一些文件。`brew install npm && brew install nodejs && npm install -g yarn && npm install -g vue && npm install -g vue-cli`
4. 安装项目配置的依赖库。 `npm install` or `yarn install`  
5. 查看package.json配置的scripts脚本配置。
5. 启动项目。`npm run start` or `npm run dev` or `npm run build`
6. 点开生成的url，就可以在浏览器中看到效果了。

## 2. 目录解析
```shell
├── LICENSE                 # 版权说明
├── flutter.md               # 项目说明文件
├── build                   # 编译构建配置文件包括各个环境的配置文件
├── dist                    # 项目build完后生成的网页文件
├── node_modules	        # npm自动加载的项目依赖模块
├── index.html              # 模版文件
├── package.json            # 启动脚本和三方库的依赖
├── webpack.config.js       # 打包配置文件
└── src                     # 这里是我们要开发的目录，基本上要做的事情都在这个目录里。
   ├── App.vue              # app界面入口文件
   ├── assets               # 字体图片样式等文件
   │   ├── basic.scss       # 基础全局样式文件
   │   └── images           # 图片文件夹
   ├── main.js              # 项目启动入口文件
   ├── model                # 路由、网络请求方法和模型文件
   │   ├── CommonModel.js
   │   ├── api.js
   │   └── index.js
   ├── components           # 页面组件
   │   ├── header-nav.vue
   │   └── home
   │       ├── Header.vue
   │       └── Index.vue
   ├── router              # 路由与界面的配置
   │   └── index.js
   ├── store               # vuex用来界面间传值和存储的
   │   ├── home
   │   │   └── state.js
   │   └── store.js
   ├── util                # 工具类
   │   ├── rem.js
   │   └── util.js
   └── pages                # 界面文件
       ├── homePage
       │   ├── AuthorizationLayer.vue
       │   ├── ContentList.vue
       │   └── Index.vue
       └── detailPage
           ├── Index.vue
           └── MorePage.vue
```
## 3. 项目说明
1. 项目依赖node.js和vue、vue-cli、npm、yarn。
2. 编译出来的文件在dist文件夹，部署就用dist文件夹，可以采用nginx部署或docker部署。
3. debug调试就在vue里面写上debugger，项目运行的时候就会暂停在这里，在浏览器鼠标悬停可以查看各个对象属性，也可在console中查看。
4. 项目保存自动刷新。
## 4. 开发平台
1. [electron](https://www.electronjs.org)
2. [平台介绍](https://ask.dcloud.net.cn/docs)
1. [uni-app](https://uniapp.dcloud.io)
2. [uni-app插件市场](https://ext.dcloud.net.cn)
## 5. 常用库
1. axios 网络请求库
2. [vue](https://cn.vuejs.org) 前端界面框架
3. vue-awesome-swiper 轮播图
4. vue-pickers 
5. vue-router 路由
6. vuex  界面间传值和存储
7. [webpack](https://webpack.js.org)前端打包工具[github](https://github.com/webpack/webpack)
8. [view-design](https://iviewui.com) i-view视图主要服务于PC界面[源码](https://github.com/iview/iview)
9. [vant](https://youzan.github.io/vant/#/zh-CN)移动端组件库
10. [vant-weapp](https://youzan.github.io/vant-weapp/#/intro) Vant的小程序版本
11. [mint-ui](http://mint-ui.github.io/#!/zh-cn)移动端组件库[源码](https://github.com/ElemeFE/mint-ui)[链接地址](http://elemefe.github.io/mint-ui/#/)
12. [MUI](https://dev.dcloud.net.cn/mui)最接近原生APP体验的高性能框架[源码](https://github.com/dcloudio/mui)
13. [element-ui](https://element.eleme.cn/#/zh-CN)桌面端组件库[源码](https://github.com/ElemeFE/element)
14. [echarts vue-echarts](https://github.com/ecomfe/vue-echarts)e-charts图表
15. [v-charts](https://v-charts.js.org)基于ECharts封装种类更多。[源码](https://github.com/ElemeFE/v-charts)
16. [jqwidgets](https://www.jqwidgets.com/vue/)跨平台跨框架适配的前端UI
## 6. 好的项目
1. [顺风约车](https://github.com/chengzhx76/service-mpvue-mini/)
2. [滴滴打车](https://github.com/QinZhen001/didi)
3. [微信定时发送消息](https://github.com/Mcbai/WeChat-bot)
4. [微信每日说](https://github.com/gengchen528/wechatBot)
## 知识储备
1. 本地存储对象
localStorage.setItem('list', 'a')
var list=JSON.parse(localStorage.getItem('list'));
var storage = window.sessionStorage;  
storage.setItem('name', name);  
storage.getItem("name");  
