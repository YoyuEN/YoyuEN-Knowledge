import { useEffect, useRef, useState } from 'react'
import { fetchPhotoList } from '@/api/photo'
import { fetchProfileDetail } from '@/api/profile'
import defaultAvatar from '@/assets/picture/YoyuEN.png'

const ROW_HEIGHT = 200

interface Photo {
  id: string | number
  url: string
  description?: string
  displayWidth?: string
}

export default function Profile() {
  const [profile, setProfile] = useState({
    nickname: 'YoyuEN',
    avatar: defaultAvatar,
    signature: '宁鸣而死，不默而生！',
    welcomeText: '欢迎来到我的知识空间！这里记录着我的学习历程、技术探索和生活感悟。希望我的分享能给你带来一些启发和帮助。',
    school: '北方民族大学 · 软件工程',
    email: '15839393171@163.com',
    location: '北京 · 昌平',
  })
  const [techStack, setTechStack] = useState([
    'Vue.js', 'React', 'TypeScript', 'Node.js', 'Python', 'Java', 'MySQL', 'Git',
  ])
  const [tags, setTags] = useState([
    '玄不救非,氪不改命', '男神', '手工', '天然呆', '篮球', 'Running', 'Gym',
  ])
  const [photos, setPhotos] = useState<Photo[]>([])

  useEffect(() => {
    fetchPhotoList()
      .then((res: any) => setPhotos(res?.data ?? []))
      .catch(() => {})

    fetchProfileDetail()
      .then((res: any) => {
        const data = res?.data
        if (data) {
          setProfile((prev) => ({
            nickname: data.nickname || prev.nickname,
            avatar: data.avatar || prev.avatar,
            signature: data.signature || prev.signature,
            welcomeText: data.welcomeText || prev.welcomeText,
            school: data.school || prev.school,
            email: data.email || prev.email,
            location: data.location || prev.location,
          }))
          if (data.techStack) {
            try {
              const parsed = JSON.parse(data.techStack)
              if (Array.isArray(parsed) && parsed.length > 0) setTechStack(parsed)
            } catch {}
          }
          if (data.tags) {
            try {
              const parsed = JSON.parse(data.tags)
              if (Array.isArray(parsed) && parsed.length > 0) setTags(parsed)
            } catch {}
          }
        }
      })
      .catch(() => {})
  }, [])

  return (
    <div className="min-h-screen bg-canvas px-6 py-24 sm:px-12">
      <div className="mx-auto max-w-5xl">
        {/* 个人信息头部 */}
        <div className="flex flex-col items-center gap-6 pb-10">
          <div className="relative">
            <img
              src={profile.avatar}
              alt={profile.nickname}
              className="h-24 w-24 rounded-full object-cover ring-4 ring-hairline-soft"
            />
          </div>
          <div className="text-center">
            <h1 className="text-2xl font-semibold text-body-strong">{profile.nickname}</h1>
            <p className="mt-1 text-sm text-muted">{profile.signature}</p>
          </div>
          <p className="max-w-xl text-center text-sm leading-relaxed text-body">
            {profile.welcomeText}
          </p>
        </div>

        {/* 详情卡片网格 */}
        <div className="grid gap-4 sm:grid-cols-3">
          <div className="rounded-xl border border-hairline bg-surface-card p-5">
            <h4 className="mb-3 text-sm font-semibold text-body-strong">个人信息</h4>
            <div className="space-y-2 text-sm text-body">
              <p>{profile.school}</p>
              <p>{profile.email}</p>
              <p>{profile.location}</p>
            </div>
          </div>
          <div className="rounded-xl border border-hairline bg-surface-card p-5">
            <h4 className="mb-3 text-sm font-semibold text-body-strong">技术栈</h4>
            <div className="flex flex-wrap gap-1.5">
              {techStack.map((t) => (
                <span key={t} className="rounded-full bg-surface-soft px-2.5 py-1 text-xs text-body">
                  {t}
                </span>
              ))}
            </div>
          </div>
          <div className="rounded-xl border border-hairline bg-surface-card p-5">
            <h4 className="mb-3 text-sm font-semibold text-body-strong">个人标签</h4>
            <div className="flex flex-wrap gap-1.5">
              {tags.map((t) => (
                <span key={t} className="rounded-full bg-surface-soft px-2.5 py-1 text-xs text-body">
                  {t}
                </span>
              ))}
            </div>
          </div>
        </div>

        {/* 照片墙 */}
        {photos.length > 0 && (
          <div className="mt-10">
            <h3 className="mb-4 text-lg font-semibold text-body-strong">照片墙</h3>
            <div className="flex flex-wrap gap-2">
              {photos.map((photo, i) => (
                <PhotoItem key={photo.id ?? i} photo={photo} index={i} />
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  )
}

function PhotoItem({ photo, index }: { photo: Photo; index: number }) {
  const [displayWidth, setDisplayWidth] = useState<string | undefined>(photo.displayWidth)
  const ref = useRef<HTMLImageElement | null>(null)

  const handleLoad = () => {
    const img = ref.current
    if (img && !displayWidth) {
      const ratio = img.naturalWidth / (img.naturalHeight || 1)
      setDisplayWidth(`${ROW_HEIGHT * ratio}px`)
    }
  }

  return (
    <div
      className="overflow-hidden rounded-lg opacity-0 animate-[fadeIn_0.5s_ease-out_forwards]"
      style={{ animationDelay: `${index * 0.1}s`, width: displayWidth || 'auto', height: ROW_HEIGHT }}
    >
      <img
        ref={ref}
        src={photo.url}
        alt={photo.description || '照片'}
        className="h-full w-full object-cover"
        onLoad={handleLoad}
      />
    </div>
  )
}
