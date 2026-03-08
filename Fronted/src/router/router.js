import { createRouter, createWebHistory } from 'vue-router'
import Layout from '../components/Layout.vue'
import Home from '../views/Home.vue'
import Content from '../views/Content.vue'
import ContentDetal from '../views/ContentDetal.vue'
import Profile from '../views/Profile.vue'
import AdminLayout from '../components/AdminLayout.vue'
import Dashboard from '../views/admin/Dashboard.vue'
import PhotoManage from '../views/admin/PhotoManage.vue'
import ContentManage from '../views/admin/ContentManage.vue'
import KnowledgeManage from '../views/admin/KnowledgeManage.vue'
import MomentManage from '../views/admin/MomentManage.vue'
import CommentManage from '../views/admin/CommentManage.vue'

const routes = [
  {
    path: '/',
    component: Layout,
    children: [
      {
        path: '',
        name: 'Home',
        component: Home,
        meta: { title: 'AI对话' }
      },
      {
        path: 'content',
        name: 'Content',
        component: Content,
        meta: { title: '内容创作' }
      },
      {
        path: 'content-detail/:type/:id',
        name: 'ContentDetail',
        component: ContentDetal,
        meta: { title: '内容详情' }
      },
      {
        path: 'profile',
        name: 'Profile',
        component: Profile,
        meta: { title: '个人中心' }
      }
    ]
  },
  {
    path: '/admin',
    component: AdminLayout,
    children: [
      {
        path: '',
        redirect: '/admin/dashboard'
      },
      {
        path: 'dashboard',
        name: 'AdminDashboard',
        component: Dashboard,
        meta: { title: '后台仪表盘' }
      },
      {
        path: 'content',
        name: 'AdminContent',
        component: ContentManage,
        meta: { title: '内容管理' }
      },
      {
        path: 'knowledge',
        name: 'AdminKnowledge',
        component: KnowledgeManage,
        meta: { title: '知识库管理' }
      },
      {
        path: 'moments',
        name: 'AdminMoments',
        component: MomentManage,
        meta: { title: '碎碎念管理' }
      },
      {
        path: 'comments',
        name: 'AdminComments',
        component: CommentManage,
        meta: { title: '评论管理' }
      },
      {
        path: 'photos',
        name: 'AdminPhotos',
        component: PhotoManage,
        meta: { title: '照片管理' }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
