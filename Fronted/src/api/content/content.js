import request from '@/utils/request'

export function fetchContentStats() {
  return request.get('/content/stats')
}

export function fetchContentCategories() {
  return request.get('/content/categories')
}

export function createContentCategory(data) {
  return request.post('/content/category/create', data)
}

export function updateContentCategory(data) {
  return request.post('/content/category/update', data)
}

export function removeContentCategory(type) {
  return request.post('/content/category/remove', { type })
}

export function fetchContentTags() {
  return request.get('/content/tags')
}

export function createContentTag(name) {
  return request.post('/content/tag/create', { name })
}

export function updateContentTag(oldName, newName) {
  return request.post('/content/tag/update', { oldName, newName })
}

export function removeContentTag(name) {
  return request.post('/content/tag/remove', { name })
}

export function fetchContentById(id) {
  return request.get(`/content/${id}`)
}

export function fetchContentByCategory(category) {
  return request.get(`/content/list/${category}`)
}

export function fetchRecommendContent() {
  return request.get('/content/recommend')
}

export function fetchActivityStats(days = 100) {
  return request.get('/content/activity', { params: { days } })
}

export function uploadContentCover(file) {
  const form = new FormData()
  form.append('file', file)
  return request.post('/content/upload-cover', form, {
    headers: { 'Content-Type': 'multipart/form-data' },
  })
}

export function createContent(data) {
  return request.post('/content/create', data)
}

export function updateContent(data) {
  return request.post('/content/update', data)
}

export function removeContent(id) {
  return request.post('/content/remove', { id })
}

export function fetchAllContent(params) {
  return request.get('/content/all', { params })
}

export function toggleContentRecommend(id, isRecommend) {
  return request.post('/content/recommend', { id, isRecommend })
}

export function uploadVideo(file, onProgress) {
  const form = new FormData()
  form.append('file', file)
  return request.post('/content/upload-video', form, {
    headers: { 'Content-Type': 'multipart/form-data' },
    onUploadProgress: onProgress
  })
}

export function extractVideoCover(videoUrl) {
  return request.post('/content/extract-video-cover', { videoUrl })
}
