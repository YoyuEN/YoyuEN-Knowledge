import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import KnowledgeBlog from '../views/KnowledgeBlog.vue'
import LifeEntertainment from '../views/LifeEntertainment.vue'
import LifeExperience from '../views/LifeExperience.vue'
import WorkLife from '../views/WorkLife.vue'
import Detail from '../views/detail.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home,
    meta: { title: 'AI对话' }
  },
  {
    path: '/detail/:id',
    name: 'Detail',
    component: Detail,
    meta: { title: '游戏详情' }
  },
  {
    path: '/knowledge-blog',
    name: 'KnowledgeBlog',
    component: KnowledgeBlog,
    meta: { title: '知识博客' }
  },
  {
    path: '/life-entertainment',
    name: 'LifeEntertainment',
    component: LifeEntertainment,
    meta: { title: '生活娱乐' },
    children: [
      {
        path: '',
        redirect: '/life-entertainment/music'
      },
      {
        path: ':category',
        name: 'LifeEntertainmentCategory',
        component: LifeEntertainment,
        meta: { title: '生活娱乐' }
      }
    ]
  },
  {
    path: '/life-experience',
    name: 'LifeExperience',
    component: LifeExperience,
    meta: { title: '人生经历' }
  },
  {
    path: '/work-life',
    name: 'WorkLife',
    component: WorkLife,
    meta: { title: '工作生活' }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
