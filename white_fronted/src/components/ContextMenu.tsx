import React, { useCallback, useEffect, useRef, useState } from 'react'
import { createPortal } from 'react-dom'
import { cn } from '@/lib/utils'

interface ContextMenuAction {
  label: string
  icon?: React.ReactNode
  danger?: boolean
  handler: () => void
}

interface ContextMenuProps {
  title?: string
  actions?: ContextMenuAction[]
  children?: React.ReactNode
}

export interface ContextMenuHandle {
  show: (x: number, y: number) => void
  close: () => void
}

function ContextMenuInner(
  { title, actions = [], children }: ContextMenuProps,
  ref: React.Ref<ContextMenuHandle>,
) {
  const [visible, setVisible] = useState(false)
  const [pos, setPos] = useState({ x: 0, y: 0 })
  const menuRef = useRef<HTMLDivElement | null>(null)

  const close = useCallback(() => setVisible(false), [])

  const show = useCallback((x: number, y: number) => {
    setPos({ x, y })
    setVisible(true)

    // adjust position to avoid overflow
    requestAnimationFrame(() => {
      const menu = menuRef.current
      if (!menu) return
      const rect = menu.getBoundingClientRect()
      const vw = window.innerWidth
      const vh = window.innerHeight

      setPos((prev) => ({
        x: rect.right > vw ? vw - rect.width - 10 : prev.x,
        y: rect.bottom > vh ? vh - rect.height - 10 : prev.y,
      }))
    })
  }, [])

  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if (e.key === 'Escape') close()
    }
    if (visible) {
      document.addEventListener('keydown', onKey)
      return () => document.removeEventListener('keydown', onKey)
    }
  }, [visible, close])

  React.useImperativeHandle(ref, () => ({ show, close }), [show, close])

  if (!visible) return null

  return createPortal(
    <div
      className="fixed inset-0 z-[9999] bg-black/10"
      onClick={close}
      onContextMenu={(e) => e.preventDefault()}
    >
      <div
        ref={menuRef}
        className="fixed z-[10000] min-w-[200px] max-w-[400px] max-h-[80vh] overflow-auto rounded-lg bg-canvas shadow-lg border border-hairline"
        style={{ left: pos.x, top: pos.y }}
        onClick={(e) => e.stopPropagation()}
      >
        {title && (
          <div className="border-b border-hairline px-4 py-3 text-sm font-semibold text-body-strong">
            {title}
          </div>
        )}
        {children && (
          <div className="px-4 py-3 text-sm text-body leading-relaxed max-h-[300px] overflow-y-auto">
            {children}
          </div>
        )}
        {actions.length > 0 && (
          <div className="border-t border-hairline flex flex-col gap-1 p-2">
            {actions.map((action, i) => (
              <button
                key={i}
                type="button"
                onClick={() => {
                  action.handler()
                  close()
                }}
                className={cn(
                  'flex items-center gap-2 rounded px-3 py-2 text-left text-sm transition-colors',
                  action.danger
                    ? 'text-error hover:bg-error/10'
                    : 'text-body hover:bg-surface-soft hover:text-primary',
                )}
              >
                {action.icon}
                {action.label}
              </button>
            ))}
          </div>
        )}
      </div>
    </div>,
    document.body,
  )
}

const ContextMenu = React.forwardRef(ContextMenuInner)
export default ContextMenu
