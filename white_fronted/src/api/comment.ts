import request from '@/utils/request'

export function fetchCommentList(contentId: string | number, contentType?: string) {
  return request.get('/comment/list', { params: { contentId, contentType } })
}

export function createComment(data: FormData | Record<string, unknown>) {
  if (data instanceof FormData) {
    return request.post('/comment/create', data, {
      headers: { 'Content-Type': 'multipart/form-data' },
    })
  }
  return request.post('/comment/create', data, {
    headers: { 'Content-Type': 'application/json' },
  })
}

export function removeComment(id: string | number) {
  return request.post('/comment/remove', { id })
}

export function removeCommentsByContent(contentId: string | number) {
  return request.post('/comment/remove/by-content', { contentId })
}

export function fetchRecommendComments() {
  return request.get('/comment/recommend')
}

export function fetchCommentCount(contentId: string | number, contentType?: string) {
  const params: Record<string, unknown> = { contentId }
  if (contentType) {
    params.contentType = contentType
  }
  return request.get('/comment/count', { params })
}

export function fetchAllComments(params?: Record<string, unknown>) {
  return request.get('/comment/all', { params })
}

export function approveComment(id: string | number) {
  return request.post('/comment/approve', { id })
}

export function toggleCommentRecommend(id: string | number, isRecommend: boolean) {
  return request.post('/comment/recommend', { id, isRecommend })
}
