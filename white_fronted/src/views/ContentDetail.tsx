import { useEffect, useRef, useState, useCallback } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { Swiper, SwiperSlide } from 'swiper/react'
import { EffectFade, Navigation, Pagination } from 'swiper/modules'
import type { Swiper as SwiperType } from 'swiper'
import 'swiper/css'
import 'swiper/css/effect-fade'
import 'swiper/css/navigation'
import 'swiper/css/pagination'
import { marked } from 'marked'
import { X, ChevronLeft, ChevronRight } from 'lucide-react'
import Card16x9 from '@/components/Card16x9'
import CommentSection from '@/components/CommentSection'
import { fetchContentByCategory, fetchContentById } from '@/api/content'
import { fetchCommentList } from '@/api/comment'
import { transitionContent } from '@/utils/contentTransition'

function isDirectVideoUrl(url?: string): boolean {
  if (!url) return false
  return /\.(mp4|avi|mov|wmv|flv|webm)$/i.test(url.split('?')[0])
}

function convertToEmbedUrl(url?: string): string {
  if (!url) return ''
  if (url.includes('bilibili.com/video/')) {
    const m = url.match(/\/video\/(BV[\w]+)/)
    if (m) return `https://player.bilibili.com/player.html?bvid=${m[1]}&high_quality=1&danmaku=0&autoplay=0`
  }
  if (url.includes('youtube.com/watch')) {
    const id = new URL(url).searchParams.get('v')
    if (id) return `https://www.youtube.com/embed/${id}?autoplay=0`
  }
  if (url.includes('youtu.be/')) {
    const id = url.split('youtu.be/')[1]?.split('?')[0]
    if (id) return `https://www.youtube.com/embed/${id}?autoplay=0`
  }
  return url
}

function normalize(item: any) {
  if (!item) return null
  return {
    ...item,
    desc: item.description ?? item.desc ?? '',
    comments: item.commentCount ?? item.comments ?? 0,
    date: item.createTime ?? item.date ?? '',
  }
}

function normalizeComment(c: any): any {
  return { ...c, time: c.createTime ?? c.time ?? '', replies: (c.replies || []).map(normalizeComment) }
}

const renderMarkdown = (content?: string) =>
  content ? marked.parse(content, { breaks: true, gfm: true }) as string : ''

export default function ContentDetail() {
  const { type = 'article', id } = useParams<{ type: string; id: string }>()
  const navigate = useNavigate()

  const [swiperItems, setSwiperItems] = useState<any[]>([])
  const [initialSlide, setInitialSlide] = useState(0)
  const [currentItem, setCurrentItem] = useState<any>(null)
  const [comments, setComments] = useState<any[]>([])
  const [loaded, setLoaded] = useState(false)

  // Image preview
  const [previewVisible, setPreviewVisible] = useState(false)
  const [previewImages, setPreviewImages] = useState<string[]>([])
  const [previewIndex, setPreviewIndex] = useState(0)

  const swiperRef = useRef<SwiperType | null>(null)
  const articleRef = useRef<HTMLDivElement | null>(null)

  const loadComments = useCallback(async (contentId: string | number) => {
    try {
      const res: any = await fetchCommentList(contentId, type)
      setComments((res?.data ?? []).map(normalizeComment))
    } catch { setComments([]) }
  }, [type])

  // Initial data load
  useEffect(() => {
    if (!type || !id) return
    let cancelled = false

    ;(async () => {
      setLoaded(false)
      try {
        const listRes: any = await fetchContentByCategory(type)
        const items = (listRes?.data ?? []).map(normalize).filter(Boolean)
        if (cancelled) return
        setSwiperItems(items)

        const idx = items.findIndex((i: any) => String(i.id) === String(id))
        const startIdx = idx >= 0 ? idx : 0
        setInitialSlide(startIdx)

        // Get detail (triggers view count +1), fallback to list item
        let detail: any = null
        try {
          const detailRes: any = await fetchContentById(id)
          detail = normalize(detailRes?.data) ?? items[startIdx] ?? null
        } catch {
          detail = items[startIdx] ?? null
        }
        if (cancelled) return
        setCurrentItem(detail)
        if (detail?.id) await loadComments(detail.id)

        setLoaded(true)

        // Scroll to hash anchor
        const hash = window.location.hash
        if (hash) {
          setTimeout(() => {
            document.querySelector(hash)?.scrollIntoView({ behavior: 'smooth' })
          }, 300)
        }
      } catch {
        if (!cancelled) setLoaded(true)
      }
    })()

    return () => { cancelled = true }
  }, [type, id, loadComments])

  const onSlideChange = useCallback(async (swiper: SwiperType) => {
    // Pause all videos
    document.querySelectorAll<HTMLVideoElement>('.swiper-video-player').forEach((v) => v.pause())

    await transitionContent(async () => {
      const item = swiperItems[swiper.activeIndex]
      if (item) {
        setCurrentItem(item)
        await loadComments(item.id)
        // Update URL without reload
        navigate(`/content-detail/${type}/${item.id}`, { replace: true })
      }
    })
  }, [swiperItems, type, loadComments, navigate])

  // Extract all images from article body
  const extractImages = useCallback(() => {
    if (!articleRef.current) return []
    return Array.from(articleRef.current.querySelectorAll('img')).map((img) => img.src).filter(Boolean)
  }, [])

  const openPreview = useCallback((src: string) => {
    const imgs = extractImages()
    const idx = imgs.indexOf(src)
    setPreviewImages(idx >= 0 ? imgs : [src])
    setPreviewIndex(idx >= 0 ? idx : 0)
    setPreviewVisible(true)
  }, [extractImages])

  const handleContentClick = useCallback((e: React.MouseEvent) => {
    const target = e.target as HTMLElement
    const img = target.closest('img')
    if (img?.src) {
      e.preventDefault()
      openPreview(img.src)
      return
    }
    const link = target.closest('a')
    if (link) {
      const href = link.getAttribute('href')
      if (href && !href.startsWith('http') && !href.startsWith('//') && !href.startsWith('mailto:')) {
        e.preventDefault()
        navigate(href)
      }
    }
  }, [navigate, openPreview])

  return (
    <div className="flex gap-6 mx-auto min-h-screen bg-canvas px-4 py-20 sm:px-6">
      {/* 左侧：Swiper + 文章内容 */}
      <div className="flex-1 min-w-0">
        {loaded && swiperItems.length > 0 ? (
          <>
            <Swiper
              modules={[EffectFade, Navigation, Pagination]}
              slidesPerView={1}
              spaceBetween={16}
              initialSlide={initialSlide}
              effect="fade"
              speed={600}
              navigation
              pagination={{ clickable: true }}
              onSwiper={(s) => { swiperRef.current = s }}
              onSlideChange={onSlideChange}
              className="content-swiper rounded-xl overflow-hidden"
            >
              {swiperItems.map((item: any) => (
                <SwiperSlide key={item.id}>
                  {item.contentType === 'video' && item.videoUrl ? (
                    isDirectVideoUrl(item.videoUrl) ? (
                      <video
                        src={item.videoUrl}
                        controls
                        controlsList="nodownload"
                        playsInline
                        poster={item.cover}
                        className="swiper-video-player w-full aspect-video object-cover rounded-xl"
                      />
                    ) : (
                      <div className="aspect-video w-full rounded-xl bg-black overflow-hidden">
                        <iframe
                          src={convertToEmbedUrl(item.videoUrl)}
                          allowFullScreen
                          className="h-full w-full"
                        />
                      </div>
                    )
                  ) : (
                    <Card16x9 backgroundImage={item.cover}>
                      <div
                        className="flex h-full w-full items-center justify-center cursor-pointer"
                        onClick={() => item.cover && openPreview(item.cover)}
                      />
                    </Card16x9>
                  )}
                </SwiperSlide>
              ))}
            </Swiper>

            {/* 文章内容 */}
            {currentItem && (
              <div ref={articleRef} className="article-content mt-6">
                <div
                  className="markdown-body text-body leading-relaxed [&_a]:text-primary [&_img]:cursor-pointer [&_img]:rounded-lg"
                  dangerouslySetInnerHTML={{ __html: renderMarkdown(currentItem.content) }}
                  onClick={handleContentClick}
                />
              </div>
            )}
          </>
        ) : (
          <div className="flex justify-center py-20">
            <div className="h-8 w-8 animate-spin rounded-full border-2 border-primary border-t-transparent" />
          </div>
        )}
      </div>

      {/* 右侧：详情 + 评论 */}
      {currentItem && (
        <div className="detail-col hidden w-[320px] flex-shrink-0 lg:block">
          <div className="mb-4 rounded-xl border border-hairline bg-surface-card p-5">
            <div className="mb-3 flex items-center justify-between">
              <h3 className="text-base font-semibold text-body-strong line-clamp-2">{currentItem.title}</h3>
              {currentItem.category && (
                <span className="ml-2 flex-shrink-0 rounded-full bg-primary/10 px-2 py-0.5 text-xs text-primary">
                  {currentItem.category}
                </span>
              )}
            </div>
            {currentItem.desc && (
              <p className="text-sm text-muted leading-relaxed">{currentItem.desc}</p>
            )}
            <div className="mt-3 flex gap-4 text-xs text-muted-soft">
              {currentItem.date && <span>{currentItem.date}</span>}
              <span>{currentItem.comments ?? 0} 评论</span>
            </div>
          </div>
          <div className="rounded-xl border border-hairline bg-surface-card overflow-hidden">
            <CommentSection
              data={currentItem}
              comments={comments}
              contentType={type}
              onCommentAdded={() => currentItem.id && loadComments(currentItem.id)}
            />
          </div>
        </div>
      )}

      {/* 移动端评论（底部） */}
      {currentItem && (
        <div className="mt-6 lg:hidden rounded-xl border border-hairline bg-surface-card overflow-hidden">
          <CommentSection
            data={currentItem}
            comments={comments}
            contentType={type}
            onCommentAdded={() => currentItem.id && loadComments(currentItem.id)}
          />
        </div>
      )}

      {/* 图片预览模态框 */}
      {previewVisible && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-black/80"
          onClick={() => setPreviewVisible(false)}
        >
          <div className="relative max-h-[90vh] max-w-[90vw]" onClick={(e) => e.stopPropagation()}>
            <img
              src={previewImages[previewIndex]}
              alt="预览"
              className="max-h-[85vh] max-w-[90vw] rounded-lg object-contain"
            />
            <button
              onClick={() => setPreviewVisible(false)}
              className="absolute -top-3 -right-3 flex h-8 w-8 items-center justify-center rounded-full bg-surface-dark text-white hover:bg-surface-dark/80"
            >
              <X className="h-5 w-5" />
            </button>
            {previewImages.length > 1 && (
              <>
                <button
                  onClick={() => setPreviewIndex((i) => (i > 0 ? i - 1 : previewImages.length - 1))}
                  className="absolute left-2 top-1/2 -translate-y-1/2 flex h-10 w-10 items-center justify-center rounded-full bg-surface-dark/60 text-white hover:bg-surface-dark"
                >
                  <ChevronLeft className="h-6 w-6" />
                </button>
                <button
                  onClick={() => setPreviewIndex((i) => (i < previewImages.length - 1 ? i + 1 : 0))}
                  className="absolute right-2 top-1/2 -translate-y-1/2 flex h-10 w-10 items-center justify-center rounded-full bg-surface-dark/60 text-white hover:bg-surface-dark"
                >
                  <ChevronRight className="h-6 w-6" />
                </button>
                <div className="absolute bottom-3 left-1/2 -translate-x-1/2 rounded-full bg-surface-dark/60 px-3 py-1 text-xs text-white">
                  {previewIndex + 1} / {previewImages.length}
                </div>
              </>
            )}
          </div>
        </div>
      )}
    </div>
  )
}
