<template>
  <div class="chat-page container">
    <h1>AI 对话</h1>

    <div class="chat-card">
      <div class="messages" ref="msgWrap">
        <div v-for="(m, i) in messages" :key="i" :class="['message', m.role]">
          <div class="bubble">{{ m.text }}</div>
        </div>
        <div v-if="loading" class="message assistant">
          <div class="bubble">...</div>
        </div>
      </div>

      <form class="composer" @submit.prevent="sendMessage">
        <input v-model="newMessage" type="text" placeholder="输入消息，按回车发送..." />
        <button type="submit">发送</button>
      </form>
    </div>
  </div>
</template>

<script>
import { ref, nextTick } from 'vue'

export default {
  name: 'YoyuEN',
  setup() {
    const messages = ref([
      { role: 'assistant', text: '你好！我是你的本地模拟 AI。输入信息并回车开始对话。' }
    ])
    const newMessage = ref('')
    const loading = ref(false)
    const msgWrap = ref(null)

    function scrollToBottom() {
      nextTick(() => {
        const el = msgWrap.value
        if (el) el.scrollTop = el.scrollHeight
      })
    }

    function sendMessage() {
      const txt = (newMessage.value || '').trim()
      if (!txt) return
      messages.value.push({ role: 'user', text: txt })
      newMessage.value = ''
      loading.value = true
      scrollToBottom()

      // 模拟异步 AI 回复（这里可以替换为真实 API 调用）
      setTimeout(() => {
        const reply = `已收到：${txt}`
        messages.value.push({ role: 'assistant', text: reply })
        loading.value = false
        scrollToBottom()
      }, 700)
    }

    // 初始滚动
    nextTick(scrollToBottom)

    return { messages, newMessage, sendMessage, loading, msgWrap }
  }
}
</script>

<style scoped>
.chat-page {
  padding: 20px;
  height: 100%;
}

.chat-card {
  background: var(--bg);
  border-radius: 8px;
  height: 100%;
  padding: 12px;
}

.messages {
  height: 420px;
  overflow: auto;
  padding: 12px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  border-radius: 6px
}

.message {
  display: flex
}

.message.user {
  justify-content: flex-end
}

.bubble {
  max-width: 78%;
  padding: 10px 12px;
  border-radius: 12px;
  background: var(--menu-active-bg, #e6f0ff);
  color: var(--fg);
}

.message.assistant .bubble {
  background: #3a3a3a
}

.composer {
  display: flex;
  gap: 8px;
  margin-top: 12px
}

.composer input {
  flex: 1;
  padding: 10px;
  border-radius: 6px;
  border: 1px solid rgba(0, 0, 0, 0.12)
}

.composer button {
  padding: 10px 12px;
  border-radius: 6px;
  border: none;
  background: #2563eb;
  color: white;
  cursor: pointer
}
</style>
