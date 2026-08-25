import request from '@/utils/request'
import { getToken } from '@/utils/auth'

/** 获取AI助手报告（SSE流式，返回原始 fetch Response） */
export function fetchAssistantReport() {
  return fetch('/api/dashboard/assistant/report', {
    method: 'GET',
    headers: {
      Accept: 'text/event-stream',
      Authorization: `Bearer ${getToken() || ''}`,
    },
  })
}

/** 获取网站访问统计 */
export function fetchStatistics() {
  return request({ url: '/dashboard/statistics', method: 'get' })
}

/** 获取快捷信息 */
export function fetchQuickInfo() {
  return request({ url: '/dashboard/quick-info', method: 'get' })
}
