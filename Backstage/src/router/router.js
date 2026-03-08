import { createRouter, createWebHistory } from 'vue-router'
import Dashboard from '../views/Dashboard.vue'
import ArticleList from '../views/ArticleList.vue'
import CategoryList from '../views/CategoryList.vue'
import TagList from '../views/TagList.vue'
import UserList from '../views/UserList.vue'
import RoleList from '../views/RoleList.vue'
import PermissionList from '../views/PermissionList.vue'
import Statistics from '../views/Statistics.vue'

const routes = [
  {
    path: '/',
    redirect: '/dashboard',
  },
  {
    path: '/dashboard',
    name: 'dashboard',
    component: Dashboard,
    meta: {
      title: '仪表盘',
      section: 'overview',
    },
  },
  {
    path: '/knowledge/articles',
    name: 'articles',
    component: ArticleList,
    meta: {
      title: '文章管理',
      section: 'knowledge',
    },
  },
  {
    path: '/knowledge/categories',
    name: 'categories',
    component: CategoryList,
    meta: {
      title: '分类管理',
      section: 'knowledge',
    },
  },
  {
    path: '/knowledge/tags',
    name: 'tags',
    component: TagList,
    meta: {
      title: '标签管理',
      section: 'knowledge',
    },
  },
  {
    path: '/system/users',
    name: 'users',
    component: UserList,
    meta: {
      title: '用户管理',
      section: 'system',
    },
  },
  {
    path: '/system/roles',
    name: 'roles',
    component: RoleList,
    meta: {
      title: '角色管理',
      section: 'system',
    },
  },
  {
    path: '/system/permissions',
    name: 'permissions',
    component: PermissionList,
    meta: {
      title: '权限管理',
      section: 'system',
    },
  },
  {
    path: '/statistics',
    name: 'statistics',
    component: Statistics,
    meta: {
      title: '数据统计',
      section: 'overview',
    },
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router
