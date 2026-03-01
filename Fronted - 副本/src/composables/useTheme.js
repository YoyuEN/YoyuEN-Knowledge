import { ref, watch } from 'vue'

const THEME_KEY = 'app-theme'
const themes = {
  light: 'light',
  dark: 'dark'
}

const currentTheme = ref(themes.light)

// 应用主题
const applyTheme = (theme) => {
  const root = document.documentElement
  if (theme === themes.dark) {
    root.classList.add('dark-theme')
    root.classList.remove('light-theme')
  } else {
    root.classList.add('light-theme')
    root.classList.remove('dark-theme')
  }
}

export function useTheme() {
  // 从 localStorage 读取保存的主题
  const initTheme = () => {
    const savedTheme = localStorage.getItem(THEME_KEY)
    if (savedTheme && (savedTheme === themes.light || savedTheme === themes.dark)) {
      currentTheme.value = savedTheme
    } else {
      // 默认使用浅色主题
      currentTheme.value = themes.light
    }
    applyTheme(currentTheme.value)
  }

  // 切换主题
  const toggleTheme = () => {
    currentTheme.value = currentTheme.value === themes.light ? themes.dark : themes.light
    localStorage.setItem(THEME_KEY, currentTheme.value)
    applyTheme(currentTheme.value)
  }

  // 设置主题
  const setTheme = (theme) => {
    if (theme === themes.light || theme === themes.dark) {
      currentTheme.value = theme
      localStorage.setItem(THEME_KEY, currentTheme.value)
      applyTheme(currentTheme.value)
    }
  }

  // 监听主题变化
  watch(currentTheme, (newTheme) => {
    applyTheme(newTheme)
  })

  return {
    currentTheme,
    themes,
    toggleTheme,
    setTheme,
    initTheme
  }
}
