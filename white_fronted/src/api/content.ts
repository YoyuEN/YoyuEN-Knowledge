import request from '@/utils/request'

export function fetchContentStats() {
  return request.get('/content/stats')
}

export function fetchContentCategories() {
  return request.get('/content/categories')
}

export function createContentCategory(data: Record<string, unknown>) {
  return request.post('/content/category/create', data)
}

export function updateContentCategory(data: Record<string, unknown>) {
  return request.post('/content/category/update', data)
}

export function removeContentCategory(type: string) {
  return request.post('/content/category/remove', { type })
}

export function fetchContentTags() {
  return request.get('/content/tags')
}

export function createContentTag(name: string) {
  return request.post('/content/tag/create', { name })
}

export function updateContentTag(oldName: string, newName: string) {
  return request.post('/content/tag/update', { oldName, newName })
}

export function removeContentTag(name: string) {
  return request.post('/content/tag/remove', { name })
}

export function fetchContentById(id: string | number) {
  return request.get(`/content/${id}`)
}

export function fetchContentByCategory(category: string) {
  return request.get(`/content/list/${category}`)
}

export function fetchRecommendContent() {
  return request.get('/content/recommend')
}

export function fetchActivityStats(days = 100) {
  return request.get('/content/activity', { params: { days } })
}

export function uploadContentImage(file: File) {
  const form = new FormData()
  form.append('file', file)
  return request.post('/content/upload-content-image', form, {
    headers: { 'Content-Type': 'multipart/form-data' },
  })
}

export function uploadContentCover(file: File) {
  const form = new FormData()
  form.append('file', file)
  return request.post('/content/upload-cover', form, {
    headers: { 'Content-Type': 'multipart/form-data' },
  })
}

export function createContent(data: Record<string, unknown>) {
  return request.post('/content/create', data)
}

export function updateContent(data: Record<string, unknown>) {
  return request.post('/content/update', data)
}

export function removeContent(id: string | number) {
  return request.post('/content/remove', { id })
}

export function fetchAllContent(params?: Record<string, unknown>) {
  return request.get('/content/all', { params })
}

export function toggleContentRecommend(id: string | number, isRecommend: boolean) {
  return request.post('/content/recommend', { id, isRecommend })
}

export function uploadVideo(
  file: File,
  onProgress?: (progressEvent: unknown) => void,
) {
  const form = new FormData()
  form.append('file', file)
  return request.post('/content/upload-video', form, {
    headers: { 'Content-Type': 'multipart/form-data' },
    onUploadProgress: onProgress,
  })
}

export function parseDocument(file: File) {
  const form = new FormData()
  form.append('file', file)
  return request.post('/content/parse-document', form, {
    headers: { 'Content-Type': 'multipart/form-data' },
  })
}

export function extractVideoCover(videoUrl: string) {
  return request.post('/content/extract-video-cover', { videoUrl })
}
