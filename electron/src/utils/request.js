import axios from 'axios'
import { Message, MessageBox } from 'element-ui'
import store from './store'

const service = axios.create({baseURL: process.env.BASE_API, timeout: 15000})

service.interceptors.request.use(config => {
  if (store.state.user.token) {
    config.headers['X-Token'] = store.state.user.token
  }
  return config
}, error => {
  console.log(error)
    return Promise.reject(error)
})

service.interceptors.response.use(response => {
    const res = response.data
    if (res.code === 200) {
      return response.data
    } else if (res.code === 403) {
        MessageBox.confirm('你已被登出，可以取消继续留在该页面，或者重新登录', '确定登出', {
          confirmButtonText: '重新登录',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          store.dispatch('FedLogOut').then(() => {
            location.reload()
          })
        })
      return Promise.reject('error')
    } else {
      Message({message: res.message, type: 'error', duration: 5 * 1000})
    }
  },error => {
    console.log('err' + error)// for debug
    Message({message: error.message, type: 'error', duration: 5 * 1000})
    return Promise.reject(error)
  }
)

export default service
