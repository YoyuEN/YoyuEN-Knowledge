<template>
  <section>
    <el-card class="admin-section-card">
      <div class="admin-toolbar">
        <div style="flex: 1;"></div>
        <el-button type="primary">新增权限</el-button>
      </div>
      <el-table :data="rows" row-key="id" stripe>
        <el-table-column prop="module" label="模块" min-width="160" />
        <el-table-column prop="name" label="权限名称" min-width="200" />
        <el-table-column prop="code" label="权限标识" min-width="220" />
        <el-table-column prop="type" label="类型" width="120" />
        <el-table-column prop="updatedAt" label="更新时间" width="180" />
      </el-table>
    </el-card>
  </section>
</template>

<script setup>
const rows = [
  { id: 1, module: '知识管理', name: '文章读取', code: 'knowledge:article:read', type: '接口', updatedAt: '2026-03-08 09:30' },
  { id: 2, module: '知识管理', name: '文章发布', code: 'knowledge:article:publish', type: '按钮', updatedAt: '2026-03-08 09:30' },
  { id: 3, module: '系统设置', name: '用户编辑', code: 'system:user:update', type: '接口', updatedAt: '2026-03-08 09:05' },
]
</script>
