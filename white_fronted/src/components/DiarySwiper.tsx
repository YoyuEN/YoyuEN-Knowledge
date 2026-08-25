import { useState } from 'react'
import { Swiper, SwiperSlide } from 'swiper/react'
import type { Swiper as SwiperType } from 'swiper'
import 'swiper/css'

interface DiaryEntry {
  id?: string | number
  avatar?: string
  date?: string
  weather?: string
  mood?: string
  content?: string
}

interface DiarySwiperProps {
  diaryEntries?: DiaryEntry[]
}

function formatDate(date?: string): string {
  if (!date) return ''
  const str = String(date)
  const match = str.match(/^(\d{4})-(\d{2})-(\d{2})/)
  if (match) {
    const y = parseInt(match[1], 10)
    const m = parseInt(match[2], 10)
    const d = parseInt(match[3], 10)
    const weekdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六']
    const day = new Date(y, m - 1, d)
    if (isNaN(day.getTime())) return str
    return `${y}年${m}月${d}日 ${weekdays[day.getDay()]}`
  }
  const d = new Date(str.replace(/-/g, '/'))
  if (isNaN(d.getTime())) return str
  const weekdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六']
  return `${d.getFullYear()}年${d.getMonth() + 1}月${d.getDate()}日 ${weekdays[d.getDay()]}`
}

export default function DiarySwiper({ diaryEntries = [] }: DiarySwiperProps) {
  const [_, setSwiper] = useState<SwiperType | null>(null)

  const entries: DiaryEntry[] = diaryEntries.length % 2 !== 0
    ? [...diaryEntries, {}]
    : diaryEntries

  return (
    <div className="relative flex h-[820px] w-full justify-center rounded-xl border border-hairline bg-canvas p-2.5">
      <Swiper
        slidesPerView={2}
        spaceBetween={0}
        initialSlide={0}
        onSwiper={setSwiper}
        className="h-full w-full"
      >
        {entries.map((entry, index) => (
          <SwiperSlide key={index} className="flex items-center justify-center">
            <div className="flex h-full w-full flex-col rounded cursor-grab active:cursor-grabbing transition-all">
              <div className="flex h-full flex-1 flex-col p-7 relative">
                {entry.content ? (
                  <div className="flex h-full flex-1 flex-col">
                    <div className="mb-5 flex items-center gap-5 border-b border-hairline pb-4">
                      <img
                        src={entry.avatar}
                        alt="头像"
                        className="h-14 w-14 rounded-full object-cover"
                      />
                      <div>
                        <div className="flex items-center gap-3">
                          <span className="text-sm text-body-strong">{formatDate(entry.date)}</span>
                          {entry.weather && (
                            <span className="text-xs text-muted">{entry.weather}</span>
                          )}
                        </div>
                        {entry.mood && (
                          <div className="mt-1 text-sm text-muted">{entry.mood}</div>
                        )}
                      </div>
                    </div>
                    <div className="flex-1 whitespace-pre-wrap text-body leading-relaxed">
                      {entry.content}
                    </div>
                  </div>
                ) : (
                  <div className="flex h-full flex-col items-center justify-center text-muted-soft">
                    <svg className="h-16 w-16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1">
                      <path d="M9 12h6M9 16h6M17 21H7a2 2 0 01-2-2V5a2 2 0 012-2h6l5 5v14a2 2 0 01-2 2z" />
                    </svg>
                    <p className="mt-2 text-sm">这一页还没有日记</p>
                  </div>
                )}
                <div className="mt-auto text-right text-xs text-muted-soft">
                  {index + 1}
                </div>
              </div>
            </div>
          </SwiperSlide>
        ))}
      </Swiper>
    </div>
  )
}
