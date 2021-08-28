import Vue from 'vue'
import Vuex from 'vuex'

const OfficialAccounts = [{
    wxid: "Google_Developers",
    name: "谷歌开发者",
    headerUrl: "http://cdn.sinacloud.net/vue-wechat/images/OfficialAccount/google-dev.JPG",
    desc: "",
    owner: "谷歌信息技术有限公司",
    initial: "G"
}, {
    wxid: "overwatch163",
    name: "守望先锋",
    desc: "",
    headerUrl: "http://cdn.sinacloud.net/vue-wechat/images/OfficialAccount/overwatch.JPG",
    owner: "上海网易公司",
    initial: "O"
}, {
    wxid: "FrontDev",
    name: "前端大全",
    desc: "",
    headerUrl: "http://cdn.sinacloud.net/vue-wechat/images/OfficialAccount/frontend.JPG",
    owner: "",
    initial: "Q"
}, {
    wxid: "xituarea",
    name: "稀土区",
    desc: "",
    headerUrl: "http://cdn.sinacloud.net/vue-wechat/images/OfficialAccount/xitu.JPG",
    owner: "个人",
    initial: "X"
}, {
    wxid: "LOL-922",
    name: "英雄联盟",
    desc: "",
    headerUrl: "http://cdn.sinacloud.net/vue-wechat/images/OfficialAccount/lol.JPG",
    owner: "腾讯技术有限公司",
    initial: "Y"
}]
/**
 * wxid-微信id
 * initial-姓名首字母
 * headerUrl-头像地址
 * nickname-昵称
 * sex-性别 男1女0
 * remark-备注
 * signature-个性签名
 * telphone-电话号码
 * album-相册
 * area-地区
 * from-来源
 * desc-描述
 */
const contacts = [{ //昵称备注都有的朋友
    "wxid": "wxid_zhaohd",
    "initial": 'z',
    "headerUrl": "https://sinacloud.net/vue-wechat/images/headers/header01.png",
    "nickname": "阿荡",
    "sex": 1,
    "remark": "阿荡",
    "signature": "填坑小能手",
    "telphone": 18896586152,
    "album": [{
        imgSrc: ""
    }],
    "area": ["中国", "北京", "海淀"],
    "from": "",
    "tag": "",
    "desc": {

    }
},
    {
        "wxid": "wxid_baiqian",
        "initial": 'b',
        "headerUrl": "https://sinacloud.net/vue-wechat/images/headers/baiqian.jpg",
        "nickname": "白浅",
        "sex": 0,
        "remark": "",
        "signature": "青丘女帝，天族天妃",
        "telphone": 18896586152,
        "album": [{
            imgSrc: "https://sinacloud.net/vue-wechat/images/album/baiqian/baiqian01.jpeg",
            date: 182625262
        }, {
            imgSrc: "https://sinacloud.net/vue-wechat/images/album/baiqian/baiqian02.jpeg",
            date: 182625262
        }],
        "area": ["青丘", "狐狸洞"],
        "from": "通过扫一扫",
        "tag": "女帝",
        "desc": {
            "title": "",
            "picUrl": ""
        }
    }, { //昵称备注都有的朋友
        "wxid": "wxid_yehua",
        "initial": 'y',
        "headerUrl": "https://sinacloud.net/vue-wechat/images/headers/yehua.jpg",
        "nickname": "夜华",
        "sex": 1,
        "remark": "夜华",
        "signature": "浅浅，过来",
        "telphone": 18896586152,
        "album": [{
            imgSrc: "https://sinacloud.net/vue-wechat/images/album/guanyu/guanyu02.jpeg",
            date: 182625262
        }, {
            imgSrc: "https://sinacloud.net/vue-wechat/images/album/baiqian/baiqian02.jpeg",
            date: 182625262
        }],
        "area": ["九重天", "洗梧宫"],
        "from": "通过扫一扫",
        "tag": "太子",
        "desc": {
            "title": "",
            "picUrl": ""
        }
    },
    {
        "wxid": "wxid_liubei",
        "initial": 'l',
        "headerUrl": "https://sinacloud.net/vue-wechat/images/headers/liubei.jpg",
        "nickname": "刘备",
        "sex": 1,
        "remark": "刘备",
        "signature": "惟贤惟德，仁服于人",
        "telphone": 18896586152,
        "album": [{
            imgSrc: "https://sinacloud.net/vue-wechat/images/album/guanyu/guanyu02.jpeg",
            date: 182625262
        }, {
            imgSrc: "https://sinacloud.net/vue-wechat/images/album/baiqian/baiqian01.jpeg",
            date: 182625262
        }],
        "area": ["蜀国", "荆州"],
        "from": "通过扫一扫",
        "tag": "主公",
        "desc": {
            "title": "",
            "picUrl": ""
        }
    },
    {
        "wxid": "wxid_guangyu",
        "initial": 'g',
        "headerUrl": "https://sinacloud.net/vue-wechat/images/headers/guangyu.jpg",
        "nickname": "关羽",
        "sex": 1,
        "remark": "关羽",
        "signature": "观尔乃插标卖首",
        "telphone": 18896586152,
        "album": [{
            imgSrc: "https://sinacloud.net/vue-wechat/images/album/baiqian/baiqian02.jpeg",
            date: 182625262
        }, {
            imgSrc: "https://sinacloud.net/vue-wechat/images/album/guanyu/guanyu01.jpeg",
            date: 182625262
        }],
        "area": ["蜀国", "荆州"],
        "from": "通过扫一扫",
        "tag": "蜀",
        "desc": {
            "title": "",
            "picUrl": ""
        }
    },
    {
        "wxid": "wxid_zhugeliang",
        "initial": 'z',
        "headerUrl": "https://sinacloud.net/vue-wechat/images/headers/zhugeliang.jpg",
        "nickname": "诸葛亮",
        "sex": 1,
        "remark": "诸葛亮",
        "signature": "你可识得此阵？",
        "telphone": 18896586152,
        "album": [{
            imgSrc: "https://sinacloud.net/vue-wechat/images/album/baiqian/baiqian01.jpeg",
            date: 182625262
        }, {
            imgSrc: "https://sinacloud.net/vue-wechat/images/album/guanyu/guanyu01.jpeg",
            date: 182625262
        }],
        "area": ["蜀国", "荆州"],
        "from": "通过扫一扫",
        "tag": "卧龙",
        "desc": {
            "title": "",
            "picUrl": ""
        }
    },
    {
        "wxid": "wxid_sunshangxiang",
        "initial": 's',
        "headerUrl": "https://sinacloud.net/vue-wechat/images/headers/sunshangxiang.jpg",
        "nickname": "孙尚香",
        "sex": 0,
        "remark": "孙尚香2",
        "signature": "夫君,身体要紧~",
        "telphone": 18896586152,
        "album": [{
            imgSrc: "https://sinacloud.net/vue-wechat/images/album/baiqian/baiqian02.jpeg",
            date: 182625262
        }],
        "area": ["吴国", "富春"],
        "from": "通过手机号码添加",
        "tag": "孙夫人",
        "desc": {
            "title": "",
            "picUrl": ""
        }
    },
    {
        "wxid": "wxid_sunquan",
        "initial": 's',
        "headerUrl": "https://sinacloud.net/vue-wechat/images/headers/sunquan.jpg",
        "nickname": "孙权",
        "sex": 1,
        "remark": "孙权",
        "signature": "容我三思",
        "telphone": 18896586152,
        "album": [{
            imgSrc: "https://sinacloud.net/vue-wechat/images/album/guanyu/guanyu01.jpeg",
            date: 182625262
        }],
        "area": ["吴国", "吴郡"],
        "from": "通过手机号码添加",
        "tag": "主公",
        "desc": {
            "title": "",
            "picUrl": ""
        }
    },
    {
        "wxid": "wxid_huangyueying",
        "initial": 'h',
        "headerUrl": "https://sinacloud.net/vue-wechat/images/headers/huangyueying.jpg",
        "nickname": "黄月英",
        "sex": 0,
        "remark": "黄月英",
        "signature": "哼哼~",
        "telphone": 18896586152,
        "album": [{
            imgSrc: "https://sinacloud.net/vue-wechat/images/album/guanyu/guanyu02.jpeg",
            date: 182625262
        }],
        "area": ["蜀", "荆州"],
        "from": "通过手机号码添加",
        "tag": "蜀",
        "desc": {
            "title": "",
            "picUrl": ""
        }
    }, {
        "wxid": "wxid_zhenji",
        "initial": 'z',
        "headerUrl": "https://sinacloud.net/vue-wechat/images/headers/zhenji.jpg",
        "nickname": "甄姬",
        "sex": 0,
        "remark": "甄姬",
        "signature": "仿佛兮若轻云之蔽月",
        "telphone": 18896586152,
        "album": [{
            imgSrc: "https://sinacloud.net/vue-wechat/images/album/guanyu/guanyu01.jpeg",
            date: 182625262
        }],
        "area": ["魏", "荆州", "中山"],
        "from": "通过手机号码添加",
        "tag": "蜀",
        "desc": {
            "title": "",
            "picUrl": ""
        }
    }
]

const contact = {
    contacts
}
contact.getUserInfo = function(wxid) {
    if (!wxid) {
        return;
    } else {
        for (var index in contacts) {
            if (contacts[index].wxid === wxid) {
                return contacts[index]
            }
        }
    }
}
const mutations = {
    //切换语言 后期需要
    switchLang(state, lang) {
        state.currentLang = lang
        // Vue.config.lang = lang
        document.cookie = "VR_LANG=" + lang + "; path=/;domain=.snail.com"
        // location.reload()
    },
    //设置当前页面名字
    setPageName(state, name) {
        state.currentPageName = name
    },
    //当 search 组件全屏/非全屏时 切换公共头部状态
    toggleHeaderStatus(state, status) {
        state.headerStatus = status
    },
    //切换“微信”页中右上角菜单
    toggleTipsStatus(state, status) {
        if (status == -1) {
            state.tipsStatus = false
        } else {
            state.tipsStatus = !state.tipsStatus
        }
    },
    //增加未读消息数
    addNewMsg(state) {
        state.newMsgCount > 99 ? state.newMsgCount = "99+" : state.newMsgCount++
    },
    //减少未读消息数
    minusNewMsg(state) {
        state.newMsgCount < 1 ? state.newMsgCount = 0 : state.newMsgCount--
    },
}
const getters = {

    //  从联系人中提取出首字母 再排序

    contactsInitialList: state => {
        var initialList = [],
            allContacts = state.allContacts,
            max = allContacts.length
        for (var i = 0; i < max; i++) {
            if (initialList.indexOf(allContacts[i].initial.toUpperCase()) == -1) {
                initialList.push(allContacts[i].initial.toUpperCase())
            }
        }
        return initialList.sort()
    },

    // 将联系人根据首字母进行分类
    contactsList: (state, getters) => {
        var contactsList = {},
            allContacts = state.allContacts,
            max = allContacts.length;
        for (var i = 0; i < getters.contactsInitialList.length; i++) {
            var protoTypeName = getters.contactsInitialList[i]
            contactsList[protoTypeName] = []
            for (var j = 0; j < max; j++) {
                if (allContacts[j].initial.toUpperCase() === protoTypeName) {
                    contactsList[protoTypeName].push(allContacts[j])
                }
            }
        }
        return contactsList
    }
}

Vue.use(Vuex)
    // 统一管理接口域名 
let apiPublicDomain = '//vrapi.snail.com/'
const state = {
    currentLang: "zh",
    newMsgCount: 0, //新消息数量
    allContacts: contact.contacts, //所有联系人
    OfficialAccounts: OfficialAccounts, //所有关注的公众号
    currentPageName: "微信", //用于在wx-header组件中显示当前页标题
    //backPageName: "", //用于在返回按钮出 显示前一页名字 已遗弃
    headerStatus: true, //显示（true）/隐藏（false）wx-header组件
    tipsStatus: false, //控制首页右上角菜单的显示(true)/隐藏(false)
    // 所有接口地址 后期需要
    apiUrl: {
        demo: apiPublicDomain + ""
    },
    msgList: {
        stickMsg: [], //置顶消息列表 后期需要
        baseMsg: [{ //普通消息列表
                "mid": 1, //消息的id 唯一标识，重要
                "type": "friend",
                "group_name": "",
                "group_qrCode": "",
                "read": true, //true；已读 false：未读
                "newMsgCount": 1,
                "quiet": false, // true：消息免打扰 false：提示此好友/群的新消息
                "msg": [{ //对话框的聊天记录 新消息 push 进
                    "text": "长按这些白色框消息，唤醒消息操作菜单，长按这些白色框消息，唤醒消息操作菜单",
                    "date": 1488117964495,
                    "name": "阿荡",
                    "headerUrl": "https://sinacloud.net/vue-wechat/images/headers/header01.png"
                }, {
                    "text": '点击空白处，操作菜单消失',
                    "date": 1488117964495,
                    "name": "阿荡",
                    "headerUrl": "https://sinacloud.net/vue-wechat/images/headers/header01.png"
                }, {
                    "text": '来呀 快活啊',
                    "date": 1488117964495,
                    "name": "阿荡",
                    "headerUrl": "https://sinacloud.net/vue-wechat/images/headers/header01.png"
                }],
                "user": [contact.getUserInfo('wxid_zhaohd')] // 此消息的用户数组 长度为1则为私聊 长度大于1则为群聊
            },
            {
                "mid": 2,
                "type": "group",
                "group_name": "收购万达讨论群",
                "group_qrCode": "",
                "read": false,
                "newMsgCount": 1,
                "quiet": true,
                "msg": [{
                        "text": "长按消息，唤醒消息操作菜单",
                        "date": 1488117964495,
                        "name": "夜华",
                        "headerUrl": "https://sinacloud.net/vue-wechat/images/headers/yehua.jpg"
                    }, {
                        "text": '点击空白处，操作菜单消失',
                        "date": 1488117964495,
                        "name": "阿荡",
                        "headerUrl": "https://sinacloud.net/vue-wechat/images/headers/header01.png"
                    },
                    {
                        "text": '我试一试',
                        "date": 1488117964495,
                        "name": "夜华",
                        "headerUrl": "https://sinacloud.net/vue-wechat/images/headers/yehua.jpg"
                    }
                ],
                "user": [contact.getUserInfo('wxid_zhaohd'), contact.getUserInfo('wxid_yehua')]
            },
            {
                "mid": 3,
                "type": "group",
                "group_name": "收购淘宝讨论群",
                "group_qrCode": "",
                "read": true,
                "newMsgCount": 1,
                "quiet": true,
                "msg": [{
                    "text": '冒个泡',
                    "date": 1488117964495,
                    "name": "诸葛亮",
                    "headerUrl": "https://sinacloud.net/vue-wechat/images/headers/zhugeliang.jpg"
                }],
                "user": [contact.getUserInfo('wxid_zhenji'), contact.getUserInfo('wxid_zhugeliang'), contact.getUserInfo('wxid_zhaohd')]
            },
            {
                "mid": 4,
                "type": "friend",
                "group_name": "",
                "group_qrCode": "",
                "read": false,
                "newMsgCount": 4,
                "quiet": false,
                "msg": [{
                    "text": "长按消息，唤醒消息操作菜单",
                    "date": 1488117964495,
                    "name": "孙权",
                    "headerUrl": "https://sinacloud.net/vue-wechat/images/headers/sunquan.jpg"
                }, {
                    "text": '点击空白处，操作菜单消失',
                    "date": 1488117964495,
                    "name": "孙权",
                    "headerUrl": "https://sinacloud.net/vue-wechat/images/headers/sunquan.jpg"
                }, {
                    "text": '容我三思',
                    "date": 1488117964495,
                    "name": "孙权",
                    "headerUrl": "https://sinacloud.net/vue-wechat/images/headers/sunquan.jpg"
                }],
                "user": [contact.getUserInfo('wxid_sunquan')]
            },
            {
                "mid": 5,
                "type": "friend",
                "group_name": "",
                "group_qrCode": "",
                "read": false,
                "newMsgCount": 4,
                "quiet": false,
                "msg": [{
                    "text": '夫君,身体要紧~ ',
                    "date": 1488117964495,
                    "name": "孙尚香",
                    "headerUrl": "https://sinacloud.net/vue-wechat/images/headers/sunshangxiang.jpg"
                }],
                "user": [contact.getUserInfo('wxid_sunshangxiang')]
            },
            {
                "mid": 6,
                "type": "friend",
                "group_name": "",
                "group_qrCode": "",
                "read": false,
                "newMsgCount": 4,
                "quiet": true,
                "msg": [{
                    "text": '三姓家奴！ ',
                    "date": 1488117964495,
                    "name": "关羽",
                    "headerUrl": "https://sinacloud.net/vue-wechat/images/headers/guangyu.jpg"
                }],
                "user": [contact.getUserInfo('wxid_guangyu')]
            }
        ]
    }
}
export default new Vuex.Store({
    state,
    mutations,
    actions: {},
    getters
})