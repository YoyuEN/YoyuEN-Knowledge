import { useCallback, useMemo, useRef, useState } from 'react'
import { Upload, RefreshCw, Trash2 } from 'lucide-react'
import { cn } from '@/lib/utils'
import { getToken } from '@/utils/auth'

interface VideoUploaderProps {
  value?: string
  maxSize?: number
  onChange?: (url: string) => void
  onUploadSuccess?: (info: {
    url: string
    duration: number
    size: number
    cover: string
  }) => void
}

function formatDuration(seconds: number): string {
  if (!seconds) return '0秒'
  const h = Math.floor(seconds / 3600)
  const m = Math.floor((seconds % 3600) / 60)
  const s = Math.floor(seconds % 60)
  if (h > 0) return `${h}小时${m}分${s}秒`
  if (m > 0) return `${m}分${s}秒`
  return `${s}秒`
}

function formatSize(bytes: number): string {
  if (!bytes) return '0 B'
  const k = 1024
  const sizes = ['B', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return (bytes / Math.pow(k, i)).toFixed(2) + ' ' + sizes[i]
}

export default function VideoUploader({
  value = '',
  maxSize = 500,
  onChange,
  onUploadSuccess,
}: VideoUploaderProps) {
  const [uploading, setUploading] = useState(false)
  const [uploadPercent, setUploadPercent] = useState(0)
  const [videoUrl, setVideoUrl] = useState(value)
  const [duration, setDuration] = useState(0)
  const [fileSize, setFileSize] = useState(0)
  const [videoLoading, setVideoLoading] = useState(false)
  const [dragOver, setDragOver] = useState(false)
  const inputRef = useRef<HTMLInputElement | null>(null)
  const videoRef = useRef<HTMLVideoElement | null>(null)

  const token = useMemo(() => {
    const t = getToken()
    return t ? (t.startsWith('Bearer ') ? t : `Bearer ${t}`) : ''
  }, [])

  const handleFile = useCallback(
    (file: File) => {
      const isVideo = file.type.startsWith('video/')
      const isLtLimit = file.size / 1024 / 1024 < maxSize

      if (!isVideo) {
        alert('只能上传视频文件')
        return
      }
      if (!isLtLimit) {
        alert(`视频大小不能超过 ${maxSize}MB`)
        return
      }

      setFileSize(file.size)
      setUploading(true)
      setUploadPercent(0)
      setVideoLoading(false)

      // get video duration
      const video = document.createElement('video')
      video.preload = 'metadata'
      video.onloadedmetadata = () => {
        window.URL.revokeObjectURL(video.src)
        setDuration(Math.floor(video.duration))
      }
      video.src = URL.createObjectURL(file)

      const form = new FormData()
      form.append('file', file)

      const xhr = new XMLHttpRequest()
      xhr.open('POST', '/api/content/upload-video')
      xhr.setRequestHeader('Authorization', token)

      xhr.upload.onprogress = (e) => {
        if (e.lengthComputable) {
          setUploadPercent(Math.floor((e.loaded / e.total) * 100))
        }
      }

      xhr.onload = () => {
        setUploading(false)
        try {
          const response = JSON.parse(xhr.responseText)
          if (response.code === 200) {
            const previewUrl = response.data.url
            setVideoUrl(previewUrl)
            setDuration(response.data.duration || duration)
            setVideoLoading(true)
            const pathToSave = response.data.path || response.data.url
            onChange?.(pathToSave)
            onUploadSuccess?.({
              url: pathToSave,
              duration: response.data.duration || duration,
              size: file.size,
              cover: response.data.coverPath || response.data.cover || '',
            })
          } else {
            alert(response.message || '上传失败')
          }
        } catch {
          alert('上传响应解析失败')
        }
      }

      xhr.onerror = () => {
        setUploading(false)
        alert('视频上传失败，请重试')
      }

      xhr.send(form)
    },
    [token, maxSize, duration, onChange, onUploadSuccess],
  )

  const handleDrop = useCallback(
    (e: React.DragEvent) => {
      e.preventDefault()
      setDragOver(false)
      const file = e.dataTransfer.files?.[0]
      if (file) handleFile(file)
    },
    [handleFile],
  )

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (file) handleFile(file)
    e.target.value = ''
  }

  const handleReupload = () => {
    setVideoUrl('')
    setDuration(0)
    setFileSize(0)
    setVideoLoading(false)
    onChange?.('')
  }

  const handleRemove = () => handleReupload()

  return (
    <div className="w-full">
      <div
        className={cn(
          'relative flex min-h-[200px] w-full items-center justify-center rounded-lg border-2 border-dashed transition-colors cursor-pointer',
          dragOver ? 'border-primary bg-surface-soft' : 'border-hairline bg-canvas hover:border-primary',
          uploading && 'cursor-default',
        )}
        onDragOver={(e) => { e.preventDefault(); setDragOver(true) }}
        onDragLeave={() => setDragOver(false)}
        onDrop={handleDrop}
        onClick={() => !videoUrl && !uploading && inputRef.current?.click()}
      >
        <input
          ref={inputRef}
          type="file"
          accept="video/mp4,video/avi,video/mov,video/wmv,video/flv,video/webm"
          className="hidden"
          onChange={handleInputChange}
        />

        {!videoUrl && !uploading && (
          <div className="flex flex-col items-center gap-2 px-5 py-10 text-center">
            <Upload className="h-10 w-10 text-muted-soft" />
            <p className="text-body">拖拽视频文件到此处或点击上传</p>
            <p className="text-xs text-muted-soft">
              支持 MP4、AVI、MOV、WMV、FLV、WebM 格式，最大 {maxSize}MB
            </p>
          </div>
        )}

        {uploading && (
          <div className="flex flex-col items-center gap-3 py-10">
            <div className="relative h-20 w-20">
              <svg className="h-20 w-20 -rotate-90" viewBox="0 0 80 80">
                <circle cx="40" cy="40" r="34" fill="none" stroke="currentColor" className="text-hairline" strokeWidth="6" />
                <circle
                  cx="40" cy="40" r="34" fill="none" stroke="currentColor" className="text-primary" strokeWidth="6"
                  strokeDasharray={`${uploadPercent * 2.14} 214`}
                  strokeLinecap="round"
                />
              </svg>
              <span className="absolute inset-0 flex items-center justify-center text-sm font-medium text-body-strong">
                {uploadPercent}%
              </span>
            </div>
            <p className="text-sm text-muted">上传中...</p>
          </div>
        )}

        {videoUrl && !uploading && (
          <div className="w-full p-4">
            {videoLoading && (
              <div className="absolute inset-0 z-10 flex items-center justify-center bg-canvas/80 rounded-lg">
                <div className="flex flex-col items-center gap-2">
                  <div className="h-8 w-8 animate-spin rounded-full border-2 border-primary border-t-transparent" />
                  <p className="text-sm text-muted">视频加载中...</p>
                </div>
              </div>
            )}
            <video
              ref={videoRef}
              src={videoUrl}
              controls={!videoLoading}
              className={cn('w-full rounded-lg', videoLoading && 'invisible')}
              onLoadedData={() => setVideoLoading(false)}
              onError={() => { setVideoLoading(false); alert('视频加载失败') }}
            />
            <div className="mt-3 flex gap-2">
              <button
                type="button"
                onClick={handleReupload}
                className="inline-flex items-center gap-1.5 rounded-md border border-hairline px-3 py-1.5 text-xs text-body transition-colors hover:bg-surface-soft"
              >
                <RefreshCw className="h-3.5 w-3.5" />
                重新上传
              </button>
              <button
                type="button"
                onClick={handleRemove}
                className="inline-flex items-center gap-1.5 rounded-md border border-hairline px-3 py-1.5 text-xs text-error transition-colors hover:bg-error/10"
              >
                <Trash2 className="h-3.5 w-3.5" />
                删除
              </button>
            </div>
          </div>
        )}
      </div>

      {videoUrl && (
        <div className="mt-3 grid grid-cols-2 gap-3 rounded-lg border border-hairline bg-surface-card p-3 text-xs">
          <div>
            <span className="text-muted-soft">视频时长：</span>
            <span className="text-body-strong">{formatDuration(duration)}</span>
          </div>
          <div>
            <span className="text-muted-soft">文件大小：</span>
            <span className="text-body-strong">{formatSize(fileSize)}</span>
          </div>
        </div>
      )}
    </div>
  )
}
