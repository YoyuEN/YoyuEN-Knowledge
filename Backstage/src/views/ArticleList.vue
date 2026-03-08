<template>
  <section>
    <div class="page-header">
      <div>
        <h1 class="page-title">文章管理</h1>
        <p class="page-desc">统一管理文章状态、分类和发布时间。</p>
      </div>
      <el-button type="primary">新增文章</el-button>
    </div>

    <el-card class="section-card">
      <div class="toolbar">
        <el-input placeholder="搜索标题/作者" clearable />
        <el-select placeholder="全部状态">
          <el-option label="已发布" value="published" />
          <el-option label="草稿" value="draft" />
          <el-option label="待审核" value="review" />
        </el-select>
        <el-button>重置</el-button>
        <el-button type="primary">查询</el-button>
      </div>

      <el-table :data="rows" stripe>
        <el-table-column prop="title" label="标题" min-width="260" />
        <el-table-column prop="category" label="分类" width="140" />
        <el-table-column prop="author" label="作者" width="140" />
        <el-table-column label="状态" width="120">
          <template #default="{ row }">
            <span class="tag-dot" :class="row.statusClass">{{ row.status }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="updatedAt" label="更新时间" width="180" />
        <el-table-column label="操作" width="170" fixed="right">
          <template #default>
            <el-button link type="primary">编辑</el-button>
            <el-button link>预览</el-button>
            <el-button link type="danger">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </section>
</template>

<script setup>
const rows = [
  { title: 'Vue 3 性能优化实践', category: '前端', author: 'Annie', status: '已发布', statusClass: 'tag-success', updatedAt: '2026-03-08 10:20' },
  { title: '后台权限模型设计', category: '架构', author: 'Leo', status: '待审核', statusClass: 'tag-warning', updatedAt: '2026-03-07 18:40' },
  { title: '发布流程 SOP', category: '流程', author: 'Mia', status: '草稿', statusClass: 'tag-danger', updatedAt: '2026-03-07 14:12' },
]
</script>
