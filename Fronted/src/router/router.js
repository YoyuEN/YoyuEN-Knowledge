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
import CommentList from '../views/admin/CommentList.vue'
import PhotoList from '../views/admin/PhotoList.vue'
import Statistics from '../views/admin/Statistics.vue'
import KnowledgeList from '../views/admin/KnowledgeList.vue'

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
        path: 'comments',
        name: 'AdminComments',
        component: CommentList,
        meta: { title: '评论管理' },
      },
      {
        path: 'photos',
        name: 'AdminPhotos',
        component: PhotoList,
        meta: { title: '图片管理' },
      },
      {
        path: 'statistics',
        name: 'AdminStatistics',
        component: Statistics,
        meta: { title: '数据统计' },
      },
      {
        path: 'knowledge',
        name: 'AdminKnowledge',
        component: KnowledgeList,
        meta: { title: '知识库管理' },
      },
      {
        path: 'content',
        redirect: '/admin/articles',
      },
      {
        path: 'moments',
        redirect: '/admin/statistics',
      },
      {
        path: 'users',
        redirect: '/admin/comments',
      },
      {
        path: 'roles',
        redirect: '/admin/photos',
      },
      {
        path: 'permissions',
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
