import request from '@/utils/request'

/** 获取个人资料详情 */
export function fetchProfileDetail() {
  return request({ url: '/profile/detail', method: 'get' })
}

/** 更新个人资料 */
export function updateProfile(data: unknown) {
  return request({ url: '/profile/update', method: 'post', data })
}
