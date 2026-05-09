<template>
  <section>
    <el-card class="admin-section-card">
      <div class="admin-toolbar">
        <el-input placeholder="搜索用户名/邮箱" clearable />
        <el-select placeholder="全部角色">
          <el-option label="超级管理员" value="super" />
          <el-option label="运营管理员" value="ops" />
          <el-option label="审核员" value="reviewer" />
        </el-select>
        <div style="flex: 1;"></div>
        <el-button type="primary">新增用户</el-button>
        <el-button type="primary">查询</el-button>
      </div>

      <el-table :data="rows">
        <el-table-column prop="name" label="用户名" min-width="160" />
        <el-table-column prop="email" label="邮箱" min-width="220" />
        <el-table-column prop="role" label="角色" width="140" />
        <el-table-column label="状态" width="120">
          <template #default="{ row }">
            <span class="admin-tag-dot" :class="row.enabled ? 'admin-tag-success' : 'admin-tag-danger'">
              {{ row.enabled ? '启用' : '禁用' }}
            </span>
          </template>
        </el-table-column>
        <el-table-column prop="lastLogin" label="最近登录" width="180" />
        <el-table-column label="操作" width="180">
          <template #default>
            <el-button link type="primary">编辑</el-button>
            <el-button link type="warning">重置密码</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </section>
</template>

<script setup>
const rows = [
  { name: 'admin', email: 'admin@yoyuen.com', role: '超级管理员', enabled: true, lastLogin: '2026-03-08 11:42' },
  { name: 'operator01', email: 'ops@yoyuen.com', role: '运营管理员', enabled: true, lastLogin: '2026-03-08 10:31' },
  { name: 'reviewer02', email: 'review@yoyuen.com', role: '审核员', enabled: false, lastLogin: '2026-03-06 20:17' },
]
</script>
