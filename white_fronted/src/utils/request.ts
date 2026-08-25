import axios, {
  type AxiosInstance,
  type AxiosResponse,
  type InternalAxiosRequestConfig,
} from 'axios'
import { getToken } from './auth'
import { store } from '@/store'
import { logout } from '@/store/authSlice'

export interface ApiResponse<T = unknown> {
  code: number
  message: string
  data: T
}

const service: AxiosInstance = axios.create({
  baseURL: '/api',
  timeout: 60000,
})

// 请求拦截器：添加 token
service.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    const token = getToken()
    if (token) {
      config.headers.Authorization = token.startsWith('Bearer ')
        ? token
        : `Bearer ${token}`
    }
    return config
  },
  (error) => Promise.reject(error),
)

// 响应拦截器：处理响应和错误
service.interceptors.response.use(
  (response: AxiosResponse) => {
    const payload = response.data
    if (
      payload &&
      typeof payload === 'object' &&
      Object.prototype.hasOwnProperty.call(payload, 'code')
    ) {
      if (payload.code === 200) {
        return payload
      }
      return Promise.reject(new Error(payload.message || '请求失败'))
    }
    return { code: 200, message: 'success', data: payload }
  },
  (error) => {
    if (error.response) {
      const { status } = error.response

      // 401 未授权：清除状态并跳转登录页（保留 redirect）
      if (status === 401) {
        store.dispatch(logout())
        const redirect = encodeURIComponent(
          window.location.pathname + window.location.search,
        )
        if (!window.location.pathname.startsWith('/login')) {
          window.location.href = `/login?redirect=${redirect}`
        }
        return Promise.reject(new Error('未登录或登录已过期，请重新登录'))
      }

      if (status === 403) {
        return Promise.reject(new Error('没有权限访问'))
      }

      if (status === 500) {
        return Promise.reject(new Error('服务器错误'))
      }
    }

    return Promise.reject(error)
  },
)

// 泛型包装：调用处可直接拿到 ApiResponse<T>
export function request<T = unknown>(
  config: Parameters<AxiosInstance['request']>[0],
): Promise<ApiResponse<T>> {
  return service.request(config) as unknown as Promise<ApiResponse<T>>
}

export default service
