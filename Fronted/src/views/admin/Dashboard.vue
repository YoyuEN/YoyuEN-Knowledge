<template>
  <section>
    <div class="admin-page-header">
      <div>
        <h1 class="admin-page-title">仪表盘</h1>
        <p class="admin-page-desc">查看内容资产与系统运行概览。</p>
      </div>
      <el-button type="primary">新建文章</el-button>
    </div>

    <div class="admin-metric-grid">
      <article class="admin-metric-card" v-for="card in metrics" :key="card.label">
        <p class="admin-metric-label">{{ card.label }}</p>
        <p class="admin-metric-value">{{ card.value }}</p>
        <p class="admin-metric-extra">{{ card.extra }}</p>
      </article>
    </div>

    <el-card class="admin-section-card">
      <template #header>待处理任务</template>
      <el-table :data="todos" stripe>
        <el-table-column prop="title" label="任务" min-width="220" />
        <el-table-column prop="owner" label="负责人" width="130" />
        <el-table-column prop="deadline" label="截止时间" width="160" />
        <el-table-column label="优先级" width="120">
          <template #default="{ row }">
            <span class="admin-tag-dot" :class="row.levelClass">{{ row.level }}</span>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </section>
</template>

<script setup>
const metrics = [
  { label: '文章总数', value: '1,284', extra: '周环比 +4.2%' },
  { label: '草稿数量', value: '46', extra: '等待发布审核' },
  { label: '分类数量', value: '32', extra: '已启用 29' },
  { label: '本月活跃用户', value: '912', extra: '较上月 +11.7%' },
]

const todos = [
  { title: '补齐 SEO 描述字段', owner: '运营组', deadline: '2026-03-10', level: '高', levelClass: 'admin-tag-danger' },
  { title: '复核 AI 生成标签', owner: '内容组', deadline: '2026-03-11', level: '中', levelClass: 'admin-tag-warning' },
  { title: '清理低质量评论', owner: '审核组', deadline: '2026-03-12', level: '低', levelClass: 'admin-tag-success' },
]
</script>
