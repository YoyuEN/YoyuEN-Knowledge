import request from '@/utils/request'

/**
 * 获取日记/生活经历列表
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
