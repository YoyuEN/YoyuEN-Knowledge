import request from '@/utils/request'

/**
 * 获取内容的评论列表（树形结构）
 * @param {string} contentId
 * @param {string} contentType
 */
export function fetchCommentList(contentId, contentType) {
  return request.get('/comment/list', { params: { contentId, contentType } })
}

/**
 * 添加评论
 * @param {FormData | Object} data - FormData (带头像上传) 或普通对象 (不带头像)
 */
export function createComment(data) {
  if (data instanceof FormData) {
    return request.post('/comment/create', data, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })
  }
  return request.post('/comment/create', data, {
    headers: { 'Content-Type': 'application/json' }
  })
}

/**
 * 删除评论
 * @param {string} id 评论ID
 */
export function removeComment(id) {
  return request.post('/comment/remove', { id })
}

/**
 * 获取推荐评论列表
 */
export function fetchRecommendComments() {
  return request.get('/comment/recommend')
}

/**
 * 获取评论数量
 * @param {string} contentId
 * @param {string} contentType
 */
export function fetchCommentCount(contentId, contentType) {
  return request.get('/comment/count', { params: { contentId, contentType } })
}

/**
 * 获取所有评论列表（后台管理用）
 * @param {{ keyword?: string, status?: string }} params
 */
export function fetchAllComments(params) {
  return request.get('/comment/all', { params })
}

/**
 * 审核通过评论
 * @param {string} id
 */
export function approveComment(id) {
  return request.post('/comment/approve', { id })
}

/**
 * 切换评论推荐状态
 * @param {string} id
 * @param {boolean} isRecommend
 */
export function toggleCommentRecommend(id, isRecommend) {
  return request.post('/comment/recommend', { id, isRecommend })
}
