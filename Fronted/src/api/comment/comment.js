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
 * @param {{ contentId: string, contentType: string, content: string, parentId?: string }} data
 */
export function createComment(data) {
  return request.post('/comment/create', data)
}

/**
 * 删除评论
 * @param {string} id 评论ID
 */
export function removeComment(id) {
  return request.post('/comment/remove', { id })
}

/**
 * 获取评论数量
 * @param {string} contentId
 * @param {string} contentType
 */
export function fetchCommentCount(contentId, contentType) {
  return request.get('/comment/count', { params: { contentId, contentType } })
}
