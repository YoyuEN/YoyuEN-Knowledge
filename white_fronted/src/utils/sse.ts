import { getToken } from './auth'

export function buildAuthHeaders(): Record<string, string> {
  const token = getToken()
  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
  }
  if (token) {
    headers['Authorization'] = token.startsWith('Bearer ')
      ? token
      : `Bearer ${token}`
  }
  return headers
}

export interface SSEHandlers {
  /** 每个 data: 事件解析出的 JSON 对象 */
  onEvent: (data: unknown) => void
  onDone?: () => void
  onError?: (error: Error) => void
}

/**
 * 通用 SSE 流式请求：fetch + AbortController，手动解析 `data:` 事件。
 * 返回 AbortController，可调用 .abort() 取消。
 */
export function sseStream(
  url: string,
  body: unknown,
  handlers: SSEHandlers,
): AbortController {
  const controller = new AbortController()
  const { onEvent, onDone, onError } = handlers

  fetch(url, {
    method: 'POST',
    headers: buildAuthHeaders(),
    body: JSON.stringify(body),
    signal: controller.signal,
  })
    .then((response) => {
      if (!response.ok) {
        throw new Error(`请求失败: ${response.status}`)
      }
      const reader = response.body!.getReader()
      const decoder = new TextDecoder('utf-8')
      let buffer = ''

      const read = (): void => {
        reader
          .read()
          .then(({ done, value }) => {
            if (done) {
              onDone?.()
              return
            }
            buffer += decoder.decode(value, { stream: true })
            const events = buffer.split('\n\n')
            buffer = events.pop() || ''

            for (const event of events) {
              const lines = event.split('\n')
              for (const line of lines) {
                if (line.startsWith('data:')) {
                  const json = line.substring(5).trim()
                  if (json) {
                    try {
                      onEvent(JSON.parse(json))
                    } catch {
                      // 忽略解析失败
                    }
                  }
                }
              }
            }
            read()
          })
          .catch((err: Error) => {
            if (err.name !== 'AbortError') {
              onError?.(err)
            }
          })
      }
      read()
    })
    .catch((err: Error) => {
      if (err.name !== 'AbortError') {
        onError?.(err)
      }
    })

  return controller
}
