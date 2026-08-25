import { useEffect, useMemo, useState } from 'react'
import { FileText, MessageCircle, Eye, Star } from 'lucide-react'
import { fetchContentStats, fetchAllContent } from '@/api/content'
import Heatmap from '@/components/Heatmap'

const CAT_LABELS: Record<string, string> = { article: '文章', game: '游戏', study: '学习', video: '视频' }

export default function Statistics() {
  const [stats, setStats] = useState<any>({})
  const [allContent, setAllContent] = useState<any[]>([])
  const [loading, setLoading] = useState(true)

  const loadData = async () => {
    setLoading(true)
    try {
      const [statsRes, contentRes]: any[] = await Promise.allSettled([
        fetchContentStats(),
        fetchAllContent(),
      ])
      if (statsRes.status === 'fulfilled') setStats(statsRes.value?.data ?? {})
      if (contentRes.status === 'fulfilled') setAllContent(contentRes.value?.data ?? [])
    } catch {}
    setLoading(false)
  }

  useEffect(() => {
    loadData()
    window.addEventListener('admin-refresh', loadData)
    return () => window.removeEventListener('admin-refresh', loadData)
  }, [])

  const totalViews = useMemo(() => allContent.reduce((s, c) => s + (c.viewCount ?? 0), 0), [allContent])
  const totalRecommend = useMemo(() => allContent.filter((c) => c.isRecommended || c.recommend).length, [allContent])

  // Category distribution
  const catDist = useMemo(() => {
    const map: Record<string, number> = {}
    allContent.forEach((c) => {
      const cat = c.category || c.contentType || 'article'
      map[cat] = (map[cat] || 0) + 1
    })
    return Object.entries(map).sort((a, b) => b[1] - a[1])
  }, [allContent])

  const total = catDist.reduce((s, [, n]) => s + n, 0)

  // Donut SVG
  const donutSegments = useMemo(() => {
    const circumference = 2 * Math.PI * 40
    let offset = circumference * 0.25 // start at top
    return catDist.map(([cat, count], i) => {
      const len = total > 0 ? (count / total) * circumference : 0
      const seg = { cat, count, len, offset, color: `var(--color-${i})` }
      offset -= len
      return seg
    })
  }, [catDist, total])

  const summaryCards = [
    { label: '内容总数', value: stats.contentCount ?? allContent.length ?? 0, icon: FileText, color: 'text-accent-teal' },
    { label: '评论总数', value: stats.commentCount ?? 0, icon: MessageCircle, color: 'text-accent-amber' },
    { label: '总浏览量', value: totalViews, icon: Eye, color: 'text-primary' },
    { label: '推荐内容', value: totalRecommend, icon: Star, color: 'text-muted' },
  ]

  return (
    <div className="p-6">
      <h1 className="mb-6 text-xl font-semibold text-body-strong">数据统计</h1>

      {loading ? (
        <div className="flex justify-center py-20"><div className="h-8 w-8 animate-spin rounded-full border-2 border-primary border-t-transparent" /></div>
      ) : (
        <>
          {/* 概览卡片 */}
          <div className="mb-8 grid grid-cols-2 gap-4 sm:grid-cols-4">
            {summaryCards.map(({ label, value, icon: Icon, color }) => (
              <div key={label} className="rounded-xl border border-hairline bg-surface-card p-5">
                <div className="flex items-center gap-3">
                  <div className={`rounded-lg bg-surface-soft p-2.5 ${color}`}>
                    <Icon className="h-5 w-5" />
                  </div>
                  <div>
                    <div className="text-2xl font-bold text-body-strong">{value}</div>
                    <div className="text-xs text-muted-soft">{label}</div>
                  </div>
                </div>
              </div>
            ))}
          </div>

          <div className="grid gap-6 lg:grid-cols-3">
            {/* 热力图 */}
            <div className="lg:col-span-2 rounded-xl border border-hairline bg-surface-card p-5">
              <h3 className="mb-2 text-sm font-semibold text-body-strong">内容活跃度</h3>
              <Heatmap />
            </div>

            {/* 分类分布 */}
            <div className="rounded-xl border border-hairline bg-surface-card p-5">
              <h3 className="mb-4 text-sm font-semibold text-body-strong">内容分类分布</h3>
              <div className="flex items-center justify-center">
                <svg width="200" height="200" viewBox="0 0 100 100">
                  {donutSegments.map((seg, i) => (
                    <circle
                      key={seg.cat}
                      cx="50" cy="50" r="40"
                      fill="none"
                      stroke={`var(--color-${i})`}
                      strokeWidth="16"
                      strokeDasharray={`${seg.len} ${2 * Math.PI * 40 - seg.len}`}
                      strokeDashoffset={seg.offset}
                      transform="rotate(-90 50 50)"
                      className="transition-all duration-500"
                    />
                  ))}
                  <circle cx="50" cy="50" r="30" fill="currentColor" className="text-surface-card" />
                  <text x="50" y="50" textAnchor="middle" dominantBaseline="central" className="fill-body-strong text-xs font-bold" fontSize="14">
                    {total}
                  </text>
                </svg>
              </div>
              <div className="mt-4 space-y-2">
                {catDist.map(([cat, count], i) => (
                  <div key={cat} className="flex items-center justify-between text-xs">
                    <div className="flex items-center gap-2">
                      <span className="h-2.5 w-2.5 rounded-full" style={{ backgroundColor: `var(--color-${i})` }} />
                      <span className="text-body">{CAT_LABELS[cat] || cat}</span>
                    </div>
                    <span className="text-muted-soft">{count}</span>
                  </div>
                ))}
              </div>
            </div>
          </div>

          <style>{`
            :root { --color-0: #5db8a6; --color-1: #e8a55a; --color-2: #cc785c; --color-3: #8e8b82; }
          `}</style>
        </>
      )}
    </div>
  )
}
