import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { ArrowRight, BookOpen, MessageCircle, PenLine, Clock } from 'lucide-react'
import { fetchRecommendContent, fetchContentByCategory, fetchContentCategories } from '@/api/content'
import { fetchLatestMurmur } from '@/api/murmur'
import { fetchDiaryList } from '@/api/diary'
import { cn } from '@/lib/utils'
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

interface MurmurItem {
  id: string | number
  text: string
  date?: string
}

interface CategoryGroup {
  type: string
  title: string
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

function relativeTime(dateStr?: string): string {
  if (!dateStr) return ''
  const now = Date.now()
  const t = new Date(dateStr.replace(/-/g, '/')).getTime()
  if (isNaN(t)) return ''
  const diff = now - t
  const mins = Math.floor(diff / 60000)
  if (mins < 1) return '刚刚'
  if (mins < 60) return `${mins} 分钟前`
  const hrs = Math.floor(mins / 60)
  if (hrs < 24) return `${hrs} 小时前`
  const days = Math.floor(hrs / 24)
  if (days < 30) return `${days} 天前`
  return formatDate(dateStr)
}

export default function Home() {
  const [latestMurmur, setLatestMurmur] = useState<MurmurItem | null>(null)
  const [recommendList, setRecommendList] = useState<ContentItem[]>([])
  const [categories, setCategories] = useState<CategoryGroup[]>([])
  const [latestDiary, setLatestDiary] = useState<any>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    Promise.allSettled([
      fetchLatestMurmur(1).then((res: any) => {
        const data = res?.data
        if (Array.isArray(data) && data.length > 0) {
          setLatestMurmur({ id: data[0].id, text: data[0].content ?? data[0].text ?? '', date: data[0].createTime })
        }
      }),
      fetchRecommendContent().then((res: any) => {
        setRecommendList((res?.data ?? []).map(normalize).slice(0, 6))
      }),
      fetchDiaryList('diary').then((res: any) => {
        const data = res?.data ?? []
        if (data.length > 0) setLatestDiary(data[0])
      }),
      fetchContentCategories().then(async (res: any) => {
        const cats = res?.data?.length > 0 ? res.data : [
          { type: 'article', name: '文章' },
          { type: 'game', name: '游戏' },
          { type: 'study', name: '学习' },
          { type: 'video', name: '视频' },
        ]
        const results = await Promise.allSettled(cats.map((c: any) => fetchContentByCategory(c.type)))
        setCategories(
          cats
            .map((cat: any, i: number) => ({
              type: cat.type,
              title: cat.name || cat.type,
              list: results[i].status === 'fulfilled'
                ? ((results[i] as any).value?.data ?? []).map(normalize).slice(0, 4)
                : [],
            }))
            .filter((c: CategoryGroup) => c.list.length > 0),
        )
      }),
    ]).finally(() => setLoading(false))
  }, [])

  return (
    <div className="min-h-screen bg-canvas">
      {/* HERO 区域 */}
      <section className="relative flex flex-col items-center justify-center px-4 pb-16 pt-28 text-center sm:px-6 sm:pt-36">
        <img
          src={defaultAvatar}
          alt="YoyuEN"
          className="h-20 w-20 rounded-full object-cover ring-4 ring-hairline-soft"
        />
        <h1 className="mt-6 font-brand text-3xl tracking-wide text-body-strong sm:text-4xl">
          悠远知识库
        </h1>
        <p className="mt-3 max-w-lg text-sm leading-relaxed text-muted sm:text-base">
          个人知识管理与分享空间，记录学习、技术与生活的每一个瞬间
        </p>

        {/* Now 状态条 */}
        {latestMurmur && (
          <div className="mt-6 inline-flex items-center gap-2 rounded-full border border-hairline bg-surface-soft px-4 py-2 text-xs text-muted">
            <Clock className="h-3.5 w-3.5 text-primary" />
            <span>现在 · </span>
            <span className="text-body">{latestMurmur.text}</span>
            {latestMurmur.date && (
              <span className="text-muted-soft">({relativeTime(latestMurmur.date)})</span>
            )}
          </div>
        )}

        {/* CTA 按钮 */}
        <div className="mt-8 flex gap-3">
          <Link
            to="/content"
            className="inline-flex items-center gap-1.5 rounded-lg bg-primary px-5 py-2.5 text-sm font-medium text-primary-foreground transition-colors hover:bg-primary-active"
          >
            <BookOpen className="h-4 w-4" />
            进入内容
            <ArrowRight className="h-4 w-4" />
          </Link>
          <Link
            to="/chat"
            className="inline-flex items-center gap-1.5 rounded-lg border border-hairline bg-surface-card px-5 py-2.5 text-sm font-medium text-body transition-colors hover:bg-surface-soft"
          >
            <MessageCircle className="h-4 w-4" />
            开始对话
          </Link>
        </div>
      </section>

      <div className="mx-auto max-w-6xl px-4 pb-20 sm:px-6">
        {/* 推荐内容 */}
        {recommendList.length > 0 && (
          <section className="mb-12">
            <h2 className="mb-5 text-lg font-semibold text-body-strong">推荐内容</h2>
            <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
              {recommendList.map((item) => (
                <Link
                  key={item.id}
                  to={`/content-detail/${item.contentType || item.category || 'article'}/${item.id}`}
                  className="group overflow-hidden rounded-xl border border-hairline bg-surface-card transition-shadow hover:shadow-md"
                >
                  <div className="relative aspect-video overflow-hidden bg-surface-soft">
                    {item.cover ? (
                      <img src={item.cover} alt={item.title} className="h-full w-full object-cover transition-transform group-hover:scale-105" />
                    ) : (
                      <div className="flex h-full items-center justify-center text-muted-soft">
                        <BookOpen className="h-8 w-8" />
                      </div>
                    )}
                    {item.category && (
                      <span className="absolute left-2 top-2 rounded-full bg-surface-dark/60 px-2 py-0.5 text-xs text-white">
                        {item.category}
                      </span>
                    )}
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

        {/* 最新日记 */}
        {latestDiary && (
          <section className="mb-12 rounded-xl border border-hairline bg-surface-card p-5">
            <div className="flex items-center gap-2">
              <PenLine className="h-5 w-5 text-primary" />
              <h2 className="text-lg font-semibold text-body-strong">最新日记</h2>
              <span className="text-xs text-muted-soft">
                {formatDate(latestDiary.diaryDate || latestDiary.createTime)}
                {latestDiary.mood && ` · ${latestDiary.mood}`}
                {latestDiary.weather && ` · ${latestDiary.weather}`}
              </span>
            </div>
            <p className="mt-3 text-sm leading-relaxed text-body line-clamp-4">
              {latestDiary.content}
            </p>
            <Link
              to="/diary"
              className="mt-3 inline-flex items-center gap-1 text-xs text-primary hover:text-primary-active"
            >
              查看全部日记 <ArrowRight className="h-3 w-3" />
            </Link>
          </section>
        )}

        {/* 各分类内容 */}
        {categories.map((cat) => (
          <section key={cat.type} className="mb-12">
            <div className="mb-5 flex items-baseline justify-between border-b border-hairline pb-3">
              <h2 className="text-lg font-semibold text-body-strong">{cat.title}</h2>
              <Link
                to={`/content`}
                className="text-xs text-muted transition-colors hover:text-primary"
              >
                查看更多 →
              </Link>
            </div>
            <div className="grid gap-4 sm:grid-cols-2">
              {cat.list.map((item) => (
                <Link
                  key={item.id}
                  to={`/content-detail/${cat.type}/${item.id}`}
                  className="group flex gap-4 rounded-lg p-3 transition-colors hover:bg-surface-soft"
                >
                  <div className={cn(
                    'h-20 w-28 flex-shrink-0 overflow-hidden rounded-lg bg-surface-soft',
                    cat.type === 'video' && 'relative',
                  )}>
                    {item.cover ? (
                      <img src={item.cover} alt={item.title} className="h-full w-full object-cover" />
                    ) : (
                      <div className="flex h-full items-center justify-center text-muted-soft">
                        <BookOpen className="h-6 w-6" />
                      </div>
                    )}
                  </div>
                  <div className="flex min-w-0 flex-1 flex-col">
                    <h3 className="text-sm font-medium text-body-strong line-clamp-1">{item.title}</h3>
                    <p className="mt-1 text-xs text-muted line-clamp-2">{item.desc}</p>
                    <div className="mt-auto flex items-center gap-3 text-xs text-muted-soft">
                      {item.date && <span>{formatDate(item.date)}</span>}
                      <span>{item.comments ?? 0} 评论</span>
                    </div>
                  </div>
                </Link>
              ))}
            </div>
          </section>
        ))}

        {loading && (
          <div className="flex justify-center py-20">
            <div className="h-8 w-8 animate-spin rounded-full border-2 border-primary border-t-transparent" />
          </div>
        )}
      </div>
    </div>
  )
}
