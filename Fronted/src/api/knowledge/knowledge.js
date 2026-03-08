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
