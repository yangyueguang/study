import Vue from 'vue'
import Vuex from 'vuex'
import { login, logout, getInfo } from '@/utils/api'
import { setToken, removeToken } from '@/utils/auth'

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
      token: '23',
      name: '',
      avatar: '',
      roles: []
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
      return new Promise((resolve, reject) => {
        login(username, userInfo.password).then(response => {
          const data = response.data
          setToken(data.token)
          commit('login', data)
          resolve()
        }).catch(error => {
          reject(error)
        })
      })
    },
    // 获取用户信息
    GetInfo({ commit, state }) {
      return new Promise((resolve, reject) => {
        getInfo(this.state.token).then(response => {
          const data = response.data
          if (data.roles && data.roles.length > 0) { // 验证返回的roles是否是一个非空数组
          } else {
            reject('getInfo: roles must be a non-null array !')
          }
          resolve(response)
        }).catch(error => {
          reject(error)
        })
      })
    },
    // 登出
    LogOut({ commit, state }) {
      return new Promise((resolve, reject) => {
        logout(state.token).then(() => {
          commit('logout', '')
          removeToken()
          resolve()
        }).catch(error => {
          reject(error)
        })
      })
    },
    // 前端 登出
    FedLogOut({ commit }) {
      return new Promise(resolve => {
        removeToken()
        commit('logout', '')
        resolve()
      })
    },
    CloseSideBar({ commit }, { withoutAnimation }) {
      debugger
      this.state.sidebar.opened = false
      this.state.sidebar.withoutAnimation = withoutAnimation
    },
    ToggleDevice({ commit }, device) {
      this.state.device = device
    }
  }
})
export default store
