<template>
  <section>
    <div class="page-header">
      <div>
        <h1 class="page-title">标签管理</h1>
        <p class="page-desc">标签支持多维聚合，建议维持在可控数量范围内。</p>
      </div>
      <el-button type="primary">新增标签</el-button>
    </div>

    <el-card class="section-card">
      <el-table :data="rows" stripe>
        <el-table-column prop="name" label="标签" min-width="180" />
        <el-table-column prop="coverage" label="覆盖文章" width="120" />
        <el-table-column prop="heat" label="热度" width="120" />
        <el-table-column prop="owner" label="维护人" width="120" />
        <el-table-column label="健康度" width="140">
          <template #default="{ row }">
            <el-progress :percentage="row.health" :stroke-width="8" />
          </template>
        </el-table-column>
        <el-table-column label="操作" width="160">
          <template #default>
            <el-button link type="primary">编辑</el-button>
            <el-button link type="danger">停用</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </section>
</template>

<script setup>
const rows = [
  { name: 'Vue3', coverage: 64, heat: '高', owner: 'Annie', health: 88 },
  { name: 'ElementPlus', coverage: 51, heat: '中', owner: 'Mia', health: 76 },
  { name: 'RAG', coverage: 28, heat: '高', owner: 'Leo', health: 62 },
]
</script>
