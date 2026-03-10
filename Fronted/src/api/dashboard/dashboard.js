import request from '@/utils/request'

/**
 * 获取AI助手报告（SSE流式）
 */
export function fetchAssistantReport() {
  return fetch('/api/dashboard/assistant/report', {
    method: 'GET',
    headers: {
      'Accept': 'text/event-stream',
      'Authorization': `Bearer ${localStorage.getItem('token') || ''}`
    }
  })
}

/**
 * 获取网站访问统计
 */
export function fetchStatistics() {
  return request({
    url: '/api/dashboard/statistics',
    method: 'get'
  })
}

/**
 * 获取快捷信息
 */
export function fetchQuickInfo() {
  return request({
    url: '/api/dashboard/quick-info',
    method: 'get'
  })
}
