import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import KnowledgeBlog from '../views/KnowledgeBlog.vue'
import Content from '../views/Content.vue'
import ContentDetal from '../views/ContentDetal.vue'
import Profile from '../views/Profile.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home,
    meta: { title: 'AI对话' }
  },
  {
    path: '/knowledge-blog',
    name: 'KnowledgeBlog',
    component: KnowledgeBlog,
    meta: { title: '知识博客' }
  },
  {
    path: '/content',
    name: 'Content',
    component: Content,
    meta: { title: '内容创作' }
  },
  {
    path: '/content-detail/:type/:id',
    name: 'ContentDetail',
    component: ContentDetal,
    meta: { title: '内容详情' }
  },
  {
    path: '/profile',
    name: 'Profile',
    component: Profile,
    meta: { title: '个人中心' }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
