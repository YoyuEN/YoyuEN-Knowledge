import { useEffect, useRef, useState } from 'react'
import { Link } from 'react-router-dom'
import { BookOpen, MessageCircle } from 'lucide-react'
import { fetchRecommendContent, fetchContentByCategory, fetchContentCategories, fetchContentStats } from '@/api/content'
import { fetchLatestMurmur } from '@/api/murmur'
import { initFadeIn } from '@/utils/fadeIn'
import defaultAvatar from '@/assets/picture/YoyuEN.png'

interface ContentItem {
  id: string | number
  title: string
  desc: string
  cover?: string
  date?: string
  comments?: number
  category?: string
  contentType?: string
}

interface CategoryGroup {
  type: string
  title: string
  count: number
  list: ContentItem[]
}

function normalize(item: any): ContentItem {
  return {
    ...item,
    desc: item.description ?? item.desc ?? '',
    comments: item.commentCount ?? item.comments ?? 0,
    date: item.createTime ?? item.date ?? '',
    category: item.categoryName ?? item.category ?? '',
  }
}

function formatDate(dateStr?: string): string {
  if (!dateStr) return ''
  const d = new Date(dateStr.replace(/-/g, '/'))
  if (isNaN(d.getTime())) return dateStr.slice(0, 10)
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
}

export default function Content() {
  const [recommendList, setRecommendList] = useState<ContentItem[]>([])
  const [categories, setCategories] = useState<CategoryGroup[]>([])
  const [murmurs, setMurmurs] = useState<any[]>([])
  const [stats, setStats] = useState({ contentCount: 0, commentCount: 0 })
  const mountedRef = useRef(false)

  useEffect(() => {
    if (mountedRef.current) return
    mountedRef.current = true

    Promise.allSettled([
      fetchContentCategories(),
      fetchRecommendContent(),
      fetchLatestMurmur(5),
      fetchContentStats(),
    ]).then(async ([catRes, recRes, murRes, statsRes]) => {
      if (recRes.status === 'fulfilled') {
        setRecommendList(((recRes.value as any)?.data ?? []).map(normalize))
      }
      if (murRes.status === 'fulfilled') {
        setMurmurs(((murRes.value as any)?.data ?? []).map((m: any) => ({
          id: m.id,
          text: m.content ?? m.text ?? '',
          date: formatDate(m.createTime ?? m.date),
        })))
      }
      if (statsRes.status === 'fulfilled' && (statsRes.value as any)?.data) {
        setStats((statsRes.value as any).data)
      }

      const fallback = [
        { type: 'article', name: '文章', count: 0 },
        { type: 'game', name: '游戏', count: 0 },
        { type: 'study', name: '学习', count: 0 },
        { type: 'video', name: '视频', count: 0 },
      ]
      const cats = (catRes.status === 'fulfilled' && (catRes.value as any)?.data?.length > 0)
        ? (catRes.value as any).data
        : fallback
      const results = await Promise.allSettled(cats.map((c: any) => fetchContentByCategory(c.type)))
      setCategories(
        cats
          .map((cat: any, i: number) => ({
            type: cat.type,
            title: cat.name || cat.type,
            count: cat.count ?? 0,
            list: results[i].status === 'fulfilled'
              ? ((results[i] as any).value?.data ?? []).map(normalize).slice(0, 5)
              : [],
          }))
          .filter((c: CategoryGroup) => c.list.length > 0),
      )

      setTimeout(() => initFadeIn(), 150)
    })
  }, [])

  return (
    <div className="flex gap-6 mx-auto min-h-[calc(100vh-90px)] bg-canvas px-4 py-8 sm:px-6">
      {/* 主内容区 */}
      <div className="flex-1 min-w-0 rounded-xl border border-hairline p-5">
        {/* 推荐内容 */}
        {recommendList.length > 0 && (
          <section className="mb-10">
            <div className="mb-5 flex items-baseline justify-between border-b border-hairline pb-3">
              <h2 className="text-lg font-semibold text-body-strong">推荐内容</h2>
            </div>
            <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
              {recommendList.map((item) => (
                <Link
                  key={item.id}
                  to={`/content-detail/${item.contentType || item.category || 'article'}/${item.id}`}
                  className="group card-hover overflow-hidden rounded-xl border border-hairline bg-surface-card transition-shadow hover:shadow-md"
                >
                  <div className="relative aspect-video overflow-hidden bg-surface-soft">
                    {item.cover ? (
                      <img src={item.cover} alt={item.title} className="h-full w-full object-cover transition-transform group-hover:scale-105" />
                    ) : (
                      <div className="flex h-full items-center justify-center"><BookOpen className="h-8 w-8 text-muted-soft" /></div>
                    )}
                    <span className="absolute left-2 top-2 rounded-full bg-surface-dark/60 px-2 py-0.5 text-xs text-white">
                      {item.category || item.contentType}
                    </span>
                    <span className="absolute right-2 top-2 flex items-center gap-1 rounded-full bg-surface-dark/60 px-2 py-0.5 text-xs text-white">
                      <MessageCircle className="h-3 w-3" />{item.comments ?? 0}
                    </span>
                  </div>
                  <div className="p-4">
                    <h3 className="text-sm font-medium text-body-strong line-clamp-1">{item.title}</h3>
                    <p className="mt-1 text-xs text-muted line-clamp-2">{item.desc}</p>
                    <div className="mt-2 flex items-center gap-3 text-xs text-muted-soft">
                      {item.date && <span>{formatDate(item.date)}</span>}
                      <span>{item.comments ?? 0} 评论</span>
                    </div>
                  </div>
                </Link>
              ))}
            </div>
          </section>
        )}

        {/* 分类内容 */}
        {categories.map((cat) => (
          <section key={cat.type} className="mb-10 fade-in">
            <div className="mb-5 flex items-baseline justify-between border-b border-hairline pb-3">
              <h2 className="text-lg font-semibold text-body-strong">{cat.title}</h2>
              <span className="text-xs text-muted-soft">{cat.count} 篇</span>
            </div>
            <div className="space-y-4">
              {cat.list.map((item) => (
                <Link
                  key={item.id}
                  to={`/content-detail/${cat.type}/${item.id}`}
                  className="flex gap-4 rounded-lg p-2 transition-colors hover:bg-surface-soft"
                >
                  <div className="relative h-[72px] w-[120px] flex-shrink-0 overflow-hidden rounded-lg bg-surface-soft">
                    {item.cover ? (
                      <img src={item.cover} alt={item.title} className="h-full w-full object-cover" />
                    ) : (
                      <div className="flex h-full items-center justify-center"><BookOpen className="h-6 w-6 text-muted-soft" /></div>
                    )}
                    {cat.type === 'video' && (
                      <span className="absolute inset-0 flex items-center justify-center bg-black/30 text-white">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><polygon points="5 3 19 12 5 21 5 3" /></svg>
                      </span>
                    )}
                  </div>
                  <div className="flex min-w-0 flex-1 flex-col justify-center">
                    <h3 className="text-sm font-medium text-body-strong line-clamp-1">{item.title}</h3>
                    <p className="mt-1 text-xs text-muted line-clamp-2">{item.desc}</p>
                    <div className="mt-1 flex items-center gap-3 text-xs text-muted-soft">
                      {item.date && <span>{formatDate(item.date)}</span>}
                      <span className="flex items-center gap-0.5">
                        <MessageCircle className="h-3 w-3" />{item.comments ?? 0}
                      </span>
                    </div>
                  </div>
                </Link>
              ))}
            </div>
          </section>
        ))}
      </div>

      {/* 右侧边栏 */}
      <aside className="hidden w-[260px] flex-shrink-0 lg:block">
        {/* 个人信息卡 */}
        <div className="fade-in mb-4 rounded-xl border border-hairline bg-surface-card p-5 text-center">
          <img src={defaultAvatar} alt="YoyuEN" className="mx-auto h-16 w-16 rounded-full object-cover" />
          <div className="mt-3 font-semibold text-body-strong">YoyuEN</div>
          <div className="mt-1 text-xs text-muted">宁鸣而死，不默而生</div>
          <p className="mt-2 text-xs leading-relaxed text-muted">
            北方民族大学 · 软件工程<br />
            热爱技术、游戏与生活
          </p>
          <div className="mt-3 flex justify-center gap-6 border-t border-hairline pt-3">
            <div className="text-center">
              <div className="text-sm font-semibold text-body-strong">{stats.contentCount}</div>
              <div className="text-xs text-muted-soft">文章</div>
            </div>
            <div className="w-px bg-hairline" />
            <div className="text-center">
              <div className="text-sm font-semibold text-body-strong">{stats.commentCount}</div>
              <div className="text-xs text-muted-soft">评论</div>
            </div>
          </div>
        </div>

        {/* 每日碎碎念 */}
        {murmurs.length > 0 && (
          <div className="fade-in rounded-xl border border-hairline bg-surface-card p-5">
            <h3 className="mb-3 text-sm font-semibold text-body-strong">每日碎碎念</h3>
            <div className="space-y-3">
              {murmurs.map((m: any) => (
                <div key={m.id} className="border-b border-hairline-soft pb-2 last:border-0 last:pb-0">
                  <p className="text-xs text-body leading-relaxed">{m.text}</p>
                  <span className="text-xs text-muted-soft">{m.date}</span>
                </div>
              ))}
            </div>
          </div>
        )}
      </aside>
    </div>
  )
}
