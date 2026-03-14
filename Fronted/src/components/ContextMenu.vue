<template>
  <teleport to="body">
    <transition name="context-menu-fade">
      <div
        v-if="visible"
        class="context-menu-overlay"
        @click="close"
        @contextmenu.prevent
      >
        <div
          class="context-menu"
          :style="menuStyle"
          @click.stop
        >
          <div v-if="title" class="context-menu-title">{{ title }}</div>
          <div class="context-menu-content">
            <slot></slot>
          </div>
          <div v-if="actions.length" class="context-menu-actions">
            <button
              v-for="(action, index) in actions"
              :key="index"
              class="context-menu-action"
              :class="{ danger: action.danger }"
              @click="handleAction(action)"
            >
              <el-icon v-if="action.icon"><component :is="action.icon" /></el-icon>
              {{ action.label }}
            </button>
          </div>
        </div>
      </div>
    </transition>
  </teleport>
</template>

<script setup>
import { ref, computed } from 'vue'

const props = defineProps({
  title: String,
  actions: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['close'])

const visible = ref(false)
const position = ref({ x: 0, y: 0 })

const menuStyle = computed(() => {
  return {
    left: `${position.value.x}px`,
    top: `${position.value.y}px`
  }
})

const show = (x, y) => {
  position.value = { x, y }
  visible.value = true

  // 调整位置避免超出屏幕
  setTimeout(() => {
    const menu = document.querySelector('.context-menu')
    if (!menu) return

    const rect = menu.getBoundingClientRect()
    const viewportWidth = window.innerWidth
    const viewportHeight = window.innerHeight

    if (rect.right > viewportWidth) {
      position.value.x = viewportWidth - rect.width - 10
    }
    if (rect.bottom > viewportHeight) {
      position.value.y = viewportHeight - rect.height - 10
    }
  }, 0)
}

const close = () => {
  visible.value = false
  emit('close')
}

const handleAction = (action) => {
  action.handler?.()
  close()
}

defineExpose({ show, close })
</script>

<style scoped>
.context-menu-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 9999;
  background: rgba(0, 0, 0, 0.1);
}

.context-menu {
  position: fixed;
  background: white;
  border-radius: 8px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  min-width: 200px;
  max-width: 400px;
  max-height: 80vh;
  overflow: auto;
  z-index: 10000;
}

.context-menu-title {
  padding: 12px 16px;
  font-weight: 600;
  font-size: 14px;
  border-bottom: 1px solid #f0f0f0;
  color: #303133;
}

.context-menu-content {
  padding: 12px 16px;
  font-size: 13px;
  color: #606266;
  line-height: 1.6;
  max-height: 300px;
  overflow-y: auto;
}

.context-menu-actions {
  border-top: 1px solid #f0f0f0;
  padding: 8px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.context-menu-action {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  border: none;
  background: transparent;
  color: #606266;
  font-size: 13px;
  cursor: pointer;
  border-radius: 4px;
  transition: all 0.2s;
  text-align: left;
}

.context-menu-action:hover {
  background: #f5f7fa;
  color: #409eff;
}

.context-menu-action.danger {
  color: #f56c6c;
}

.context-menu-action.danger:hover {
  background: #fef0f0;
}

.context-menu-fade-enter-active,
.context-menu-fade-leave-active {
  transition: opacity 0.2s;
}

.context-menu-fade-enter-from,
.context-menu-fade-leave-to {
  opacity: 0;
}
</style>
