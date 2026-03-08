import { ref, watch } from 'vue'

const THEME_KEY = 'app-theme'
const themes = {
  light: 'light',
  dark: 'dark',
}

const currentTheme = ref(themes.light)

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
  const initTheme = () => {
    const savedTheme = localStorage.getItem(THEME_KEY)
    if (savedTheme === themes.light || savedTheme === themes.dark) {
      currentTheme.value = savedTheme
    } else {
      currentTheme.value = themes.light
    }
    applyTheme(currentTheme.value)
  }

  const toggleTheme = () => {
    currentTheme.value = currentTheme.value === themes.light ? themes.dark : themes.light
    localStorage.setItem(THEME_KEY, currentTheme.value)
    applyTheme(currentTheme.value)
  }

  const setTheme = (theme) => {
    if (theme === themes.light || theme === themes.dark) {
      currentTheme.value = theme
      localStorage.setItem(THEME_KEY, currentTheme.value)
      applyTheme(currentTheme.value)
    }
  }

  watch(currentTheme, (newTheme) => {
    applyTheme(newTheme)
  })

  return {
    currentTheme,
    themes,
    toggleTheme,
    setTheme,
    initTheme,
  }
}
