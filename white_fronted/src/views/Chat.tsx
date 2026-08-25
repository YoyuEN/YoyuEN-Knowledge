import { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import { marked } from 'marked'
import { Plus, Copy, RefreshCw, X } from 'lucide-react'
import { cn } from '@/lib/utils'
import {
  createConversation,
  fetchConversationList,
  chatStreamRAGWithReferences,
} from '@/api/chat'
import { fetchKnowledgeBaseList } from '@/api/knowledge'

interface Message {
  id: number
  role: 'user' | 'assistant'
  content: string
  time: string
  references?: any[]
  status: 'done' | 'streaming' | 'error'
  errorMsg?: string
}

interface KnowledgeItem {
  id: string
  name: string
  description?: string
}

interface ConversationItem {
  id: string
  title?: string
  updateTime?: string
}

const LS_KEY = 'chat_conversations'

function getTime() {
  const now = new Date()
  return `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`
}

function formatDateTime(ts?: string): string {
  if (!ts) return ''
  const d = new Date(ts.replace(/-/g, '/'))
  if (isNaN(d.getTime())) return ts.slice(0, 16)
  return `${d.getMonth() + 1}/${d.getDate()} ${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`
}

const renderMD = (content?: string) =>
  content ? (marked.parse(content, { breaks: true, gfm: true }) as string) : ''

function getStandbyConfig(kbName: string) {
  if (kbName === 'YoyuEN' || kbName.includes('内容') || kbName.includes('创作')) {
    return {
      title: '内容创作助手',
      subtitle: '基于网站文章和评论内容，为您提供专业的问答服务',
      suggestions: ['询问网站已发布的文章内容', '查询用户评论和反馈', '搜索特定主题的相关内容'],
    }
  }
  if (kbName.includes('个人') || kbName.includes('知识库')) {
    return {
      title: '个人知识库助手',
      subtitle: '了解个人信息、经历和专业知识',
      suggestions: ['询问个人背景和经历', '了解专业技能和项目经验', '探索个人知识和见解'],
    }
  }
  return {
    title: '欢迎使用 AI 助手',
    subtitle: '请在下方输入您的问题，我将为您提供帮助',
    suggestions: ['支持 Markdown 格式回复', '可以上传文件进行分析', '快速响应您的问题'],
  }
}

export default function Chat() {
  // Knowledge base
  const [knowledgeList, setKnowledgeList] = useState<KnowledgeItem[]>([])
  const [selectedKnowledge, setSelectedKnowledge] = useState('')

  // Conversations
  const [conversations, setConversations] = useState<ConversationItem[]>([])
  const [activeConvId, setActiveConvId] = useState<string | null>(null)

  // Messages
  const [messages, setMessages] = useState<Message[]>([])
  const [inputText, setInputText] = useState('')
  const [isStreaming, setStreaming] = useState(false)
  const [inputFocused, setInputFocused] = useState(false)

  const messagesEndRef = useRef<HTMLDivElement | null>(null)
  const textareaRef = useRef<HTMLTextAreaElement | null>(null)
  const abortRef = useRef<AbortController | null>(null)

  const selectedKbName = useMemo(
    () => knowledgeList.find((k) => k.id === selectedKnowledge)?.name ?? '',
    [knowledgeList, selectedKnowledge],
  )

  const standby = useMemo(() => getStandbyConfig(selectedKbName), [selectedKbName])

  const canSend = inputText.trim().length > 0 && !isStreaming

  const messageTurns = useMemo(() => {
    const turns: { user: Message; assistant: Message | null }[] = []
    for (let i = 0; i < messages.length; i++) {
      if (messages[i].role === 'user') {
        turns.push({
          user: messages[i],
          assistant: messages[i + 1]?.role === 'assistant' ? messages[i + 1] : null,
        })
      }
    }
    return turns
  }, [messages])

  const showStandby = messages.length === 0 && !isStreaming

  const lastAssistant = useMemo(() => {
    for (let i = messages.length - 1; i >= 0; i--) {
      if (messages[i].role === 'assistant') return messages[i]
    }
    return null
  }, [messages])

  const scrollDown = useCallback(() => {
    requestAnimationFrame(() => {
      messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' })
    })
  }, [])

  // Load knowledge list
  useEffect(() => {
    fetchKnowledgeBaseList()
      .then((res: any) => {
        const list = res?.data ?? []
        setKnowledgeList(list)
        if (list.length > 0 && !selectedKnowledge) {
          setSelectedKnowledge(list[0].id)
        }
      })
      .catch(() => {})
  }, [])

  // Load conversation history when KB changes
  useEffect(() => {
    if (!selectedKnowledge) return
    fetchConversationList(selectedKnowledge)
      .then((list: any[]) => setConversations((list ?? []).map((c) => ({ id: c.conversationId ?? c.id, title: c.title, updateTime: c.updateTime }))))
      .catch(() => setConversations([]))
  }, [selectedKnowledge])

  const saveToStorage = useCallback(() => {
    if (activeConvId) {
      const all = JSON.parse(localStorage.getItem(LS_KEY) || '{}')
      all[activeConvId] = { messages }
      localStorage.setItem(LS_KEY, JSON.stringify(all))
    }
  }, [activeConvId, messages])

  // Custom scroll handling
  const autoResize = () => {
    const el = textareaRef.current
    if (!el) return
    el.style.height = 'auto'
    el.style.height = Math.min(el.scrollHeight, 120) + 'px'
  }

  const sendMessage = useCallback(async () => {
    if (!canSend) return
    stopStream()

    const fullQuestion = inputText.trim()

    setMessages((prev) => [
      ...prev,
      { id: Date.now(), role: 'user', content: fullQuestion, time: getTime(), status: 'done' },
    ])

    setInputText('')
    if (textareaRef.current) textareaRef.current.style.height = 'auto'

    // Create conversation on first send
    let convId = activeConvId
    if (!convId) {
      try {
        const conv = await createConversation({
          title: fullQuestion.slice(0, 50),
          knowledgeBaseId: selectedKnowledge,
        })
        convId = conv?.conversationId ?? conv?.id ?? null
        if (convId) {
          setActiveConvId(convId)
          fetchConversationList(selectedKnowledge).then((l: any) => setConversations((l ?? []).map((c: any) => ({ id: c.conversationId ?? c.id, title: c.title, updateTime: c.updateTime })))).catch(() => {})
        }
      } catch (e) { console.error('创建对话失败', e) }
    }

    setStreaming(true)

    abortRef.current = chatStreamRAGWithReferences(
      fullQuestion,
      convId,
      selectedKnowledge,
      (chunk: string) => {
        setMessages((prev) => {
          const last = prev[prev.length - 1]
          if (last?.role === 'assistant' && last.status === 'streaming') {
            return [...prev.slice(0, -1), { ...last, content: last.content + chunk }]
          }
          return [
            ...prev,
            { id: Date.now(), role: 'assistant', content: chunk, time: getTime(), status: 'streaming' },
          ]
        })
      },
      (refs: any[]) => {
        setMessages((prev) => {
          const last = prev[prev.length - 1]
          if (last?.role === 'assistant') {
            return [...prev.slice(0, -1), { ...last, references: refs }]
          }
          return prev
        })
      },
      () => {
        setMessages((prev) => {
          const last = prev[prev.length - 1]
          if (last?.role === 'assistant') {
            return [...prev.slice(0, -1), { ...last, status: 'done' }]
          }
          return prev
        })
        setStreaming(false)
        abortRef.current = null
        saveToStorage()
      },
      (err: Error) => {
        setMessages((prev) => {
          const last = prev[prev.length - 1]
          if (last?.role === 'assistant') {
            return [...prev.slice(0, -1), { ...last, status: 'error', errorMsg: err.message || '请求失败' }]
          }
          return prev
        })
        setStreaming(false)
        abortRef.current = null
        saveToStorage()
      },
    )

    // Add assistant placeholder
    setMessages((prev) => [
      ...prev,
      { id: Date.now() + 1, role: 'assistant', content: '', time: getTime(), status: 'streaming' },
    ])
  }, [canSend, inputText, activeConvId, selectedKnowledge, saveToStorage])

  const stopStream = () => {
    if (abortRef.current) {
      abortRef.current.abort()
      abortRef.current = null
      setStreaming(false)
      setMessages((prev) => {
        const last = prev[prev.length - 1]
        if (last?.role === 'assistant' && last.status === 'streaming') {
          return [...prev.slice(0, -1), { ...last, status: 'done' }]
        }
        return prev
      })
      saveToStorage()
    }
  }

  const newConversation = () => {
    setActiveConvId(null)
    setMessages([])
    setInputText('')
  }

  const loadConversation = (id: string) => {
    setActiveConvId(id)
    const all = JSON.parse(localStorage.getItem(LS_KEY) || '{}')
    setMessages(all[id]?.messages ?? [])
  }

  const clearConversation = () => {
    if (activeConvId) {
      const all = JSON.parse(localStorage.getItem(LS_KEY) || '{}')
      delete all[activeConvId]
      localStorage.setItem(LS_KEY, JSON.stringify(all))
    }
    setMessages([])
    setActiveConvId(null)
  }

  const copyMsg = async (content: string) => {
    try { await navigator.clipboard.writeText(content) } catch {}
  }

  const regenerate = () => {
    let i = messages.length - 1
    while (i >= 0 && messages[i].role !== 'user') i--
    if (i < 0) return
    const userMsg = messages[i]
    setMessages((prev) => prev.slice(0, i + 1))
    setInputText(userMsg.content.replace(/ \[附件: .*\]$/, ''))
    setTimeout(() => sendMessage(), 0)
  }

  const retry = () => {
    let i = messages.length - 1
    while (i >= 0 && messages[i].role !== 'assistant') i--
    if (i < 0) return
    setMessages((prev) => prev.slice(0, i - 1))
    const userMsg = messages[i - 1]
    if (userMsg?.role === 'user') {
      setInputText(userMsg.content.replace(/ \[附件: .*\]$/, ''))
      setTimeout(() => sendMessage(), 0)
    }
  }

  const quickAsk = (text: string) => {
    setInputText(text)
    setTimeout(() => sendMessage(), 0)
  }

  // Scroll on messages update
  useEffect(() => { scrollDown() }, [messages, scrollDown])

  return (
    <div className="flex h-[calc(100vh-64px)] bg-canvas">
      {/* 左侧双栏 */}
      <aside className="hidden w-[240px] flex-shrink-0 flex-col border-r border-hairline md:flex">
        {/* 知识库面板 */}
        <div className="flex-1 overflow-y-auto">
          <div className="border-b border-hairline px-4 py-3">
            <span className="text-xs font-semibold text-body-strong">知识库</span>
          </div>
          {knowledgeList.map((kb) => (
            <button
              key={kb.id}
              onClick={() => setSelectedKnowledge(kb.id)}
              className={cn(
                'w-full px-4 py-2.5 text-left transition-colors',
                selectedKnowledge === kb.id
                  ? 'bg-primary/10 border-r-2 border-primary'
                  : 'hover:bg-surface-soft',
              )}
            >
              <div className="text-sm font-medium text-body-strong">{kb.name}</div>
              {kb.description && (
                <div className="text-xs text-muted line-clamp-1">{kb.description}</div>
              )}
            </button>
          ))}
        </div>

        {/* 最近对话 */}
        <div className="flex-1 overflow-y-auto border-t border-hairline">
          <div className="flex items-center justify-between border-b border-hairline px-4 py-3">
            <span className="text-xs font-semibold text-body-strong">最近对话</span>
            <button onClick={newConversation} className="flex items-center gap-1 text-xs text-primary hover:text-primary-active">
              <Plus className="h-3 w-3" />新建
            </button>
          </div>
          {conversations.length === 0 ? (
            <p className="px-4 py-6 text-center text-xs text-muted-soft">暂无对话</p>
          ) : (
            conversations.map((conv) => (
              <button
                key={conv.id}
                onClick={() => loadConversation(conv.id)}
                className={cn(
                  'w-full px-4 py-2.5 text-left transition-colors hover:bg-surface-soft',
                  activeConvId === conv.id && 'bg-surface-soft',
                )}
              >
                <div className="text-sm text-body line-clamp-1">{conv.title || '新对话'}</div>
                <div className="text-xs text-muted-soft">{formatDateTime(conv.updateTime)}</div>
              </button>
            ))
          )}
        </div>
      </aside>

      {/* 主聊天区 */}
      <main className="flex flex-1 flex-col min-w-0">
        {/* 标题栏 */}
        <header className="flex items-center justify-between border-b border-hairline px-5 py-3">
          <div>
            {selectedKbName && <span className="text-xs text-primary">{selectedKbName}</span>}
            <h2 className="text-sm font-medium text-body-strong line-clamp-1">
              {isStreaming ? (messages.filter((m) => m.role === 'user').pop()?.content ?? '新对话') : (activeConvId ? conversations.find((c) => c.id === activeConvId)?.title || '新对话' : '新对话')}
            </h2>
          </div>
          {messages.length > 0 && (
            <button onClick={clearConversation} className="flex items-center gap-1 text-xs text-muted hover:text-error">
              <X className="h-3 w-3" />清空
            </button>
          )}
        </header>

        {/* 消息区 */}
        <div className="flex-1 overflow-y-auto px-5 py-4">
          {showStandby ? (
            <div className="flex h-full items-center justify-center">
              <div className="text-center">
                <h2 className="text-xl font-semibold text-body-strong">{standby.title}</h2>
                <p className="mt-2 text-sm text-muted">{standby.subtitle}</p>
                <div className="mt-6 flex flex-wrap justify-center gap-2">
                  {standby.suggestions.map((s, i) => (
                    <button
                      key={i}
                      onClick={() => quickAsk(s)}
                      className="rounded-full border border-hairline bg-surface-card px-3 py-1.5 text-xs text-body transition-colors hover:bg-surface-soft"
                    >
                      {s}
                    </button>
                  ))}
                </div>
              </div>
            </div>
          ) : (
            <div className="space-y-6">
              {messageTurns.map((turn, idx) => (
                <div key={turn.user.id}>
                  {/* User */}
                  <div className="mb-4 flex justify-end">
                    <div className="max-w-[80%] rounded-2xl rounded-br-md bg-primary/10 px-4 py-2.5">
                      <p className="text-sm text-body-strong whitespace-pre-wrap">{turn.user.content}</p>
                    </div>
                  </div>

                  {/* Assistant */}
                  {turn.assistant ? (
                    <div className="flex justify-start">
                      <div className="max-w-[85%]">
                        <div
                          className="prose-chat text-sm text-body leading-relaxed [&_a]:text-primary [&_pre]:bg-surface-soft [&_pre]:rounded-lg [&_pre]:p-3 [&_pre]:text-xs [&_code]:text-xs [&_p]:my-1 [&_ul]:my-1 [&_ol]:my-1"
                          dangerouslySetInnerHTML={{ __html: renderMD(turn.assistant.content) }}
                        />

                        {/* References */}
                        {turn.assistant.references && turn.assistant.references.length > 0 && (
                          <div className="mt-3 rounded-lg border border-hairline bg-surface-card p-3">
                            <div className="mb-2 text-xs font-medium text-body-strong">引用来源</div>
                            <div className="space-y-1">
                              {turn.assistant.references.map((ref: any, ri: number) => (
                                <a
                                  key={ri}
                                  href={ref.url || '#'}
                                  target="_blank"
                                  rel="noopener noreferrer"
                                  className="flex items-center gap-2 rounded p-1.5 text-xs text-body transition-colors hover:bg-surface-soft"
                                >
                                  <span>{ref.contentType === 'comment' ? '💬' : '📄'}</span>
                                  <div>
                                    <div className="font-medium">{ref.title || ref.documentName}</div>
                                    {(ref.author || ref.publishTime) && (
                                      <div className="text-muted-soft">
                                        {ref.author}{ref.author && ref.publishTime && ' · '}{ref.publishTime}
                                      </div>
                                    )}
                                  </div>
                                </a>
                              ))}
                            </div>
                          </div>
                        )}

                        {/* Toolbar */}
                        {turn.assistant.status === 'done' && (
                          <div className="mt-2 flex items-center gap-2 text-xs text-muted-soft">
                            <button onClick={() => copyMsg(turn.assistant!.content)} className="flex items-center gap-1 hover:text-primary">
                              <Copy className="h-3 w-3" />复制
                            </button>
                            {turn.assistant.id === lastAssistant?.id && (
                              <button onClick={regenerate} className="flex items-center gap-1 hover:text-primary">
                                <RefreshCw className="h-3 w-3" />重新生成
                              </button>
                            )}
                            <span>{turn.assistant.time}</span>
                          </div>
                        )}

                        {/* Error */}
                        {turn.assistant.id === lastAssistant?.id && turn.assistant.status === 'error' && (
                          <div className="mt-2 flex items-center gap-2 text-xs text-error">
                            <span>⚠️</span>
                            <span>{turn.assistant.errorMsg || '请求失败'}</span>
                            <button onClick={retry} className="text-primary hover:underline">重试</button>
                          </div>
                        )}
                      </div>
                    </div>
                  ) : isStreaming && idx === messageTurns.length - 1 ? (
                    <div className="flex items-center gap-3">
                      <div className="flex gap-1">
                        <span className="h-1.5 w-1.5 animate-bounce rounded-full bg-primary" style={{ animationDelay: '0ms' }} />
                        <span className="h-1.5 w-1.5 animate-bounce rounded-full bg-primary" style={{ animationDelay: '150ms' }} />
                        <span className="h-1.5 w-1.5 animate-bounce rounded-full bg-primary" style={{ animationDelay: '300ms' }} />
                      </div>
                      <button onClick={stopStream} className="flex items-center gap-1 rounded border border-hairline px-2 py-0.5 text-xs text-muted hover:bg-surface-soft">
                        <X className="h-3 w-3" />停止生成
                      </button>
                    </div>
                  ) : null}

                  {/* Streaming indicator for current turn */}
                  {isStreaming && idx === messageTurns.length - 1 && turn.assistant?.status === 'streaming' && (
                    <div className="mt-2 flex items-center gap-2">
                      <div className="flex gap-1">
                        <span className="h-1.5 w-1.5 animate-bounce rounded-full bg-primary" style={{ animationDelay: '0ms' }} />
                        <span className="h-1.5 w-1.5 animate-bounce rounded-full bg-primary" style={{ animationDelay: '150ms' }} />
                        <span className="h-1.5 w-1.5 animate-bounce rounded-full bg-primary" style={{ animationDelay: '300ms' }} />
                      </div>
                      <button onClick={stopStream} className="flex items-center gap-1 rounded border border-hairline px-2 py-0.5 text-xs text-muted hover:bg-surface-soft">
                        <X className="h-3 w-3" />停止生成
                      </button>
                    </div>
                  )}
                </div>
              ))}
              <div ref={messagesEndRef} />
            </div>
          )}
        </div>

        {/* 输入区 */}
        <div className={cn(
          'border-t border-hairline p-4 transition-colors',
          inputFocused && 'bg-surface-soft',
        )}>
          <div className="flex gap-3">
            <textarea
              ref={textareaRef}
              value={inputText}
              onChange={(e) => { setInputText(e.target.value); autoResize() }}
              onKeyDown={(e) => { if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); sendMessage() } }}
              onFocus={() => setInputFocused(true)}
              onBlur={() => setInputFocused(false)}
              placeholder="请输入你的问题..."
              rows={1}
              className="flex-1 resize-none rounded-lg border border-hairline bg-canvas px-4 py-2.5 text-sm text-body outline-none placeholder:text-muted-soft focus:border-primary"
            />
            <button
              onClick={isStreaming ? stopStream : sendMessage}
              disabled={!canSend && !isStreaming}
              className={cn(
                'flex h-10 w-10 flex-shrink-0 items-center justify-center rounded-lg transition-colors',
                isStreaming
                  ? 'bg-error text-white hover:bg-error/80'
                  : canSend
                    ? 'bg-primary text-primary-foreground hover:bg-primary-active'
                    : 'bg-primary-disabled text-muted cursor-not-allowed',
              )}
            >
              {isStreaming ? (
                <X className="h-4 w-4" />
              ) : (
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                  <line x1="22" y1="2" x2="11" y2="13" />
                  <polygon points="22 2 15 22 11 13 2 9 22 2" />
                </svg>
              )}
            </button>
          </div>
        </div>
      </main>
    </div>
  )
}
