<template>
  <section>
    <el-card class="admin-section-card">
      <div class="admin-toolbar">
        <div style="flex: 1;"></div>
        <el-button type="primary">新增角色</el-button>
      </div>
      <el-table :data="rows" stripe>
        <el-table-column prop="name" label="角色名称" min-width="160" />
        <el-table-column prop="code" label="角色编码" min-width="180" />
        <el-table-column prop="members" label="成员数" width="120" />
        <el-table-column prop="permissionCount" label="权限项" width="120" />
        <el-table-column prop="updatedAt" label="更新时间" width="180" />
        <el-table-column label="操作" width="160">
          <template #default>
            <el-button link type="primary">配置权限</el-button>
            <el-button link type="primary">编辑</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </section>
</template>

<script setup>
const rows = [
  { name: '超级管理员', code: 'ROLE_SUPER', members: 2, permissionCount: 86, updatedAt: '2026-03-08 09:10' },
  { name: '运营管理员', code: 'ROLE_OPS', members: 8, permissionCount: 42, updatedAt: '2026-03-08 08:41' },
  { name: '审核员', code: 'ROLE_REVIEWER', members: 5, permissionCount: 21, updatedAt: '2026-03-07 16:26' },
]
</script>
