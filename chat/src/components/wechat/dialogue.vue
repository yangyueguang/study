<template>
  <div class="dialogue">
    <header id="wx-header">
      <div class="other">
        <router-link :to="{path:'/wechat/dialogue/dialogue-info',query: { msgInfo: msgInfo}}" tag="span"
                     class="iconfont icon-chat-group" v-show="$route.query.group_num&&$route.query.group_num!=1">
        </router-link>
        <router-link :to="{path:'/wechat/dialogue/dialogue-detail',query: { msgInfo: msgInfo}}" tag="span"
                     class="iconfont icon-chat-friends" v-show="$route.query.group_num==1"></router-link>
      </div>
      <div class="center">
        <router-link to="/" tag="div" class="iconfont icon-return-arrow">
          <span>微信</span>
        </router-link>
        <span>{{pageName}}</span>
        <span class="parentheses" v-show='$route.query.group_num&&$route.query.group_num!=1'>{{$route.query.group_num}}</span>
      </div>
    </header>
    <section class="dialogue-section clearfix" v-on:click="MenuOutsideClick">
      <div class="row clearfix" v-for="(item,index) in msgInfo.msg" :key="index">
        <img :src="item.headerUrl" class="header">
        <p class="text" v-more>{{item.text}}</p>
      </div>
      <span class="msg-more" id="msg-more">
        <ul><li>复制</li><li>转发</li><li>收藏</li><li>删除</li></ul>
      </span>
    </section>
    <footer :class=" {footshow : clickmore}" >
      <div class="component-dialogue-bar-person">
        <span class="iconfont icon-dialogue-jianpan" v-show="!currentChatWay" v-on:click="currentChatWay=true"></span>
        <span class="iconfont icon-dialogue-voice" v-show="currentChatWay" v-on:click="currentChatWay=false"></span>
        <div class="chat-way" v-show="!currentChatWay">
          <div class="chat-say" v-press>
            <span class="one">按住 说话</span>
            <span class="two">松开 结束</span>
          </div>
        </div>
        <div class="chat-way" v-show="currentChatWay">
          <input class="chat-txt" type="text" v-on:focus="focusIpt" v-on:blur="blurIpt" />
        </div>
        <span class="expression iconfont icon-dialogue-smile"></span>
        <span class="more iconfont icon-dialogue-jia" @click="clickmore=!clickmore"></span>
        <div class="recording" style="display: none;" id="recording">
          <div class="recording-voice" style="display: none;" id="recording-voice">
            <div class="voice-inner">
              <div class="voice-icon"></div>
              <div class="voice-volume">
                <span></span><span></span><span></span><span></span><span></span>
                <span></span><span></span><span></span><span></span>
              </div>
            </div>
            <p>手指上划,取消发送</p>
          </div>
          <div class="recording-cancel" style="display: none;">
            <div class="cancel-inner"></div><p>松开手指,取消发送</p>
          </div>
        </div>
      </div>
      <section class="foot_bottom">
        <div class="swiper-container">
          <div class="swiper-wrapper">
            <div class="swiper-slide" v-for="(value,item) in chatData" :key="item">
              <ul class="clear">
                <li v-for="value in value" :key="value">
                  <div class="swiper_svg"><div class="iconfont icon-chat-friends"></div></div>
                  <div class="swiper_text">{{ value.chatSvgname }}</div>
                </li>
              </ul>
            </div>
          </div>
          <div class="swiper-pagination"></div>
        </div>
      </section>
    </footer>
  </div>
</template>
<script>

const chatData = {
  0:[{
    "chatSvgid":"#personimg",
    "chatSvgname":"相册"
  },
    {
      "chatSvgid":"#shot",
      "chatSvgname":"拍摄"
    },
    {
      "chatSvgid":"#camera",
      "chatSvgname":"视频聊天"
    },
    {
      "chatSvgid":"#positions",
      "chatSvgname":"位置"
    },
    {
      "chatSvgid":"#redbag",
      "chatSvgname":"红包"
    },
    {
      "chatSvgid":"#banktransfer",
      "chatSvgname":"转账"
    },
    {
      "chatSvgid":"#person",
      "chatSvgname":"名片"
    },
    {
      "chatSvgid":"#voiceinput",
      "chatSvgname":"语音输入"
    },],
  1:[
    {
      "chatSvgid":"#wxcollect",
      "chatSvgname":"我的收藏"
    },
  ]
}
export default {
  sockets: {
    connect: function () {
      console.log('socket to notification channel connected')
    },
  },
  data() {
    return {
      chatData: chatData,
      clickmore: false,
      pageName: this.$route.query.name,
      currentChatWay: true, //ture为键盘打字 false为语音输入
      timer: null
      // sayActive: false // false 键盘打字 true 语音输入
    }
  },
  beforeRouteEnter(to, from, next) {
    next(vm => {
      vm.$store.commit("setPageName", vm.$route.query.name)
    })
  },
  computed: {
    msgInfo() {
      for (var i in this.$store.state.msgList.baseMsg) {
        if (this.$store.state.msgList.baseMsg[i].mid == this.$route.query.mid) {
          return this.$store.state.msgList.baseMsg[i]
        }
      }
      return {}
    }
  },
  mounted() {
    this.sockets.subscribe("chat", (data) => {
      console.log("浏览器收到了消息：", data)
      this.groupconversine.push(data);
      this.$nextTick(()=>{
        window.scrollTo(0,this.$refs.groupHeight.offsetHeight-window.innerHeight)
      })
    })
  },
  beforeDestroy(){
    this.$socket.removeAllListeners();
  },
  directives: {
    press: {
      inserted(element) {
        var recording = document.querySelector('.recording'),
            recordingVoice = document.querySelector('.recording-voice'),
            recordingCancel = document.querySelector('.recording-cancel'),
            startTy
        element.addEventListener('touchstart', function (e) {
          element.className = "chat-say say-active"
          recording.style.display = recordingVoice.style.display = "block"
          var touches = e.touches[0]
          startTy = touches.clientY
          e.preventDefault()
        }, false)
        element.addEventListener('touchend', function (e) {
          element.className = "chat-say"
          recordingCancel.style.display = recording.style.display = recordingVoice.style.display = "none"
          e.preventDefault()
        }, false)
        element.addEventListener('touchmove', function (e) {
          var touches = e.changedTouches[0],
              endTy = touches.clientY,
              distanceY = startTy - endTy;
          if (distanceY > 50) {
            element.className = "chat-say"
            recordingVoice.style.display = "none"
            recordingCancel.style.display = "block"
          } else {
            element.className = "chat-say say-active"
            recordingVoice.style.display = "block"
            recordingCancel.style.display = "none"
          }
          e.preventDefault()
        }, false);
      }
    },
    more: {
      bind(element) {
        var startTx, startTy
        element.addEventListener('touchstart', function (e) {
          var msgMore = document.getElementById('msg-more'),
              touches = e.touches[0];
          startTx = touches.clientX
          startTy = touches.clientY
          clearTimeout(this.timer)
          this.timer = setTimeout(() => {
            msgMore.style.left = ((startTx - 18) > 180 ? 180 : (startTx - 18)) + 'px'
            msgMore.style.top = (element.offsetTop - 33) + 'px'
            msgMore.style.display = "block"
            element.style.backgroundColor = '#e5e5e5'
          }, 500)
        }, false)
        element.addEventListener('touchmove', function (e) {
          var touches = e.changedTouches[0],
              disY = touches.clientY;
          if (Math.abs(disY - startTy) > 10) {
            clearTimeout(this.timer)
          }
        }, false)
        element.addEventListener('touchend', function () {
          clearTimeout(this.timer)
        }, false)
      }
    }
  },
  methods: {
    focusIpt() {
      this.timer = setInterval(function () {
        document.body.scrollTop = document.body.scrollHeight
      }, 100)
    },
    blurIpt() {
      clearInterval(this.timer)
      this.$socket.emit('chat', {});
    },
    // 点击空白区域，菜单被隐藏
    MenuOutsideClick(e) {
      var container = document.querySelectorAll('.text'),
          msgMore = document.getElementById('msg-more')
      if (e.target.className !== 'text') {
        msgMore.style.display = 'none'
        container.forEach(item => item.style.backgroundColor = '#fff')
      }
    }
  }
}
</script>
<style lang="less">
html,
body,
div,
span,
applet,
object,
iframe,
h1,
h2,
h3,
h4,
h5,
h6,
p,
blockquote,
pre,
a,
abbr,
acronym,
address,
big,
cite,
code,
del,
dfn,
em,
img,
ins,
kbd,
q,
s,
samp,
small,
strike,
sub,
sup,
tt,
var,
u,
i,
center,
dl,
dt,
dd,
ol,
ul,
li,
fieldset,
form,
label,
legend,
table,
caption,
tbody,
tfoot,
thead,
tr,
th,
td,
article,
aside,
canvas,
details,
embed,
figure,
figcaption,
footer,
header,
hgroup,
menu,
nav,
output,
ruby,
section,
summary,
time,
mark,
audio,
video {
  margin: 0;
  padding: 0;
  border: 0;
  font-size: 100%;
  font: inherit;
  vertical-align: baseline;
  -webkit-user-select: none;
  user-select: none;
  -webkit-tap-highlight-color: transparent;
}
a[href^="javascript"]{-webkit-touch-callout: none;}

article,
aside,
details,
figcaption,
figure,
footer,
header,
hgroup,
menu,
nav,
section {
  display: block;
}

body {
  line-height: 1;
}

ol,
ul {
  list-style: none;
}

blockquote,
q {
  quotes: none;
}

blockquote:before,
blockquote:after,
q:before,
q:after {
  content: ' ';
  content: none;
}

table {
  border-collapse: collapse;
  border-spacing: 0;
}

body {
  font: 13px/1.5 Helvetica Neue, Helvetica, PingFang SC, Hiragino Sans GB, Microsoft YaHei, Noto Sans CJK SC, WenQuanYi Micro Hei, Arial, sans-serif;
}

h1,
h2,
h3,
h4,
h5,
h6 {
  font-weight: normal;
}

input {
  outline: 0;
}

.hidden {
  float: left;
  width: 0;
  height: 0;
  overflow: hidden;
}

.hiddenText {
  text-indent: 100%;
  white-space: nowrap;
  overflow: hidden;
}

.none {
  display: none;
}

.bold {
  font-weight: bold;
}

.center {
  text-align: center;
}

.clearfix:before,
.clearfix:after {
  content: "";
  display: table;
}

.clearfix:after {
  clear: both;
}

.clearfix {
  zoom: 1;
}

table {
  margin-left: 1px;
}

table td,
table th {
  padding: 5px 10px;
  border: 1px solid #ccc;
  vertical-align: middle;
}

a {
  text-decoration: none;
  color: #000;
}

* {
  box-sizing: border-box;
}
.foot_bottom{
  height:11.712rem;
  border-top:1px solid #e0e0e0;
  .swiper-container{
    width:100%;
    height:11.712rem;
    overflow:hidden;
    .swiper-slide{
      width:100%;
      ul{
        padding:1.408rem 1.1946666667rem 0;
        box-sizing:border-box;
        li{
          float:left;
          width:2.5466666667rem;
          margin-right:1rem;
          margin-bottom:1.1946666667rem;
          .swiper_svg{
            width: 2.6rem;
            height: 2.6rem;
            background:#fcfcfc;
            border:1px solid #d3d3d3;
            border-radius:10px;
            display: flex;
            justify-content: center;
            align-items:center;
            div{
              width: 1.2rem;
              height: 1rem;
              display:block;
            }
          }
          .swiper_text{
            width:100%;
            margin-top:0.256rem;
            text-align:center;
            font-size: 0.5rem;
            color: #7a8187;
          }
        }
        li:nth-of-type(4n+4){
          margin-right:0;
        }
      }
    }
  }
}
.footshow{
  bottom:0;
  transition: all .2s;
}
.dialogue-section {
  height: 100%;
  background: url("https://sinacloud.net/vue-wechat/images/bg/alarm.png");
  background-size: 100%;
  padding: 2%;

  .row {
    width: 80%;
    margin-top: 30px;
    margin-bottom: -10px;

    .header {
      width: 35px;
      float: left;
      display: block;
    }

    .text {
      float: left;
      /* line-height: 40px; */
      background: #fff;
      /* display: block; */
      padding: 8px;
      box-sizing: border-box;
      /* height: 40px; */
      margin-left: 10px;
      position: relative;
      border-radius: 4px;
      max-width: 80%;
      font-size: 14px;

      &:before {
        width: 0;
        height: 0;
        position: absolute;
        left: -12px;
        top: 11px;
        content: "";
        border: 6px solid transparent;
        border-right-color: #fff;
      }
    }
  }

  .msg-more {
    position: absolute;
    display: none;
    width: 190px;
    padding: 3px;
    left: 0;
    background: #000;
    color: #fff;
    top: 20px;
    left: 20px;
    border-radius: 4px;

    &:after {
      width: 0;
      height: 0;
      position: absolute;
      left: 18px;
      top: 25px;
      content: "";
      border: 6px solid transparent;
      border-top-color: #000;
    }

    ul {
      li {
        float: left;
        width: 46px;
        /* margin-right: 1px; */
        border-right: 1px solid #fff;
        text-align: center;

        &:last-child {
          border-right-width: 0;
        }
      }
    }
  }
}

.dialogue-section-inner {
  width: 100%;
  height: 100%;
  padding: 0 10px;
  overflow: auto;
}

footer {
  width: 100%;
  position: fixed;
  left: 0;
  bottom:-11.712rem;
}


/*dialogue-bar*/

.component-dialogue-bar {
  position: relative;
  height: 100%;
  padding-left: 50px;
}

.component-dialogue-bar .dialogue-item {
  position: absolute;
  height: 50px;
  bottom: 0;
  left: 0;
  width: 100%;
  transition: .25s all ease;
  background-color: #fdfdfd;
}

.component-dialogue-bar .dialogue-item::before {
  content: "";
  position: absolute;
  width: 200%;
  left: 0;
  top: 0;
  transform: scale(.5);
  transform-origin: 0 0;
  -webkit-transform: scale(.5);
  -webkit-transform-origin: 0 0;
  background-color: #b7b7b7;
  height: 1px;
  z-index: 2;
}

.component-dialogue-bar .dialogue-item::after {
  content: "";
  position: absolute;
  left: 50px;
  top: 0px;
  border-right: 1px solid #b7b7b7;
  height: 200%;
  transform: scale(.5);
  transform-origin: 0 0;
  z-index: 2;
}

.component-dialogue-bar .dialogue-item.transition-dialogue-down {
  bottom: -50px;
}

.left-slide-type {
  float: left;
  width: 50px;
  height: 100%;
  padding: 5px 0;
  text-align: center;
  font-size: 30px;
  line-height: 40px;
  color: #7d7e83;
  position: relative;
}

.component-dialogue-bar-person {
  overflow: hidden;
  padding: 5px 0;
  height: 100%;
  flex-grow: 1;
  flex-basis: 200px;
  display: flex;
  justify-content: flex-start;
  align-items: flex-start;
  position: relative;
  background-color: #ffffff;
}

.component-dialogue-bar-person::before {
  content: "";
  position: absolute;
  width: 200%;
  left: 0;
  top: 0;
  transform: scale(.5);
  transform-origin: 0 0;
  -webkit-transform: scale(.5);
  -webkit-transform-origin: 0 0;
  background-color: #b7b7b7;
  height: 1px;
  z-index: 2;
}

.component-dialogue-bar .component-dialogue-bar-person::before {
  display: none;
}

.component-dialogue-bar-person .iconfont {
  color: #7d7e83;
  flex-basis: 40px;
  width: 40px;
  padding: 0 3px;
  font-size: 30px;
  flex-grow: 0;
  vertical-align: middle;
  line-height: 40px;
  padding: 0 4px;
}

.chat-way {
  vertical-align: middle;
  padding: 4px 0px;
  height: 100%;
  flex-grow: 1;
  flex-basis: 200px;
}

.chat-way .chat-say {
  display: flex;
  justify-content: center;
  align-items: center;
  border-radius: 6px;
  overflow: hidden;
  padding: 0 10px;
  width: 200%;
  height: 200%;
  color: #565656;
  border: 1px solid #7d7e83;
  transform: scale(.5);
  transform-origin: 0 0;
  font-size: 30px;
}

.chat-way .chat-say_touched {
  background-color: #c6c7ca;
}

.chat-way .two {
  display: none;
}

.chat-way .chat-say_touched .two {
  display: block;
}

.chat-way .chat-say_touched .one {
  display: none;
}

.chat-way .chat-txt {
  border-radius: 6px;
  overflow: hidden;
  padding: 0 10px;
  width: 200%;
  height: 200%;
  border: 1px solid #7d7e83;
  transform: scale(.5);
  transform-origin: 0 0;
  font-size: 30px;
}

.component-dialogue-bar-public {
  height: 100%;
  display: flex;
  position: relative;
  overflow: hidden;
}

.component-dialogue-bar-public li {
  padding: 0 2px;
  overflow: hidden;
  flex-grow: 1;
  flex-shrink: 0;
  line-height: 50px;
  flex-basis: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative;
}

.component-dialogue-bar-public li .iconfont {
  font-size: 12px;
}

.component-dialogue-bar-public li:not(:last-child)::before {
  content: "";
  position: absolute;
  right: 0;
  top: 0;
  transform-origin: 0 0;
  transform: scale(.5);
  height: 200%;
  border-right: 1px solid #b7b7b7;
}

.recording {
  position: fixed;
  left: 50%;
  top: 45%;
  transform: translate(-50%, -50%);
  width: 140px;
  height: 140px;
  padding: 5px;
  background-color: rgba(0, 0, 0, .5);
  color: #ffffff;
  border-radius: 5px;
  font-size: 14px;
  text-align: center;
}

.recording-voice .voice-inner {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 110px;
}

.voice-inner .voice-icon {
  width: 55px;
  height: 90px;
  background: url(../../assets/images/recording-bkg.png) no-repeat center center;
  background-size: contain;
}

.voice-inner .voice-volume {
  width: 30px;
  height: 55px;
}

.voice-inner .voice-volume span {
  display: block;
  height: 2px;
  margin-top: 4px;
  min-width: 8px;
  float: left;
  clear: both;
  animation-iteration-count: infinite;
  animation-timing-function: linear;
  animation-duration: 2000ms;
  background-color: #e4e4e5;
}

.voice-inner .voice-volume span:nth-child(1) {
  width: 24px;
  visibility: hidden;
}

.voice-inner .voice-volume span:nth-child(2) {
  width: 22px;
}

.voice-inner .voice-volume span:nth-child(3) {
  width: 20px;
}

.voice-inner .voice-volume span:nth-child(4) {
  width: 18px;
}

.voice-inner .voice-volume span:nth-child(5) {
  width: 16px;
}

.voice-inner .voice-volume span:nth-child(6) {
  width: 14px;
}

.voice-inner .voice-volume span:nth-child(7) {
  width: 12px;
}

.voice-inner .voice-volume span:nth-child(8) {
  width: 10px;
}

.voice-inner .voice-volume span:nth-child(9) {
  width: 8px;
}

.recording-cancel p {
  border-radius: 3px;
  background-color: #9d383e;
}

.cancel-inner {
  width: 110px;
  height: 110px;
  margin: 0 auto;
  background-image: url(../../assets/images/record-cancel.png);
  background-repeat: no-repeat;
  background-position: center center;
  background-size: contain;
}
.say-active {
  background: #c6c7ca;
}
</style>