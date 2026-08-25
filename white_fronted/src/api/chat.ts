import { buildAuthHeaders, sseStream } from '@/utils/sse'

export interface Conversation {
  conversationId: string
  title?: string
  createTime?: string
  [key: string]: unknown
}

export interface ChatReference {
  [key: string]: unknown
}

/** 创建新对话 */
export async function createConversation(
  conversationVO: Record<string, unknown> = {},
): Promise<Conversation> {
  const response = await fetch('/api/conversation/create', {
    method: 'POST',
    headers: buildAuthHeaders(),
    body: JSON.stringify(conversationVO),
  })
  if (!response.ok) {
    throw new Error(`创建对话失败: ${response.status}`)
  }
  const result = await response.json()
  return result.data
}

/** 获取对话历史列表 */
export async function fetchConversationList(
  knowledgeBaseId: string | null = null,
): Promise<Conversation[]> {
  const url = new URL('/api/conversation/list', window.location.origin)
  if (knowledgeBaseId) {
    url.searchParams.append('knowledgeBaseId', knowledgeBaseId)
  }
  const response = await fetch(url, {
    method: 'GET',
    headers: buildAuthHeaders(),
  })
  if (!response.ok) {
    throw new Error(`获取对话历史失败: ${response.status}`)
  }
  const result = await response.json()
  return result.data || []
}

/**
 * 简单流式对话（Flux<ChatResponse>）
 * content 在 data.result.output.content；finishReason 在 data.result.metadata.finishReason
 */
export function chatStream(
  message: string,
  conversationId: string | null,
  onChunk: (text: string) => void,
  onDone?: () => void,
  onError?: (error: Error) => void,
): AbortController {
  return sseStream(
    '/api/ai/chat/simple',
    { content: message, conversationId },
    {
      onEvent: (data) => {
        const d = data as {
          result?: { output?: { content?: string }; metadata?: { finishReason?: string } }
        }
        const content = d?.result?.output?.content
        const finishReason = d?.result?.metadata?.finishReason
        if (content) onChunk(content)
        if (finishReason === 'STOP') onDone?.()
      },
      onDone,
      onError,
    },
  )
}

/**
 * RAG 流式对话（Flux<Generation>）
 * content 在 data.output.content；finishReason 在 data.metadata.finishReason
 */
export function chatStreamRAG(
  message: string,
  conversationId: string | null,
  onChunk: (text: string) => void,
  onDone?: () => void,
  onError?: (error: Error) => void,
): AbortController {
  return sseStream(
    '/api/ai/chat/simpleRAG',
    { content: message, conversationId, resourceIds: [] },
    {
      onEvent: (data) => {
        const d = data as {
          output?: { content?: string }
          metadata?: { finishReason?: string }
        }
        const content = d?.output?.content
        const finishReason = d?.metadata?.finishReason
        if (content) onChunk(content)
        if (finishReason === 'STOP') onDone?.()
      },
      onDone,
      onError,
    },
  )
}

/**
 * RAG 流式对话 - 带引用（Flux<ChatResponseWithReferencesVO>）
 * content 在 data.content；references 在 data.references；finishReason 在 data.finishReason
 */
export function chatStreamRAGWithReferences(
  message: string,
  conversationId: string | null,
  knowledgeBaseId: string | null,
  onChunk: (text: string) => void,
  onReferences: (references: ChatReference[]) => void,
  onDone?: () => void,
  onError?: (error: Error) => void,
): AbortController {
  let referencesReceived = false
  return sseStream(
    '/api/ai/chat/simpleRAGWithReferences',
    { content: message, conversationId, resourceIds: [], knowledgeBaseId },
    {
      onEvent: (data) => {
        const d = data as {
          content?: string
          references?: ChatReference[]
          finishReason?: string
        }
        if (d?.content) onChunk(d.content)
        if (d?.references && !referencesReceived) {
          referencesReceived = true
          onReferences(d.references)
        }
        if (d?.finishReason === 'STOP') onDone?.()
      },
      onDone,
      onError,
    },
  )
}
