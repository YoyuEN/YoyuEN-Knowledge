<template>
  <div class="heatmap-wrapper">
    <div class="heatmap-grid">
      <div
        v-for="(item, index) in heatmapData"
        :key="index"
        class="heatmap-cell"
        :style="{
          backgroundColor: getCellColor(item.value),
          animationDelay: `${index * 0.005}s`
        }"
        @mouseenter="showTooltip($event, item)"
        @mouseleave="hideTooltip"
      ></div>
    </div>

    <!-- Tooltip -->
    <div
      v-if="tooltip.visible"
      class="heatmap-tooltip"
      :style="{
        left: tooltip.x + 'px',
        top: tooltip.y + 'px'
      }"
    >
      <div class="tooltip-date">{{ tooltip.date }}</div>
      <div class="tooltip-count">活跃度: {{ tooltip.count }}</div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, reactive } from 'vue'

// 生成最近100天的活跃数据
const generateLast100DaysData = () => {
  const data = []
  const today = new Date()

  for (let i = 99; i >= 0; i--) {
    const date = new Date(today)
    date.setDate(date.getDate() - i)

    // 随机生成活跃度数据 (0-30之间)
    // 你可以后续替换为真实的后端数据
    const count = Math.floor(Math.random() * 31)

    data.push({
      date: date.toISOString().split('T')[0],
      count: count
    })
  }

  return data
}

const rawActivity = ref(generateLast100DaysData())

const heatmapData = computed(() => {
  return rawActivity.value.map(item => {
    const date = new Date(item.date)
    return {
      timestamp: date.getTime(),
      date: item.date,
      value: item.count
    }
  })
})

// Tooltip 状态
const tooltip = reactive({
  visible: false,
  x: 0,
  y: 0,
  date: '',
  count: 0
})

// 根据值获取颜色
const getCellColor = (value) => {
  if (value === 0) return '#ebedf0'
  if (value <= 5) return '#ffcdd2'
  if (value <= 10) return '#ef9a9a'
  if (value <= 15) return '#e57373'
  if (value <= 20) return '#ef5350'
  if (value <= 25) return '#f44336'
  return '#c62828'
}

// 显示 tooltip
const showTooltip = (event, item) => {
  const rect = event.target.getBoundingClientRect()
  tooltip.visible = true
  tooltip.x = rect.left + rect.width / 2
  tooltip.y = rect.top - 10
  tooltip.date = item.date
  tooltip.count = item.value
}

// 隐藏 tooltip
const hideTooltip = () => {
  tooltip.visible = false
}
</script>

<style scoped>
.heatmap-wrapper {
  position: relative;
  width: 100%;
  padding: 20px 0;
}

.heatmap-grid {
  display: grid;
  grid-template-columns: repeat(20, 1fr);
  grid-template-rows: repeat(5, 1fr);
  gap: 4px;
  width: 100%;
}

.heatmap-cell {
  aspect-ratio: 1;
  border-radius: 3px;
  cursor: pointer;
  transition: all 0.3s ease;
  animation: fadeIn 0.5s ease-out backwards;
}

.heatmap-cell:hover {
  transform: scale(1.2);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  z-index: 10;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: scale(0.8);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

.heatmap-tooltip {
  position: fixed;
  transform: translate(-50%, -100%);
  background: rgba(0, 0, 0, 0.85);
  color: white;
  padding: 8px 12px;
  border-radius: 6px;
  font-size: 12px;
  pointer-events: none;
  z-index: 1000;
  white-space: nowrap;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
  animation: tooltipFadeIn 0.2s ease-out;
}

@keyframes tooltipFadeIn {
  from {
    opacity: 0;
    transform: translate(-50%, -100%) translateY(5px);
  }
  to {
    opacity: 1;
    transform: translate(-50%, -100%) translateY(0);
  }
}

.tooltip-date {
  font-weight: bold;
  margin-bottom: 4px;
}

.tooltip-count {
  color: #ffcdd2;
}
</style>