import request from '@/utils/request'

/** 获取碎碎念列表（全量） */
export function fetchMurmurList() {
  return request.get('/murmur/list')
}

/**
 * 获取最新N条碎碎念
 * @param limit 条数，默认5
 */
export function fetchLatestMurmur(limit = 5) {
  return request.get('/murmur/latest', { params: { limit } })
}

/** 添加碎碎念 */
export function createMurmur(data: { content: string }) {
  return request.post('/murmur/create', data)
}

/** 更新碎碎念 */
export function updateMurmur(data: { id: string; content: string }) {
  return request.post('/murmur/update', data)
}

/** 删除碎碎念 */
export function removeMurmur(id: string) {
  return request.post('/murmur/remove', { id })
}
