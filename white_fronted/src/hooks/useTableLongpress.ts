import { useCallback, useEffect, useRef } from 'react'

interface LongPressOptions {
  pressDelay?: number
  moveThreshold?: number
}

/**
 * React hook for long-press on table rows.
 * Attach `onMouseDown` and `onTouchStart` to each row.
 * Row elements need class `table-row-longpress`.
 */
export function useTableLongpress<T>(
  onLongPress: (event: MouseEvent | TouchEvent, row: T) => void,
  rows: T[],
  options: LongPressOptions = {},
) {
  const { pressDelay = 500, moveThreshold = 10 } = options
  const cleanupRef = useRef<(() => void)[]>([])

  const setup = useCallback(() => {
    // Clean previous listeners
    cleanupRef.current.forEach((fn) => fn())
    cleanupRef.current = []

    const tableRows = document.querySelectorAll('.table-row-longpress')
    tableRows.forEach((row, index) => {
      const rowData = rows[index]
      if (!rowData) return

      const el = row as HTMLElement
      let pressTimer: ReturnType<typeof setTimeout> | null = null
      let startX = 0
      let startY = 0

      const start = (e: MouseEvent | TouchEvent) => {
        if (
          (e.target as HTMLElement)?.closest('button') ||
          (e.target as HTMLElement)?.closest('a')
        ) {
          return
        }

        if (e instanceof MouseEvent) {
          startX = e.clientX
          startY = e.clientY
        } else {
          startX = e.touches?.[0]?.clientX ?? 0
          startY = e.touches?.[0]?.clientY ?? 0
        }

        if (pressTimer === null) {
          pressTimer = setTimeout(() => {
            onLongPress(e, rowData)
          }, pressDelay)
        }
      }

      const cancel = (e: MouseEvent | TouchEvent) => {
        if (pressTimer !== null) {
          const currentX = e instanceof MouseEvent
            ? e.clientX
            : (e as TouchEvent).changedTouches?.[0]?.clientX ?? 0
          const currentY = e instanceof MouseEvent
            ? e.clientY
            : (e as TouchEvent).changedTouches?.[0]?.clientY ?? 0

          const moved = Math.abs(currentX - startX) > moveThreshold ||
            Math.abs(currentY - startY) > moveThreshold

          if (moved || e.type === 'mouseup' || e.type === 'touchend') {
            clearTimeout(pressTimer)
            pressTimer = null
          }
        }
      }

      el.addEventListener('mousedown', start)
      el.addEventListener('touchstart', start, { passive: true })
      el.addEventListener('mousemove', cancel)
      el.addEventListener('touchmove', cancel, { passive: true })
      el.addEventListener('mouseup', cancel)
      el.addEventListener('touchend', cancel)
      el.addEventListener('mouseleave', cancel)

      cleanupRef.current.push(() => {
        el.removeEventListener('mousedown', start)
        el.removeEventListener('touchstart', start)
        el.removeEventListener('mousemove', cancel)
        el.removeEventListener('touchmove', cancel)
        el.removeEventListener('mouseup', cancel)
        el.removeEventListener('touchend', cancel)
        el.removeEventListener('mouseleave', cancel)
      })
    })
  }, [rows, onLongPress, pressDelay, moveThreshold])

  useEffect(() => {
    setup()
  }, [setup])

  // Re-setup when rows change
  useEffect(() => {
    setup()
  }, [setup])

  const handleRowContextMenu = useCallback(
    (row: T, event: React.MouseEvent) => {
      event.preventDefault()
      onLongPress(event.nativeEvent, row)
    },
    [onLongPress],
  )

  return { setupLongpress: setup, handleRowContextMenu }
}
