import { useEffect, useState } from 'react'
import { marked } from 'marked'
import { RefreshCw } from 'lucide-react'
import { fetchAssistantReport } from '@/api/dashboard'

const CACHE_KEY = 'dashboard_assistant_report'
const CACHE_TTL = 24 * 60 * 60 * 1000 // 24h

export default function Dashboard() {
  const [content, setContent] = useState('')
  const [loading, setLoading] = useState(true)

  const loadReport = async (force = false) => {
    // Check cache
    if (!force) {
      const cached = localStorage.getItem(CACHE_KEY)
      if (cached) {
        try {
          const { data, timestamp } = JSON.parse(cached)
          if (Date.now() - timestamp < CACHE_TTL) {
            setContent(data)
            setLoading(false)
            return
          }
        } catch {}
      }
    }

    setLoading(true)
    setContent('')

    try {
      const response = await fetchAssistantReport()
      if (!response.ok) { setLoading(false); return }
      const reader = response.body?.getReader()
      if (!reader) { setLoading(false); return }
      const decoder = new TextDecoder()
      let accumulated = ''

      while (true) {
        const { done, value } = await reader.read()
        if (done) break
        const text = decoder.decode(value, { stream: true })
        const lines = text.split('\n')
        for (const line of lines) {
          if (line.startsWith('data:')) {
            const payload = line.slice(5).trim()
            if (payload && payload !== '[DONE]') {
              try {
                const json = JSON.parse(payload)
                const chunk = json?.result?.output?.content ?? json?.content ?? json?.data ?? ''
                if (typeof chunk === 'string') {
                  accumulated += chunk
                  const fixed = accumulated.replace(/^(#{1,6})([^\s#])/gm, '$1 $2').replace(/^(-)([^\s-])/gm, '$1 $2')
                  setContent(fixed)
                }
              } catch { accumulated += payload }
            }
          }
        }
      }

      const final = accumulated.replace(/^(#{1,6})([^\s#])/gm, '$1 $2').replace(/^(-)([^\s-])/gm, '$1 $2')
      localStorage.setItem(CACHE_KEY, JSON.stringify({ data: final, timestamp: Date.now() }))
      setContent(final)
    } catch { /* ignore */ }
    setLoading(false)
  }

  useEffect(() => {
    loadReport()
    const handler = () => loadReport(true)
    window.addEventListener('admin-refresh', handler)
    return () => window.removeEventListener('admin-refresh', handler)
  }, [])

  return (
    <div className="p-6">
      <div className="mb-4 flex items-center justify-between">
        <h1 className="text-xl font-semibold text-body-strong">仪表盘</h1>
        <button
          onClick={() => loadReport(true)}
          className="flex items-center gap-1.5 rounded-lg border border-hairline px-3 py-1.5 text-xs text-muted transition-colors hover:bg-surface-soft"
        >
          <RefreshCw className={loading ? 'animate-spin h-3.5 w-3.5' : 'h-3.5 w-3.5'} />
          刷新
        </button>
      </div>

      <div className="rounded-xl border border-hairline bg-surface-card p-6 min-h-[400px]">
        {loading ? (
          <div className="flex items-center justify-center py-20">
            <div className="flex flex-col items-center gap-3">
              <div className="h-8 w-8 animate-spin rounded-full border-2 border-primary border-t-transparent" />
              <p className="text-sm text-muted">AI 助手正在生成报告...</p>
            </div>
          </div>
        ) : content ? (
          <div
            className="prose-dashboard text-body leading-relaxed [&_h1]:text-xl [&_h1]:font-bold [&_h2]:text-lg [&_h2]:font-semibold [&_h3]:text-base [&_h3]:font-semibold [&_a]:text-primary [&_pre]:bg-surface-soft [&_pre]:rounded-lg [&_pre]:p-4 [&_pre]:text-xs [&_code]:text-xs [&_p]:my-2 [&_ul]:my-2 [&_ol]:my-2 [&_li]:my-1 [&_table]:w-full [&_table]:border-collapse [&_th]:border [&_th]:border-hairline [&_th]:bg-surface-soft [&_th]:px-3 [&_th]:py-2 [&_td]:border [&_td]:border-hairline [&_td]:px-3 [&_td]:py-2"
            dangerouslySetInnerHTML={{ __html: marked.parse(content, { breaks: true, gfm: true }) as string }}
          />
        ) : (
          <div className="flex items-center justify-center py-20 text-muted-soft">
            <p>暂无数据，点击刷新获取报告</p>
          </div>
        )}
      </div>
    </div>
  )
}
