<script>
import {ref, watch} from 'vue';
import MarkdownIt from 'markdown-it';

export default {
  setup() {
    const inputMessage = ref('');
    const curStatus = ref('😴');
    const messages = ref([]);
    const chatHistory = ref(null);
    const md = new MarkdownIt();

    watch(messages, () => {
      chatHistory.value.scrollTop = chatHistory.value.scrollHeight;
    });

    async function sendMessage() {
      const question = inputMessage.value.trim()
      if (question === '') {
        return
      }
      try {
        messages.value.push({content: question, role: "您", avatar: ""});
        inputMessage.value = '';
        curStatus.value = '思考中...🤔';
        // 请求后端接口 http://localhost:8080/v1/ai/search
        // 参数格式如下：
        // {
        //  "question": "What is the capital of China?"
        // }
        // 返回结果格式如下：
        // {
        //  "answer": "Beijing"
        // }
        const response = await fetch('http://192.168.36.70:8081/v1/ai/search', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({'question': question}),
        })
        if (!response.ok) {
          console.log('HTTP error! status:', response.status)
          return;
        }

        const data = await response.json()
        messages.value.push({content: md.render(data.answer), role: "电竞需求助手", avatar: ""});
      } catch (error) {
        console.error(error)
      } finally {
        curStatus.value = '😴'
      }
    };

    return {
      inputMessage,
      messages,
      chatHistory,
      curStatus,
      sendMessage,
    };
  },
};


</script>

<template>
  <div class="chat-container">
    <h2>🤖️ 电竞需求助手({{ curStatus }})</h2>
    <div class="chat-history" ref="chatHistory">
      <div v-for="(message, index) in messages" :key="index" class="message">
        <div class="message">
          <div class="role-text">{{ message.role }}</div>
          <div v-html="message.content"></div>
        </div>
      </div>
    </div>
    <div class="chat-input">
      <input type="text" v-model="inputMessage" placeholder="🌽输入你的消息，回车确认🚀。例如：如何申请成为电竞大神？"
             @keyup.enter="sendMessage"/>
    </div>
  </div>
</template>

<style scoped>

.role-text {
  font-weight: bold;
}

.chat-container {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.chat-history {
  flex-grow: 1;
  overflow-y: auto;
  padding: 1em;
  border-bottom: 1px solid #ccc;
}

.chat-input {
  display: flex;
  justify-content: space-between;
  padding: 1em;
  border-top: 1px solid #ccc;
}

.chat-input input {
  flex-grow: 1;
  margin-right: 1em;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 10px; /* 修改这里 */
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
  font-size: 16px;
  color: #333;
  transition: all 0.3s ease;
}

.chat-input input:focus {
  border-color: #007BFF;
  box-shadow: 0 0 10px rgba(0, 123, 255, 0.5);
}

.message {
  margin-bottom: 1em;
}

h1 {
  margin-bottom: 64px;
}

/*
.chat {
} */
.input {
  width: calc(100% - 20px);
  height: 32px;
  padding: 12px;
  border: none;
  border-radius: 16px;
  box-shadow: 2px 2px 7px 0 rgb(0, 0, 0, 0.2);
  outline: none;
  font-size: 16px;
}

.input:invalid {
  animation: justshake 0.3s forwards;
  color: red;
}

@keyframes justshake {
  25% {
    transform: translateX(5px);
  }
  50% {
    transform: translateX(-5px);
  }

  75% {
    transform: translateX(5px);
  }

  100% {
    transform: translateX(5px);
  }
}

button {
  cursor: pointer;
  height: 32px;
  font-size: 16px;
  margin-top: 24px;
  background: royalblue;
  color: white;
  padding: 0.7em 1em;
  padding-left: 0.9em;
  display: flex;
  align-items: center;
  border: none;
  border-radius: 16px;
  overflow: hidden;
  transition: all 0.2s;
}

button span {
  display: block;
  margin-left: 0.3em;
  transition: all 0.3s ease-in-out;
}

button svg {
  display: block;
  transform-origin: center center;
  transition: transform 0.3s ease-in-out;
}

.card {
  background: #07182e;
  position: relative;
  display: flex;
  place-content: center;
  place-items: center;
  overflow: hidden;
  border-radius: 16px;
  margin: 24px 0;
}

.card {
  margin-top: 32px;
}

.card span,
.card pre {
  z-index: 1;
  color: white;
  font-size: 16px;
}

.card::before {
  content: '';
  position: absolute;
  width: 100%;
  background-image: linear-gradient(180deg, rgb(0, 183, 255), rgb(255, 48, 255));
  height: 130%;
  animation: rotBGimg 3s linear infinite;
  transition: all 0.2s linear;
}

.card::after {
  content: '';
  position: absolute;
  background: #07182e;
  inset: 5px;
  border-radius: 16px;
}

.button-block {
  display: flex;
  align-items: center;
  justify-content: end;
}

.btn {
  display: flex;
  justify-content: center;
  align-items: center;
  min-width: 8rem;
  max-width: 13rem;
  height: 3rem;
  background-size: 300% 300%;
  backdrop-filter: blur(1rem);
  border-radius: 5rem;
  transition: 0.5s;
  animation: gradient_301 5s ease infinite;
  border: double 4px transparent;
  background-image: linear-gradient(#212121, #212121),
  linear-gradient(137.48deg, #ffdb3b 10%, #fe53bb 45%, #8f51ea 67%, #0044ff 87%);
  background-origin: border-box;
  background-clip: content-box, border-box;
}

#container-stars {
  position: fixed;
  z-index: -1;
  width: 100%;
  height: 100%;
  overflow: hidden;
  transition: 0.5s;
  backdrop-filter: blur(1rem);
  border-radius: 5rem;
}

strong {
  z-index: 2;
  font-size: 16px;
  color: #ffffff;
  text-shadow: 0 0 4px white;
}

#glow {
  position: absolute;
  display: flex;
  width: 12rem;
}

.circle {
  width: 100%;
  height: 30px;
  filter: blur(2rem);
  animation: pulse_3011 4s infinite;
  z-index: -1;
}

.circle:nth-of-type(1) {
  background: rgba(254, 83, 186, 0.636);
}

.circle:nth-of-type(2) {
  background: rgba(142, 81, 234, 0.704);
}

.btn:hover #container-stars {
  z-index: 1;
  background-color: #212121;
}

.btn:hover {
  transform: scale(1.1);
}

.btn:active {
  border: double 4px #fe53bb;
  background-origin: border-box;
  background-clip: content-box, border-box;
  animation: none;
}

.btn:active .circle {
  background: #fe53bb;
}

#stars {
  position: relative;
  background: transparent;
  width: 200rem;
  height: 200rem;
}

#stars::after {
  content: '';
  position: absolute;
  top: -10rem;
  left: -100rem;
  width: 100%;
  height: 100%;
  animation: animStarRotate 90s linear infinite;
}

#stars::after {
  background-image: radial-gradient(#ffffff 1px, transparent 1%);
  background-size: 50px 50px;
}

#stars::before {
  content: '';
  position: absolute;
  top: 0;
  left: -50%;
  width: 170%;
  height: 500%;
  animation: animStar 60s linear infinite;
}

#stars::before {
  background-image: radial-gradient(#ffffff 1px, transparent 1%);
  background-size: 50px 50px;
  opacity: 0.5;
}

@keyframes animStar {
  from {
    transform: translateY(0);
  }

  to {
    transform: translateY(-135rem);
  }
}

@keyframes animStarRotate {
  from {
    transform: rotate(360deg);
  }

  to {
    transform: rotate(0);
  }
}

@keyframes gradient_301 {
  0% {
    background-position: 0% 50%;
  }

  50% {
    background-position: 100% 50%;
  }

  100% {
    background-position: 0% 50%;
  }
}

@keyframes pulse_3011 {
  0% {
    transform: scale(0.75);
    box-shadow: 0 0 0 0 rgba(0, 0, 0, 0.7);
  }

  70% {
    transform: scale(1);
    box-shadow: 0 0 0 10px rgba(0, 0, 0, 0);
  }

  100% {
    transform: scale(0.75);
    box-shadow: 0 0 0 0 rgba(0, 0, 0, 0);
  }
}
</style>
