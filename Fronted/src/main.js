import { createApp } from 'vue'
import './style.css'
import './styles/design-tokens.css'
import App from './App.vue'

import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import router from './router/router.js'
import naive from 'naive-ui'
import { gsap } from "gsap"
import pinia from './stores'
import { useUserStore } from './stores/user'

const app = createApp(App)

app.use(pinia)
app.use(ElementPlus)
app.use(router)
app.use(naive)
app.mount('#app')

// 应用启动时初始化用户状态：有 token 则自动获取用户信息
const userStore = useUserStore()
userStore.init()
