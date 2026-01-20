import { createApp } from 'vue'
import './style.css'
import App from './App.vue'

import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import router from './router/router.js'
import naive from 'naive-ui'

createApp(App).use(ElementPlus).use(router).use(naive).mount('#app')
