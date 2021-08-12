import Vue from 'vue'
import Vuex from 'vuex'
import Cookies from 'js-cookie'
const TokenKey = 'token'

Vue.use(Vuex)
const dd = {
  opened: false,
  withoutAnimation: false
}
const store = new Vuex.Store({
  state: {
    sidebar: dd,
    device: 'desktop',
    user: {
      token: 'add',
      name: 'zhangsna',
      avatar: '',
      roles: ['2', '2e', '3']
    }
  },

  getters: {
    user: state => state.user,
  },
  mutations: {
    login(state, user) {
      state.user = user;
    },
    logout: (state) => {
      state.user = {}
    },

  },
  actions: {
    Login({ commit }, userInfo) {
      const username = userInfo.username.trim()
      this.$http.post(this.$api.login, {username: username, password: userInfo.password}).then( r=>{
        const data = r.data
        Cookies.set(TokenKey, data.token)
        commit('login', data)
      }).catch(e => {
        console.log(e)
      })
    },
    // 获取用户信息
    GetInfo({ commit, state }) {
      this.$http.get(this.$api.getInfo).then(r=>{
        const data = r.data
      })
    },
    // 登出
    LogOut({ commit, state }) {
      this.$http.post(this.$api.logout).then(r=>{
        commit('logout', '')
        Cookies.remove(TokenKey)
      })
    },
    // 前端 登出
    FedLogOut({ commit }) {
      return new Promise(resolve => {
        Cookies.remove(TokenKey)
        commit('logout', '')
        resolve()
      })
    },
    CloseSideBar({ commit }, { withoutAnimation }) {
      this.state.sidebar.opened = false
      this.state.sidebar.withoutAnimation = withoutAnimation
    },
    ToggleDevice({ commit }, device) {
      this.state.device = device
    }
  }
})

store.set = (key, value) => {
  localStorage.setItem(key, value)
}
store.get = (key) => {
  localStorage.getItem(key)
}
store.pop = (key) => {
  localStorage.removeItem(key)
}

export default store
