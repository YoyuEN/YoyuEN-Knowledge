import { createRouter, createWebHistory } from 'vue-router'
import YoyuEN from '@/views/YoyuEN.vue'

const routes = [
  {
    path: '/yoyuen',
    name: 'YoyuEN',
    component: YoyuEN
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
