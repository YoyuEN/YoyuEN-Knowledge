import request from '@/utils/request'

export function fetchCommentList(contentId, contentType) {
  return request.get('/comment/list', { params: { contentId, contentType } })
}

export function createComment(data) {
  if (data instanceof FormData) {
    return request.post('/comment/create', data, {
      headers: { 'Content-Type': 'multipart/form-data' },
    })
  }
  return request.post('/comment/create', data, {
    headers: { 'Content-Type': 'application/json' },
  })
}

export function removeComment(id) {
  return request.post('/comment/remove', { id })
}

export function removeCommentsByContent(contentId) {
  return request.post('/comment/remove/by-content', { contentId })
}

export function fetchRecommendComments() {
  return request.get('/comment/recommend')
}

export function fetchCommentCount(contentId, contentType) {
  const params = { contentId }
  if (contentType) {
    params.contentType = contentType
  }
  return request.get('/comment/count', { params })
}

export function fetchAllComments(params) {
  return request.get('/comment/all', { params })
}

export function approveComment(id) {
  return request.post('/comment/approve', { id })
}

export function toggleCommentRecommend(id, isRecommend) {
  return request.post('/comment/recommend', { id, isRecommend })
}
