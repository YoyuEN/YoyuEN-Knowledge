import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { getToken, setToken, removeToken } from '@/utils/auth'
import { getCurrentUser } from '@/api/auth'

export const useUserStore = defineStore('user', () => {
  // ==================== State ====================
  const token = ref(getToken() || '')
  const userInfo = ref({
    username: '',
    avatar: '',
    roles: []
  })

  // ==================== Getters ====================
  const isLoggedIn = computed(() => !!token.value)

  // ==================== Actions ====================

  /**
   * 设置 token（同步到 localStorage）
   */
  function setUserToken(newToken) {
    token.value = newToken
    setToken(newToken)
  }

  /**
   * 清除用户状态（同步清除 localStorage）
   */
  function clearUser() {
    token.value = ''
    userInfo.value = { username: '', avatar: '', roles: [] }
    removeToken()
  }

  /**
   * 登录：保存 token 并获取用户信息
   */
  async function login(newToken, info) {
    setUserToken(newToken)
    if (info) {
      userInfo.value = { ...userInfo.value, ...info }
    } else {
      await fetchUserInfo()
    }
  }

  /**
   * 登出：清除所有状态
   */
  function logout() {
    clearUser()
  }

  /**
   * 获取当前用户信息
   */
  async function fetchUserInfo() {
    if (!token.value) return null
    try {
      const response = await getCurrentUser()
      if (response.code === 200 && response.data) {
        userInfo.value = {
          username: response.data.username || '',
          avatar: response.data.avatar || '',
          roles: response.data.roles || []
        }
        return userInfo.value
      }
      return null
    } catch (error) {
      if (error.message && !error.message.includes('未登录')) {
        console.error('获取用户信息失败:', error)
      }
      return null
    }
  }

  /**
   * 应用启动时初始化：有 token 则自动获取用户信息
   */
  async function init() {
    if (token.value) {
      await fetchUserInfo()
    }
  }

  return {
    token,
    userInfo,
    isLoggedIn,
    login,
    logout,
    fetchUserInfo,
    init,
    setUserToken,
    clearUser
  }
})
