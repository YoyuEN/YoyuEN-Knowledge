import { useEffect, useState } from 'react'
import { fetchActivityStats } from '@/api/content'
import { cn } from '@/lib/utils'

const DAYS = 100

interface CellData {
  date: string
  count: number
  timestamp: number
}

function buildDateSkeleton(): CellData[] {
  const today = new Date()
  const result: CellData[] = []
  for (let i = DAYS - 1; i >= 0; i--) {
    const d = new Date(today)
    d.setDate(d.getDate() - i)
    const dateStr = d.toISOString().split('T')[0]
    result.push({ date: dateStr, count: 0, timestamp: d.getTime() })
  }
  return result
}

const CELL_COLORS: string[] = [
  'bg-surface-soft',                       // 0
  'bg-primary/20',                          // 1-2
  'bg-primary/35',                          // 3-4
  'bg-primary/55',                          // 5-6
  'bg-primary/75',                          // 7-8
  'bg-primary',                             // 9-10
  'bg-primary-active',                      // 11+
]

function getColorIndex(count: number): number {
  if (count === 0) return 0
  if (count <= 2) return 1
  if (count <= 4) return 2
  if (count <= 6) return 3
  if (count <= 8) return 4
  if (count <= 10) return 5
  return 6
}

export default function Heatmap() {
  const [cells, setCells] = useState<CellData[]>(() => buildDateSkeleton())
  const [tooltip, setTooltip] = useState<{ x: number; y: number; date: string; count: number } | null>(null)

  useEffect(() => {
    let cancelled = false
    fetchActivityStats(DAYS)
      .then((res: unknown) => {
        if (cancelled) return
        const statsMap = (res as { data?: Record<string, number> })?.data ?? {}
        setCells((prev) =>
          prev.map((c) => ({ ...c, count: statsMap[c.date] ?? 0 })),
        )
      })
      .catch(() => { /* silent */ })
    return () => { cancelled = true }
  }, [])

  const showTooltip = (e: React.MouseEvent<HTMLDivElement>, cell: CellData) => {
    const rect = e.currentTarget.getBoundingClientRect()
    setTooltip({
      x: rect.left + rect.width / 2,
      y: rect.top - 10,
      date: cell.date,
      count: cell.count,
    })
  }

  return (
    <div className="relative w-full py-5">
      <div className="grid grid-cols-20 grid-rows-5 gap-1 w-full">
        {cells.map((cell, i) => (
          <div
            key={cell.date}
            className={cn(
              'aspect-square rounded-sm cursor-pointer transition-all duration-300 hover:scale-125 hover:shadow-lg hover:z-10',
              CELL_COLORS[getColorIndex(cell.count)],
            )}
            style={{ animation: `fadeIn 0.5s ease-out ${i * 0.005}s backwards` }}
            onMouseEnter={(e) => showTooltip(e, cell)}
            onMouseLeave={() => setTooltip(null)}
          />
        ))}
      </div>

      {tooltip && (
        <div
          className="fixed z-50 -translate-x-1/2 rounded-md bg-dark-elevated px-2.5 py-1.5 text-xs text-ink shadow-lg pointer-events-none"
          style={{ left: tooltip.x, top: tooltip.y }}
        >
          <div>{tooltip.date}</div>
          <div className="text-muted-soft">活跃度: {tooltip.count}</div>
        </div>
      )}

      <style>{`
        @keyframes fadeIn {
          from { opacity: 0; transform: scale(0.8); }
          to { opacity: 1; transform: scale(1); }
        }
        .grid-cols-20 { grid-template-columns: repeat(20, 1fr); }
        .grid-rows-5 { grid-template-rows: repeat(5, 1fr); }
      `}</style>
    </div>
  )
}
