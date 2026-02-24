/**
 * 流式对话接口（SSE 格式）
 * 后端返回 Flux<ChatResponse>，以 text/event-stream 格式推送
 * 每个事件格式为 data: {...}\n\n
 * content 在每个元素的 result.output.content 字段
 * finishReason: "STOP" 的元素表示结束
 *
 * @param {string} message - 用户输入的消息
 * @param {function} onChunk - 每收到一段文本时的回调 (text: string) => void
 * @param {function} onDone - 流结束时的回调 () => void
 * @param {function} onError - 出错时的回调 (error: Error) => void
 * @returns {AbortController} - 可调用 .abort() 取消请求
 */
export function chatStream(message, onChunk, onDone, onError) {
  const controller = new AbortController()

  const token = localStorage.getItem('token')
  const headers = {
    'Content-Type': 'application/json',
  }
  if (token) {
    headers['Authorization'] = token.startsWith('Bearer ') ? token : `Bearer ${token}`
  }

  fetch('/api/ai/chat/simple', {
    method: 'POST',
    headers,
    body: JSON.stringify({ content: message }),
    signal: controller.signal,
  })
    .then((response) => {
      if (!response.ok) {
        throw new Error(`请求失败: ${response.status}`)
      }

      const reader = response.body.getReader()
      const decoder = new TextDecoder('utf-8')
      let buffer = ''

      const read = () => {
        reader
          .read()
          .then(({ done, value }) => {
            if (done) {
              onDone?.()
              return
            }

            buffer += decoder.decode(value, { stream: true })

            // SSE 格式：data: {...}\n\n，按双换行符分割事件
            const events = buffer.split('\n\n')
            buffer = events.pop() || '' // 最后一段可能不完整

            for (const event of events) {
              const lines = event.split('\n')
              for (const line of lines) {
                if (line.startsWith('data:')) {
                  const json = line.substring(5).trim()
                  if (json) {
                    try {
                      const data = JSON.parse(json)
                      const content = data?.result?.output?.content
                      const finishReason = data?.result?.metadata?.finishReason

                      if (content) {
                        onChunk?.(content)
                      }

                      if (finishReason === 'STOP') {
                        onDone?.()
                        return
                      }
                    } catch {
                      // 忽略解析失败
                    }
                  }
                }
              }
            }

            read()
          })
          .catch((err) => {
            if (err.name !== 'AbortError') {
              onError?.(err)
            }
          })
      }

      read()
    })
    .catch((err) => {
      if (err.name !== 'AbortError') {
        onError?.(err)
      }
    })

  return controller
}
