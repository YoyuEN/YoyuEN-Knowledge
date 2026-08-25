import request from '@/utils/request'

/** 获取知识库列表 */
export function fetchKnowledgeList(params?: { keyword?: string; category?: string }) {
  return request.get('/knowledge/list', { params })
}

/** 根据ID获取知识详情 */
export function fetchKnowledgeById(id: string) {
  return request.get(`/knowledge/${id}`)
}

/** 创建知识 */
export function createKnowledge(data: { title: string; content: string; category: string }) {
  return request.post('/knowledge/create', data)
}

/** 更新知识 */
export function updateKnowledge(data: {
  id: string
  title?: string
  content?: string
  category?: string
}) {
  return request.post('/knowledge/update', data)
}

/** 删除知识 */
export function removeKnowledge(id: string) {
  return request.post('/knowledge/remove', { id })
}

/** 获取知识库管理列表 */
export function fetchKnowledgeBaseList(params?: { keyword?: string }) {
  return request.get('/knowledge/base/list', { params })
}

/** 创建知识库 */
export function createKnowledgeBase(data: {
  name: string
  description?: string
  status: string
}) {
  return request.post('/knowledge/base/create', data)
}

/** 更新知识库 */
export function updateKnowledgeBase(data: {
  id: string
  name?: string
  description?: string
  status?: string
}) {
  return request.post('/knowledge/base/update', data)
}

/** 删除知识库 */
export function removeKnowledgeBase(id: string) {
  return request.post('/knowledge/base/remove', { id })
}

/** 切换知识库状态 */
export function toggleKnowledgeBaseStatus(data: { id: string; status: string }) {
  return request.post('/knowledge/base/toggle-status', data)
}

/** 上传知识库文档 */
export function uploadKnowledgeDocument(formData: FormData) {
  return request.post('/knowledge/base/upload', formData, {
    headers: { 'Content-Type': 'multipart/form-data' },
  })
}

/** 获取知识库文档列表（分页） */
export function fetchDocuments(
  knowledgeId: string,
  params: { pageNo?: number; pageSize?: number } = {},
) {
  return request.get(`/resource/knowledge/${knowledgeId}/documents`, { params })
}

/** 删除知识库文档 */
export function removeDocument(data: {
  id: number
  baseId: string
  knowledgeBaseId: string
}) {
  return request.post('/resource/document/delete', data)
}

/** 下载文档 URL */
export function downloadDocumentUrl(fileId: number): string {
  return `/api/resource/document/download/${fileId}`
}
