
conf = {
    "pages": [
        "page/component/index",
        "page/API/index",
        "page/API/pages/login/login",
        "page/API/pages/get-user-info/get-user-info",
    ],
    "window": {
        "navigationBarTextStyle": "black",
        "navigationBarTitleText": "演示",
        "navigationBarBackgroundColor": "#F8F8F8",
        "backgroundColor": "#F8F8F8",
        "enablePullDownRefresh": false,
        "onReachBottomDistance": 50,
        "backgroundTextStyle": "dark"
    },
    "tabBar": {
        "color": "#7A7E83",
        "selectedColor": "#3cc51f",
        "borderStyle": "black",
        "backgroundColor": "#ffffff",
        "list": [
            {
                "pagePath": "page/component/index",
                "iconPath": "image/icon_component.png",
                "selectedIconPath": "image/icon_component_HL.png",
                "text": "组件"
            },
            {
                "pagePath": "page/API/index",
                "iconPath": "image/icon_API.png",
                "selectedIconPath": "image/icon_API_HL.png",
                "text": "接口"
            },
            {
                "pagePath": "page/cloud/index",
                "iconPath": "image/icon_cloud.png",
                "selectedIconPath": "image/icon_cloud_HL.png",
                "text": "云开发"
            }
        ]
    },
    "networkTimeout": {
        "request": 10000,
        "connectSocket": 10000,
        "uploadFile": 10000,
        "downloadFile": 10000
    },
    "navigateToMiniProgramAppIdList": [
        "wx4f1b24bdc99fa23b"
    ],
    "workers": "workers",
    "debug": false,
    "permission": {
        "scope.userLocation": {
            "desc": "你的位置信息将用于小程序位置接口的效果展示"
        }
    },
    "cloud": true,
    "sitemapLocation": "sitemap.json"
}



const config = require('./config')

App({
    onLaunch(opts) {
        console.log('App Launch', opts)
        if (!wx.cloud) {
            console.error('请使用 2.2.3 或以上的基础库以使用云能力')
        } else {
            wx.cloud.init({
                env: config.envId,
                traceUser: true,
            })
        }
    },
    onShow(opts) {
        console.log('App Show', opts)
    },
    onHide() {
        console.log('App Hide')
    },
    globalData: {
        hasLogin: false,
        openid: null
    },
    // lazy loading openid
    getUserOpenId(callback) {
        const self = this

        if (self.globalData.openid) {
            callback(null, self.globalData.openid)
        } else {
            wx.login({
                success(data) {
                    wx.request({
                        url: config.openIdUrl,
                        data: {
                            code: data.code
                        },
                        success(res) {
                            console.log('拉取openid成功', res)
                            self.globalData.openid = res.data.openid
                            callback(null, self.globalData.openid)
                        },
                        fail(res) {
                            console.log('拉取用户openid失败，将无法正常使用开放接口等服务', res)
                            callback(res)
                        }
                    })
                },
                fail(err) {
                    console.log('wx.login 接口调用失败，将无法正常使用开放接口等服务', err)
                    callback(err)
                }
            })
        }
    },
    // 通过云函数获取用户 openid，支持回调或 Promise
    getUserOpenIdViaCloud() {
        return wx.cloud.callFunction({
            name: 'wxContext',
            data: {}
        }).then(res => {
            this.globalData.openid = res.result.openid
            return res.result.openid
        })
    }
})

// - [官方教程](https://developers.weixin.qq.com/miniprogram/dev/framework)
