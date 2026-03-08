import request from '@/utils/request'

/**
 * 获取内容统计数据
 */
export function fetchContentStats() {
  return request.get('/content/stats')
}

/**
 * 获取所有有内容的分类列表
 */
export function fetchContentCategories() {
  return request.get('/content/categories')
}

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
 * 获取最近 N 天每日发布数量（热力图）
 * @param {number} days 天数，默认100
 */
export function fetchActivityStats(days = 100) {
  return request.get('/content/activity', { params: { days } })
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

/**
 * 获取所有内容列表（后台管理用）
 * @param {{ keyword?: string, status?: string }} params
 */
export function fetchAllContent(params) {
  return request.get('/content/all', { params })
}

/**
 * 切换内容推荐状态
 * @param {string} id
 * @param {boolean} isRecommend
 */
export function toggleContentRecommend(id, isRecommend) {
  return request.post('/content/recommend', { id, isRecommend })
}
