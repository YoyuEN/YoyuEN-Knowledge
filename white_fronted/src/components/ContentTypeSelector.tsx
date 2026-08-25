import { FileText, Video } from 'lucide-react'
import { cn } from '@/lib/utils'

interface ContentTypeSelectorProps {
  value?: string
  showDescription?: boolean
  onChange?: (value: string) => void
}

const descriptions: Record<string, string> = {
  article: '图文内容：支持富文本编辑，适合文章、教程、笔记等',
  video: '视频内容：支持上传视频文件或填写视频链接，适合视频教程、录屏、Vlog等',
}

export default function ContentTypeSelector({
  value = 'article',
  showDescription = true,
  onChange,
}: ContentTypeSelectorProps) {
  const options = [
    { value: 'article', label: '图文内容', Icon: FileText },
    { value: 'video', label: '视频内容', Icon: Video },
  ]

  return (
    <div className="w-full">
      <div className="flex w-full rounded-lg border border-hairline overflow-hidden">
        {options.map(({ value: optVal, label, Icon }) => (
          <button
            key={optVal}
            type="button"
            onClick={() => onChange?.(optVal)}
            className={cn(
              'flex flex-1 items-center justify-center gap-1.5 px-5 py-3 text-sm font-medium transition-colors',
              value === optVal
                ? 'bg-primary text-primary-foreground'
                : 'bg-canvas text-body hover:bg-surface-soft',
            )}
          >
            <Icon className="h-4 w-4" />
            {label}
          </button>
        ))}
      </div>

      {showDescription && (
        <div className="mt-4 rounded-lg border border-hairline-soft bg-surface-soft px-3 py-2.5 text-xs leading-relaxed text-muted">
          {descriptions[value] || descriptions.article}
        </div>
      )}
    </div>
  )
}
