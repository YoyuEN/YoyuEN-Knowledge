<template>
  <div class="login-container">
    <div class="login-card">
      <!-- 左侧介绍区 -->
      <div class="left-section">
        <div class="logo">
          <div class="logo-icon">Y</div>
        </div>
        <h1 class="brand-name">YoyuEN 知识库</h1>
        <p class="brand-desc">基于RAG技术的智能问答系统</p>
      </div>

      <!-- 右侧登录表单 -->
      <div class="right-section">
        <div class="login-form">
          <h2 class="login-title">欢迎回来</h2>

          <div class="form-group">
            <input
              v-model="loginForm.username"
              type="text"
              class="form-input"
              placeholder="请输入用户名"
              @keyup.enter="handleLogin"
            />
          </div>

          <div class="form-group">
            <input
              v-model="loginForm.password"
              type="password"
              class="form-input"
              placeholder="请输入密码"
              @keyup.enter="handleLogin"
            />
          </div>

          <button class="login-button" :disabled="loading" @click="handleLogin">
            {{ loading ? '登录中...' : '登录' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { login } from '@/api/auth.js'
import { setToken } from '@/utils/auth.js'

const router = useRouter()

const loginForm = ref({
  username: '',
  password: ''
})

const loading = ref(false)

const handleLogin = async () => {
  // 表单验证
  if (!loginForm.value.username) {
    ElMessage.warning('请输入用户名')
    return
  }
  if (!loginForm.value.password) {
    ElMessage.warning('请输入密码')
    return
  }

  loading.value = true

  try {
    const response = await login(loginForm.value)

    if (response.code === 200 && response.data.token) {
      // 保存 token
      setToken(response.data.token)

      // 显示成功提示
      ElMessage.success('登录成功')

      // 跳转到后台首页
      setTimeout(() => {
        router.push('/admin')
      }, 500)
    } else {
      ElMessage.error(response.message || '登录失败')
    }
  } catch (error) {
    ElMessage.error(error.message || '登录失败，请检查用户名和密码')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: #f5f5f5;
  padding: 60px;
}

.login-card {
  display: flex;
  width: 960px;
  height: 640px;
  background: #ffffff;
  border-radius: 16px;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.08);
  overflow: hidden;
}

/* 左侧介绍区 */
.left-section {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  background: #fafafa;
  padding: 60px;
  gap: 20px;
  border-radius: 16px 0 0 16px;
}

.logo {
  width: 64px;
  height: 64px;
  background: #e8eaf6;
  border-radius: 16px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.logo-icon {
  font-size: 32px;
  font-weight: 600;
  color: #5c6bc0;
  font-family: Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
}

.brand-name {
  font-size: 24px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0;
  font-family: Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
}

.brand-desc {
  font-size: 14px;
  color: #95a5a6;
  text-align: center;
  margin: 0;
  font-family: Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
}

/* 右侧登录表单 */
.right-section {
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 80px;
  border-radius: 0 16px 16px 0;
}

.login-form {
  width: 360px;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.login-title {
  font-size: 24px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0;
  font-family: Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-input {
  width: 100%;
  height: 48px;
  padding: 0 16px;
  background: #f8f9fa;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  color: #2c3e50;
  font-family: Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  outline: none;
  transition: background 0.2s;
}

.form-input::placeholder {
  color: #adb5bd;
}

.form-input:focus {
  background: #e9ecef;
}

.login-button {
  width: 100%;
  height: 52px;
  background: #ffeaa7;
  border: none;
  border-radius: 10px;
  font-size: 16px;
  font-weight: 500;
  color: #2c3e50;
  cursor: pointer;
  transition: all 0.2s;
  font-family: Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
}

.login-button:hover:not(:disabled) {
  background: #ffd97d;
  transform: translateY(-1px);
}

.login-button:active:not(:disabled) {
  transform: translateY(0);
}

.login-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
</style>
