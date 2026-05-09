import request from '@/utils/request'

/**
 * 获取日记/生活经历列表（前台公开）
 * @param {string} type - 'diary' 或 'life_experience'
 */
export function fetchDiaryList(type) {
  return request({
    url: '/diary/list',
    method: 'get',
    params: { type }
  })
}

/**
 * 获取日记列表（后台管理，需要权限）
 */
export function fetchDiaryAdminList() {
  return request({
    url: '/diary/admin-list',
    method: 'get'
  })
}

/**
 * 创建日记/生活经历
 */
export function createDiary(data) {
  return request({
    url: '/diary/create',
    method: 'post',
    data
  })
}

/**
 * 更新日记/生活经历
 */
export function updateDiary(data) {
  return request({
    url: '/diary/update',
    method: 'post',
    data
  })
}

/**
 * 删除日记/生活经历
 */
export function removeDiary(id) {
  return request({
    url: `/diary/remove/${id}`,
    method: 'post'
  })
}
