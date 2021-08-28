import Vue from 'vue'
import axios from 'axios'
import VueAxios from 'vue-axios'
import vuex from 'vue'
import App from './App'
import router from './router'
import store from './store'
import FastClick from 'fastclick' //使用 fastclick 解决移动端 300ms 点击延迟
Vue.use(VueAxios, axios, vuex)
Vue.filter('fmtDate', function (date, fmtExp) {
    date = new Date(date)
    var o = {
        "M+": date.getMonth() + 1, //月份
        "d+": date.getDate(), //日
        "h+": date.getHours(), //小时
        "m+": date.getMinutes(), //分
        "s+": date.getSeconds(), //秒
        "q+": Math.floor((date.getMonth() + 3) / 3), //季度
        "S": date.getMilliseconds() //毫秒
    };
    if (/(y+)/.test(fmtExp))
        fmtExp = fmtExp.replace(RegExp.$1, (date.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmtExp))
            fmtExp = fmtExp.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmtExp;
})



Vue.config.productionTip = false
Vue.prototype.$store = store
FastClick.attach(document.body)

import VueSocketIO from 'vue-socket.io'

Vue.use(new VueSocketIO({
    debug: true,
    connection: 'http://localhost:8003',
    vuex: {
        store,
        actionPrefix: 'SOCKET_',
        mutationPrefix: 'SOCKET_'
    },
    options: { path: "" }
}))

new Vue({
    el: '#app',
    router,
    store,
    render: h => h(App)
})