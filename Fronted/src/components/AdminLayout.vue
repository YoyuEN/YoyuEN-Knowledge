<template>
  <div class="admin-layout">
    <aside class="admin-sidebar" :class="{ collapsed: sidebarCollapsed }">
      <div class="sidebar-header">
        <h2 v-if="!sidebarCollapsed">后台管理</h2>
        <button class="toggle-btn" @click="toggleSidebar">
          <span v-if="sidebarCollapsed">☰</span>
          <span v-else>✕</span>
        </button>
      </div>
      <nav class="sidebar-nav">
        <router-link
          v-for="item in menuItems"
          :key="item.path"
          :to="item.path"
          class="nav-item"
          active-class="active"
        >
          <span class="nav-icon">{{ item.icon }}</span>
          <span v-if="!sidebarCollapsed" class="nav-text">{{ item.label }}</span>
        </router-link>
      </nav>
      <div class="sidebar-footer">
        <router-link to="/" class="back-home">
          <span class="nav-icon">🏠</span>
          <span v-if="!sidebarCollapsed">返回前台</span>
        </router-link>
      </div>
    </aside>
    <main class="admin-main">
      <router-view />
    </main>
  </div>
</template>

<script setup>
import { ref } from 'vue';

const sidebarCollapsed = ref(false);

const menuItems = [
  { path: '/admin/dashboard', label: '仪表盘', icon: '📊' },
  { path: '/admin/content', label: '内容管理', icon: '📝' },
  { path: '/admin/knowledge', label: '知识库管理', icon: '📚' },
  { path: '/admin/moments', label: '碎碎念管理', icon: '💭' },
  { path: '/admin/comments', label: '评论管理', icon: '💬' },
  { path: '/admin/photos', label: '照片管理', icon: '🖼️' }
];

const toggleSidebar = () => {
  sidebarCollapsed.value = !sidebarCollapsed.value;
};
</script>

<style scoped>
.admin-layout {
  display: flex;
  min-height: 100vh;
  background: #fff;
}

.admin-sidebar {
  width: 240px;
  background: #fff;
  border-right: 1px solid #000;
  display: flex;
  flex-direction: column;
  transition: width 0.3s ease;
  position: fixed;
  left: 0;
  top: 0;
  bottom: 0;
  z-index: 100;
}

.admin-sidebar.collapsed {
  width: 60px;
}

.sidebar-header {
  padding: 20px;
  border-bottom: 1px solid #000;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.sidebar-header h2 {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  color: #000;
}

.toggle-btn {
  background: none;
  border: 1px solid #000;
  padding: 6px 10px;
  cursor: pointer;
  font-size: 16px;
  border-radius: 4px;
  transition: all 0.2s;
}

.toggle-btn:hover {
  background: #000;
  color: #fff;
}

.sidebar-nav {
  flex: 1;
  padding: 10px 0;
  overflow-y: auto;
}

.nav-item {
  display: flex;
  align-items: center;
  padding: 12px 20px;
  color: #000;
  text-decoration: none;
  transition: all 0.2s;
  border-left: 3px solid transparent;
}

.nav-item:hover {
  background: #f5f5f5;
  border-left-color: #000;
}

.nav-item.active {
  background: #f5f5f5;
  border-left-color: #000;
  font-weight: 600;
}

.nav-icon {
  font-size: 20px;
  min-width: 20px;
  margin-right: 12px;
}

.collapsed .nav-icon {
  margin-right: 0;
}

.nav-text {
  white-space: nowrap;
}

.sidebar-footer {
  padding: 10px;
  border-top: 1px solid #000;
}

.back-home {
  display: flex;
  align-items: center;
  padding: 12px 10px;
  color: #666;
  text-decoration: none;
  transition: all 0.2s;
  border-radius: 4px;
}

.back-home:hover {
  background: #f5f5f5;
  color: #000;
}

.admin-main {
  flex: 1;
  margin-left: 240px;
  padding: 20px;
  transition: margin-left 0.3s ease;
}

.admin-sidebar.collapsed ~ .admin-main {
  margin-left: 60px;
}

/* 移动端适配 */
@media (max-width: 768px) {
  .admin-sidebar {
    width: 60px;
  }

  .admin-sidebar.collapsed {
    width: 0;
    border: none;
  }

  .sidebar-header h2,
  .nav-text,
  .back-home span:not(.nav-icon) {
    display: none;
  }

  .admin-main {
    margin-left: 60px;
  }

  .admin-sidebar.collapsed ~ .admin-main {
    margin-left: 0;
  }

  .toggle-btn {
    position: fixed;
    top: 10px;
    left: 10px;
    z-index: 101;
    background: #fff;
  }
}
</style>
