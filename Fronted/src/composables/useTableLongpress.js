import { ref, computed, watch, nextTick } from 'vue'

/**
 * 为表格行添加长按功能的组合式函数
 * @param {Function} onLongPress - 长按回调函数，接收 (event, rowData) 参数
 * @param {Ref} pagedRowsRef - 当前页的数据引用
 * @param {Object} options - 配置选项
 * @returns {Object} - 返回需要的响应式数据和方法
 */
export function useTableLongpress(onLongPress, pagedRowsRef, options = {}) {
  const {
    pageSize = 10,
    pressDelay = 500,
    moveThreshold = 10
  } = options

  const currentPage = ref(1)

  const setupTableLongpress = () => {
    nextTick(() => {
      const tableRows = document.querySelectorAll('.table-row-longpress')
      tableRows.forEach((row, index) => {
        // 清除旧的事件监听器
        if (row._longpress_cleanup) {
          row._longpress_cleanup()
        }

        let pressTimer = null
        let startX = 0
        let startY = 0

        const start = (e) => {
          const rowData = pagedRowsRef.value[index]
          if (!rowData) return

          // 如果点击的是按钮或链接，不触发长按
          if (e.target.closest('button') || e.target.closest('a') || e.target.closest('.el-switch')) {
            return
          }

          startX = e.clientX || e.touches?.[0]?.clientX || 0
          startY = e.clientY || e.touches?.[0]?.clientY || 0

          if (pressTimer === null) {
            pressTimer = setTimeout(() => {
              onLongPress(e, rowData)
            }, pressDelay)
          }
        }

        const cancel = (e) => {
          if (pressTimer !== null) {
            const currentX = e.clientX || e.changedTouches?.[0]?.clientX || 0
            const currentY = e.clientY || e.changedTouches?.[0]?.clientY || 0
            const moved = Math.abs(currentX - startX) > moveThreshold || Math.abs(currentY - startY) > moveThreshold

            if (moved || e.type === 'mouseup' || e.type === 'touchend') {
              clearTimeout(pressTimer)
              pressTimer = null
            }
          }
        }

        row.addEventListener('mousedown', start)
        row.addEventListener('touchstart', start, { passive: true })
        row.addEventListener('mousemove', cancel)
        row.addEventListener('touchmove', cancel, { passive: true })
        row.addEventListener('mouseup', cancel)
        row.addEventListener('touchend', cancel)
        row.addEventListener('mouseleave', cancel)

        row._longpress_cleanup = () => {
          row.removeEventListener('mousedown', start)
          row.removeEventListener('touchstart', start)
          row.removeEventListener('mousemove', cancel)
          row.removeEventListener('touchmove', cancel)
          row.removeEventListener('mouseup', cancel)
          row.removeEventListener('touchend', cancel)
          row.removeEventListener('mouseleave', cancel)
        }
      })
    })
  }

  const handleRowContextMenu = (row, column, event) => {
    event.preventDefault()
    onLongPress(event, row)
  }

  const currentPageValue = computed({
    get: () => currentPage.value,
    set: (val) => {
      currentPage.value = val
      setupTableLongpress()
    }
  })

  // 监听 pagedRows 变化，重新绑定事件
  watch(pagedRowsRef, () => {
    setupTableLongpress()
  }, { flush: 'post' })

  return {
    currentPage,
    currentPageValue,
    pageSize,
    setupTableLongpress,
    handleRowContextMenu
  }
}
