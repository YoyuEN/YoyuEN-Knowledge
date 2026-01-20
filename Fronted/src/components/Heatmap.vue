<template>
  <n-heatmap :data="heatmapData" :color-theme="theme.value" />
</template>

<script setup>
import { ref, computed } from 'vue'
// import { heatmapMockData } from "naive-ui";  // 可以删掉，没用到

const theme = ref({ name: "红色", value: "red" })

const rawActivity = ref([
  { date: '2025-12-01', count: 3 },
  { date: '2025-12-02', count: 12 },
  { date: '2026-01-15', count: 20 },
  { date: '2026-01-16', count: 20 }
])

const heatmapData = computed(() => {
  return rawActivity.value.map(item => {
    const date = new Date(item.date)
    return {
      timestamp: date.getTime(),          // 核心：转成毫秒时间戳
      value: item.count                   // 或 item.count ?? null，如果你想显式用 null
    }
  })
})
</script>