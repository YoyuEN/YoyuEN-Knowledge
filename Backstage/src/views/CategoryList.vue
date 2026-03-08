<template>
  <section>
    <div class="page-header">
      <div>
        <h1 class="page-title">分类管理</h1>
        <p class="page-desc">分类用于构建内容导航与检索体系。</p>
      </div>
      <el-button type="primary">新增分类</el-button>
    </div>

    <el-card class="section-card">
      <el-table :data="rows" stripe>
        <el-table-column prop="name" label="分类名称" min-width="220" />
        <el-table-column prop="slug" label="标识" min-width="180" />
        <el-table-column prop="count" label="文章数" width="120" />
        <el-table-column prop="updatedAt" label="更新时间" width="180" />
        <el-table-column label="操作" width="160">
          <template #default>
            <el-button link type="primary">编辑</el-button>
            <el-button link type="danger">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </section>
</template>

<script setup>
const rows = [
  { name: '前端开发', slug: 'frontend', count: 120, updatedAt: '2026-03-08 09:11' },
  { name: '后端架构', slug: 'backend', count: 86, updatedAt: '2026-03-07 18:02' },
  { name: '运维实践', slug: 'devops', count: 43, updatedAt: '2026-03-06 22:15' },
]
</script>
