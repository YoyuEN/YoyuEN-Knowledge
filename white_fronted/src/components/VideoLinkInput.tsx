import { useCallback, useEffect, useMemo, useState } from 'react'
import { Link, Video } from 'lucide-react'

interface VideoLinkInputProps {
  value?: string
  onChange?: (url: string) => void
  onLinkChange?: (info: {
    url: string
    type: string
    embedUrl: string
    isValid: boolean
  }) => void
}

interface ParseResult {
  type: string
  embedUrl: string
  isValid: boolean
}

function parseVideoLink(url: string): ParseResult {
  if (!url) return { type: '', embedUrl: '', isValid: false }

  // B站
  if (url.includes('bilibili.com')) {
    const bvMatch = url.match(/BV[\w]+/)
    const avMatch = url.match(/av(\d+)/)
    if (bvMatch) {
      return {
        type: 'B站',
        embedUrl: `//player.bilibili.com/player.html?bvid=${bvMatch[0]}&high_quality=1`,
        isValid: true,
      }
    }
    if (avMatch) {
      return {
        type: 'B站',
        embedUrl: `//player.bilibili.com/player.html?aid=${avMatch[1]}&high_quality=1`,
        isValid: true,
      }
    }
  }

  // YouTube
  if (url.includes('youtube.com') || url.includes('youtu.be')) {
    let videoId = ''
    if (url.includes('youtube.com/watch')) {
      const m = url.match(/[?&]v=([^&]+)/)
      videoId = m ? m[1] : ''
    } else if (url.includes('youtu.be/')) {
      const m = url.match(/youtu\.be\/([^?]+)/)
      videoId = m ? m[1] : ''
    }
    if (videoId) {
      return { type: 'YouTube', embedUrl: `https://www.youtube.com/embed/${videoId}`, isValid: true }
    }
  }

  // 腾讯视频
  if (url.includes('v.qq.com')) {
    const m = url.match(/\/([a-z0-9]+)\.html/)
    if (m) {
      return { type: '腾讯视频', embedUrl: `https://v.qq.com/txp/iframe/player.html?vid=${m[1]}`, isValid: true }
    }
  }

  // 优酷
  if (url.includes('youku.com')) {
    const m = url.match(/id_([^=]+)/)
    if (m) {
      return { type: '优酷', embedUrl: `https://player.youku.com/embed/${m[1]}`, isValid: true }
    }
  }

  // 直链
  if (url.match(/\.(mp4|avi|mov|wmv|flv|webm)$/i)) {
    return { type: '直链', embedUrl: '', isValid: true }
  }

  return { type: '其他', embedUrl: '', isValid: true }
}

export default function VideoLinkInput({
  value = '',
  onChange,
  onLinkChange,
}: VideoLinkInputProps) {
  const [linkUrl, setLinkUrl] = useState(value)
  const parsed = useMemo(() => parseVideoLink(linkUrl), [linkUrl])

  useEffect(() => {
    setLinkUrl(value)
  }, [value])

  const handleChange = useCallback(
    (newUrl: string) => {
      setLinkUrl(newUrl)
      onChange?.(newUrl)
    },
    [onChange],
  )

  const handleBlur = useCallback(() => {
    onLinkChange?.({
      url: linkUrl,
      type: parsed.type,
      embedUrl: parsed.embedUrl,
      isValid: parsed.isValid,
    })
  }, [linkUrl, parsed, onLinkChange])

  return (
    <div className="w-full">
      <div className="flex items-center rounded-lg border border-hairline bg-canvas overflow-hidden">
        <span className="flex items-center justify-center px-3 text-muted-soft">
          <Link className="h-4 w-4" />
        </span>
        <input
          value={linkUrl}
          onChange={(e) => handleChange(e.target.value)}
          onBlur={handleBlur}
          placeholder="请输入视频链接（支持 B站、YouTube、腾讯视频等）"
          className="flex-1 bg-transparent py-2.5 pr-3 text-sm text-body outline-none placeholder:text-muted-soft"
        />
        {linkUrl && (
          <button
            type="button"
            onClick={() => handleChange('')}
            className="px-3 text-muted-soft hover:text-body"
          >
            ×
          </button>
        )}
      </div>

      {linkUrl && (
        <div className="mt-4 rounded-lg border border-hairline bg-surface-card p-4">
          <div className="mb-3 flex items-center justify-between border-b border-hairline pb-3">
            <span className="text-sm font-semibold text-body-strong">视频预览</span>
            {parsed.type && (
              <span className="rounded-full bg-accent-teal/15 px-2 py-0.5 text-xs font-medium text-accent-teal">
                {parsed.type}
              </span>
            )}
          </div>

          {parsed.embedUrl ? (
            <div className="relative mb-3 w-full overflow-hidden rounded-lg bg-black pb-[56.25%]">
              <iframe
                src={parsed.embedUrl}
                allowFullScreen
                className="absolute inset-0 h-full w-full"
              />
            </div>
          ) : (
            <div className="mb-3 flex items-center gap-3 rounded-lg bg-surface-soft px-5 py-8">
              <Video className="h-8 w-8 text-muted-soft flex-shrink-0" />
              <span className="text-sm text-body break-all leading-relaxed">{linkUrl}</span>
            </div>
          )}

          <div className="mt-3 rounded-md border px-3 py-2 text-xs leading-relaxed">
            {parsed.isValid ? (
              <span className="text-success">链接已识别，保存后将在前台展示</span>
            ) : (
              <span className="text-warning">链接格式可能不正确</span>
            )}
          </div>
        </div>
      )}
    </div>
  )
}
