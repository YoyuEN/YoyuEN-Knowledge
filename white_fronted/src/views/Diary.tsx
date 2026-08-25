import { useEffect, useState } from 'react'
import DiarySwiper from '@/components/DiarySwiper'
import { fetchDiaryList } from '@/api/diary'
import defaultAvatar from '@/assets/picture/YoyuEN.png'

export default function Diary() {
  const [entries, setEntries] = useState<any[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchDiaryList('diary')
      .then((res: any) => {
        const data = res?.data ?? []
        setEntries(data.map((item: any) => ({
          date: item.diaryDate ?? '',
          weather: item.weather ?? '',
          mood: item.mood ?? '',
          avatar: item.avatar || defaultAvatar,
          content: item.content ?? '',
        })))
      })
      .catch(() => {})
      .finally(() => setLoading(false))
  }, [])

  return (
    <div className="flex min-h-screen flex-col items-center justify-center gap-6 bg-canvas px-4 py-24 sm:px-6">
      {loading ? (
        <div className="flex flex-col items-center gap-3">
          <div className="h-8 w-8 animate-spin rounded-full border-2 border-primary border-t-transparent" />
          <p className="text-sm text-muted">加载中...</p>
        </div>
      ) : (
        <DiarySwiper diaryEntries={entries} />
      )}
    </div>
  )
}
