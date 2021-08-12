import Vue from 'vue'
import ElementUI from 'element-ui'
import App from './App'
import router from '@/utils/router'
import store from '@/utils/store'
import NProgress from 'nprogress'
import api from '@/utils/api'
import service from '@/utils/request'
import tools from '@/utils/tools'
import config from '@/utils/config'

Vue.use(require('vue-electron'))
Vue.use(ElementUI)
Vue.prototype.$store = store;
Vue.prototype.$http = service
Vue.prototype.$api = api
Vue.prototype.$tools = tools
Vue.prototype.$config = config
Vue.config.productionTip = false
String.prototype.int = function () {
  return parseInt(this, 10)
}
Date.prototype.format = function(fmt='yyyy-MM-dd') {
  let o = {
    "M+" : this.getMonth()+1,                 //月份
    "d+" : this.getDate(),                    //日
    "h+" : this.getHours(),                   //小时
    "m+" : this.getMinutes(),                 //分
    "s+" : this.getSeconds(),                 //秒
    "q+" : Math.floor((this.getMonth()+3)/3), //季度
    "S"  : this.getMilliseconds()             //毫秒
  };
  if(/(y+)/.test(fmt)) {
    fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
  }
  for(let k in o) {
    if(new RegExp("("+ k +")").test(fmt)){
      fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
    }
  }
  return fmt;
}
Date.prototype.from = function(strDate) {
  let a = strDate.split(" ");
  let b = a[0].split("-");
  let c = a[1].split(":");
  return new Date(b[0], b[1], b[2], c[0], c[1], c[2]);
}
router.beforeEach((to, from, next) => {
  NProgress.start()
  if (store.state.user.token && to.path === '/login') {
      next({ path: '/' })
  } else if(!store.state.user.token && to.path !== '/login') {
      next('/login')
  }else{
    next()
  }
})

router.afterEach(() => {
  NProgress.done()
})

new Vue({
  components: { App },
  router,
  store,
  template: '<App/>'
}).$mount('#app')
