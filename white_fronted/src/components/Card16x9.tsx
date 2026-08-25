import type { CSSProperties, ReactNode } from 'react'
import { Image } from 'lucide-react'

interface Card16x9Props {
  backgroundImage?: string
  height?: string
  children?: ReactNode
}

export default function Card16x9({ backgroundImage, height, children }: Card16x9Props) {
  const style: CSSProperties = {}
  if (height) style.height = height

  return (
    <div className="relative w-full overflow-hidden rounded-xl" style={{ aspectRatio: '16 / 9', ...style }}>
      {/* 模糊背景层 */}
      <div className="absolute inset-0 z-0 scale-125">
        {backgroundImage ? (
          <img
            src={backgroundImage}
            alt=""
            className="h-full w-full object-cover blur-md brightness-50"
          />
        ) : (
          <div className="flex h-full w-full items-center justify-center bg-surface-soft">
            <Image className="h-12 w-12 text-muted-soft" />
          </div>
        )}
      </div>

      {/* 内容层 */}
      <div className="relative z-10 flex h-full w-full flex-col justify-start">
        {children}
      </div>
    </div>
  )
}
