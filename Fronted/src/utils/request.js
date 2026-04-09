import axios from 'axios'
import { getToken, removeToken } from './auth'
import router from '../router/router'

const service = axios.create({
  baseURL: '/api',
  timeout: 15000,
})

// 请求拦截器：添加 token
service.interceptors.request.use(
  (config) => {
    const token = getToken()
    if (token) {
      config.headers.Authorization = token.startsWith('Bearer ') ? token : `Bearer ${token}`
    }
    return config
  },
  (error) => Promise.reject(error),
)

// 响应拦截器：处理响应和错误
service.interceptors.response.use(
  (response) => {
    const payload = response.data
    if (payload && typeof payload === 'object' && Object.prototype.hasOwnProperty.call(payload, 'code')) {
      if (payload.code === 200) {
        return payload
      }
      return Promise.reject(new Error(payload.message || '请求失败'))
    }
    return { code: 200, message: 'success', data: payload }
  },
  (error) => {
    // 处理 HTTP 错误状态码
    if (error.response) {
      const { status } = error.response

      // 401 未授权：清除 token 并跳转到登录页
      if (status === 401) {
        removeToken()
        router.push('/login')
        return Promise.reject(new Error('未登录或登录已过期，请重新登录'))
      }

      // 403 禁止访问
      if (status === 403) {
        return Promise.reject(new Error('没有权限访问'))
      }

      // 500 服务器错误
      if (status === 500) {
        return Promise.reject(new Error('服务器错误'))
      }
    }

    return Promise.reject(error)
  },
)

export default service
