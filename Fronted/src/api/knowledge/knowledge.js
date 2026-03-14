import request from '@/utils/request'

/**
 * 获取知识库列表
 * @param {{ keyword?: string, category?: string }} params
 */
export function fetchKnowledgeList(params) {
  return request.get('/knowledge/list', { params })
}

/**
 * 根据ID获取知识详情
 * @param {string} id
 */
export function fetchKnowledgeById(id) {
  return request.get(`/knowledge/${id}`)
}

/**
 * 创建知识
 * @param {{ title: string, content: string, category: string }} data
 */
export function createKnowledge(data) {
  return request.post('/knowledge/create', data)
}

/**
 * 更新知识
 * @param {{ id: string, title?: string, content?: string, category?: string }} data
 */
export function updateKnowledge(data) {
  return request.post('/knowledge/update', data)
}

/**
 * 删除知识
 * @param {string} id
 */
export function removeKnowledge(id) {
  return request.post('/knowledge/remove', { id })
}

/**
 * 获取知识库管理列表
 * @param {{ keyword?: string }} params
 */
export function fetchKnowledgeBaseList(params) {
  return request.get('/knowledge/base/list', { params })
}

/**
 * 创建知识库
 * @param {{ name: string, description?: string, status: string }} data
 */
export function createKnowledgeBase(data) {
  return request.post('/knowledge/base/create', data)
}

/**
 * 更新知识库
 * @param {{ id: string, name?: string, description?: string, status?: string }} data
 */
export function updateKnowledgeBase(data) {
  return request.post('/knowledge/base/update', data)
}

/**
 * 删除知识库
 * @param {string} id
 */
export function removeKnowledgeBase(id) {
  return request.post('/knowledge/base/remove', { id })
}

/**
 * 切换知识库状态
 * @param {{ id: string, status: string }} data
 */
export function toggleKnowledgeBaseStatus(data) {
  return request.post('/knowledge/base/toggle-status', data)
}

/**
 * 上传知识库文档
 * @param {FormData} formData
 */
export function uploadKnowledgeDocument(formData) {
  return request.post('/knowledge/base/upload', formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}
