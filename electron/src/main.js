import Vue from 'vue'
import ElementUI from 'element-ui'
import App from './App'
import router from '@/utils/router'
import store from '@/utils/store'
import NProgress from 'nprogress'

Vue.use(require('vue-electron'))
Vue.use(ElementUI)
Vue.prototype.$store = store;
Vue.config.productionTip = false
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
