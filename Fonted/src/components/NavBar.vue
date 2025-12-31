<template>
  <nav class="sidebar" @mouseenter="onHover(true)" @mouseleave="onHover(false)">
    <!-- 站点标题 -->
    <div class="logo">
      <img src="@/assets/icons/logo.jpg" alt="YoyuEN Logo" class="logo-img" />
      <span>YoyuEN</span>
    </div>

    <!-- 导航菜单 -->
    <ul class="menu">
      <li>
        <router-link to="/yoyuen"><img class="icon" src="@/assets/icons/chat.png"><span class="label">Chat</span></router-link>
      </li>
      <li>
        <router-link to="/life"><img class="icon" src="@/assets/icons/life.png"><span class="label">人生经历</span></router-link>
      </li>
      <li>
        <router-link to="/entertainment"><img class="icon" src="@/assets/icons/entertainment.png"><span class="label">生活娱乐</span></router-link>
      </li>
      <li>
        <router-link to="/blog"><img class="icon" src="@/assets/icons/blog.png"><span class="label">知识博客</span></router-link>
      </li>
    </ul>

    <div class="nav-footer">
      <button class="theme-toggle-btn" @click="toggleTheme" :aria-pressed="theme === 'dark'"
        :title="theme === 'dark' ? '切换到浅色模式' : '切换到深色模式'">
        {{ theme === 'dark' ? '🌙' : '☀️' }}
      </button>
    </div>
  </nav>
</template>

<script>
export default {
  name: 'NavBar',
  data() {
    return { theme: 'light' }
  },
  mounted() {
    const saved = localStorage.getItem('theme')
    if (saved === 'dark' || saved === 'light') {
      this.theme = saved
    } else if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
      this.theme = 'dark'
    }
    document.body.classList.add(this.theme)
    // force default to collapsed and clear any previous preference so hover controls expansion
    localStorage.removeItem('sidebar-collapsed')
    document.body.classList.add('sidebar-collapsed')
  },
  methods: {
    toggleTheme() {
      const next = this.theme === 'dark' ? 'light' : 'dark'
      if (document.body.classList.contains(this.theme)) {
        document.body.classList.replace(this.theme, next)
      } else {
        document.body.classList.add(next)
      }
      this.theme = next
      localStorage.setItem('theme', next)
    },
    // fallback hover handlers to ensure expansion works across browsers
    onHover(enter) {
      if (enter) document.body.classList.add('sidebar-hovered')
      else document.body.classList.remove('sidebar-hovered')
    }
  }
}
</script>

<style>
@import '@/assets/css/nav.css';
</style>
