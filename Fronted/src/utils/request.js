import axios from 'axios'

const service = axios.create({
  baseURL: '/api',
  timeout: 15000,
})

service.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = token.startsWith('Bearer ') ? token : `Bearer ${token}`
    }
    return config
  },
  (error) => Promise.reject(error),
)

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
  (error) => Promise.reject(error),
)

export default service
