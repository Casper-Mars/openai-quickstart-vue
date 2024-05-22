<script setup>
import { ref, watch } from 'vue'
import MarkdownIt from 'markdown-it'

const inputMessage = ref('')
const curStatus = ref('😴')
const messages = ref([])
const chatHistory = ref(null)
const md = new MarkdownIt()
const userAvatar = 'https://obs-cdn.52tt.com/tt/fe-moss/web/esport/20240522172635_89834367.png'
const aiAvatar = 'https://obs-cdn.52tt.com/tt/fe-moss/web/esport/20240522172655_67347498.png'

// 获取当前屏幕的大小
let screenHeight = window.innerHeight


watch(messages, () => {
  chatHistory.value.scrollTop = chatHistory.value.scrollHeight
})

async function sendMessage() {
  const question = inputMessage.value.trim()
  if (question === '') {
    return
  }
  try {
    messages.value.push({ content: question, role: 'human', avatar: userAvatar })
    inputMessage.value = ''
    curStatus.value = '思考中...🤔'
    const requestBody = {
      'msgs': messages.value,
    }

    const response = await fetch('http://192.168.36.70:8081/v2/ai/search', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(requestBody),
    })
    if (!response.ok) {
      console.log('HTTP error! status:', response.status)
      return
    }
    const data = await response.json()
    let show_msg = []
    data.msgs.forEach(msg => {
      if (msg.role === 'human') {
        show_msg.push({ content: msg.content, role: 'human', avatar: userAvatar })
      } else {
        show_msg.push({ content: msg.content, role: 'ai', avatar: aiAvatar })
      }
    })
    messages.value = show_msg
  } catch (error) {
    console.error(error)
  } finally {
    curStatus.value = '😴'
  }
}


</script>

<template>
  <el-container class="el-container">
    <el-main class="el-main" :style="{ height: screenHeight-50 + 'px' }">

    </el-main>
    <el-footer class="el-footer">
      <el-input
        class="chat-input"
        placeholder="🌽输入你的消息，回车确认🚀。例如：如何申请成为电竞大神？"
        v-model="inputMessage"
        @keyup.enter="sendMessage"
      >
      </el-input>
    </el-footer>
  </el-container>
</template>

<style scoped>
.chat-input {
  display: flex;
  justify-content: space-between;
  padding-top: 1em;
  padding-bottom: 1em;
  border-top: 1px solid #ccc;
}

.el-container {
  display: flex;
  flex-direction: column;
  height: 100vh; /* 设置容器高度为视口高度 */
}

.el-main {
  flex: 1 0 auto; /* 允许主内容区域自动扩展，但不允许它收缩 */
}

.el-footer {
  flex-shrink: 0; /* 防止页脚区域收缩 */
}
</style>
