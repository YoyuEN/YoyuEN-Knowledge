import request from '@/utils/request'

/**
 * 根据ID获取内容详情（同时增加浏览量）
 * @param {string} id
 */
export function fetchContentById(id) {
  return request.get(`/content/${id}`)
}

/**
 * 根据分类获取内容列表
 * @param {string} category  article | game | study | video
 */
export function fetchContentByCategory(category) {
  return request.get(`/content/list/${category}`)
}

/**
 * 获取推荐内容列表
 */
export function fetchRecommendContent() {
  return request.get('/content/recommend')
}

/**
 * 添加内容
 * @param {{ title: string, description: string, category: string, cover: string, content: string, isRecommend: boolean }} data
 */
export function createContent(data) {
  return request.post('/content/create', data)
}

/**
 * 更新内容
 * @param {{ id: string, title?: string, description?: string, category?: string, cover?: string, content?: string, isRecommend?: boolean }} data
 */
export function updateContent(data) {
  return request.post('/content/update', data)
}

/**
 * 删除内容
 * @param {string} id
 */
export function removeContent(id) {
  return request.post('/content/remove', { id })
}
