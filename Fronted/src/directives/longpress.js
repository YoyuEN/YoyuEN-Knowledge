/**
 * 长按指令
 * 用法: v-longpress="handler"
 */
export default {
  mounted(el, binding) {
    if (typeof binding.value !== 'function') {
      console.warn('v-longpress expects a function')
      return
    }

    let pressTimer = null
    let startX = 0
    let startY = 0
    const threshold = 10 // 移动阈值

    const start = (e) => {
      if (e.type === 'click' && e.button !== 0) return

      startX = e.clientX || e.touches?.[0]?.clientX || 0
      startY = e.clientY || e.touches?.[0]?.clientY || 0

      if (pressTimer === null) {
        pressTimer = setTimeout(() => {
          binding.value(e)
        }, 500) // 500ms 触发长按
      }
    }

    const cancel = (e) => {
      if (pressTimer !== null) {
        const currentX = e.clientX || e.changedTouches?.[0]?.clientX || 0
        const currentY = e.clientY || e.changedTouches?.[0]?.clientY || 0
        const moved = Math.abs(currentX - startX) > threshold || Math.abs(currentY - startY) > threshold

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

    el._longpress_cleanup = () => {
      el.removeEventListener('mousedown', start)
      el.removeEventListener('touchstart', start)
      el.removeEventListener('mousemove', cancel)
      el.removeEventListener('touchmove', cancel)
      el.removeEventListener('mouseup', cancel)
      el.removeEventListener('touchend', cancel)
      el.removeEventListener('mouseleave', cancel)
    }
  },
  unmounted(el) {
    el._longpress_cleanup?.()
  }
}
