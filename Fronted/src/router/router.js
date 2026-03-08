import { createRouter, createWebHistory } from 'vue-router'
import Layout from '../components/Layout.vue'
import Home from '../views/Home.vue'
import Content from '../views/Content.vue'
import ContentDetal from '../views/ContentDetal.vue'
import Profile from '../views/Profile.vue'
import AdminLayout from '../components/AdminLayout.vue'
import Dashboard from '../views/admin/Dashboard.vue'
import ArticleList from '../views/admin/ArticleList.vue'
import CategoryList from '../views/admin/CategoryList.vue'
import TagList from '../views/admin/TagList.vue'
import UserList from '../views/admin/UserList.vue'
import RoleList from '../views/admin/RoleList.vue'
import PermissionList from '../views/admin/PermissionList.vue'
import Statistics from '../views/admin/Statistics.vue'

const routes = [
  {
    path: '/',
    component: Layout,
    children: [
      {
        path: '',
        name: 'Home',
        component: Home,
        meta: { title: 'AI对话' },
      },
      {
        path: 'content',
        name: 'Content',
        component: Content,
        meta: { title: '内容创作' },
      },
      {
        path: 'content-detail/:type/:id',
        name: 'ContentDetail',
        component: ContentDetal,
        meta: { title: '内容详情' },
      },
      {
        path: 'profile',
        name: 'Profile',
        component: Profile,
        meta: { title: '个人中心' },
      },
    ],
  },
  {
    path: '/admin',
    component: AdminLayout,
    children: [
      {
        path: '',
        redirect: '/admin/dashboard',
      },
      {
        path: 'dashboard',
        name: 'AdminDashboard',
        component: Dashboard,
        meta: { title: '仪表盘' },
      },
      {
        path: 'articles',
        name: 'AdminArticles',
        component: ArticleList,
        meta: { title: '文章管理' },
      },
      {
        path: 'categories',
        name: 'AdminCategories',
        component: CategoryList,
        meta: { title: '分类管理' },
      },
      {
        path: 'tags',
        name: 'AdminTags',
        component: TagList,
        meta: { title: '标签管理' },
      },
      {
        path: 'users',
        name: 'AdminUsers',
        component: UserList,
        meta: { title: '用户管理' },
      },
      {
        path: 'roles',
        name: 'AdminRoles',
        component: RoleList,
        meta: { title: '角色管理' },
      },
      {
        path: 'permissions',
        name: 'AdminPermissions',
        component: PermissionList,
        meta: { title: '权限管理' },
      },
      {
        path: 'statistics',
        name: 'AdminStatistics',
        component: Statistics,
        meta: { title: '数据统计' },
      },
      {
        path: 'content',
        redirect: '/admin/articles',
      },
      {
        path: 'knowledge',
        redirect: '/admin/categories',
      },
      {
        path: 'moments',
        redirect: '/admin/statistics',
      },
      {
        path: 'comments',
        redirect: '/admin/permissions',
      },
      {
        path: 'photos',
        redirect: '/admin/tags',
      },
    ],
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router
