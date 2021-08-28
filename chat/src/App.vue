<template>
  <div id="app">
    <!--        <welcome></welcome>-->
    <div class="outter" :class="{'hideLeft':$route.path.split('/').length>2}">
      <!--通用头部-->
      <header class="app-header" :class="{'header-hide':!$store.state.headerStatus}">
        <!--复兴性高，数据交互比较频繁-->
        <div id="wx-header">
          <!--右上角图标-->
          <div class="other">
            <!--只在“微信”页显示 更多图标-->
            <span class="iconfont icon-tips-jia" v-show="$route.path==='/'" v-on:click="$store.commit('toggleTipsStatus')"></span>
            <!--只在“通讯录”页显示 显示添加好友图标-->
            <router-link tag="span" to="/contact/add-friend" class="iconfont icon-tips-add-friend" v-show="$route.path==='/contact'"></router-link>
            <!--只在“添加朋友”页显示 -->
            <span v-show="$route.path==='/contact/new-friends'">添加朋友</span>
            <!--下面这个好像有些多余 sad -->
            <span class="iconfont icon-chat-friends" v-show="$route.path==='/wechat/dialogue'"></span>
            <!-- 更多图标的菜单 附带过渡效果-->
            <ul class="tips-menu" :class="[$store.state.tipsStatus?'tips-open':'tips-close']" v-on:click="$store.commit('toggleTipsStatus', -1)">
              <li><span class="iconfont icon-tips-xiaoxi"></span><div>发起群聊</div></li>
              <router-link tag="li" to="/wehchat/add-friend">
                <span class="iconfont icon-tips-add-friend"></span>
                <div>添加朋友</div>
              </router-link>
              <li> <span class="iconfont icon-tips-saoyisao"></span><div>扫一扫</div></li>
              <li> <span class="iconfont icon-tips-fukuan"></span><div>收付款</div></li>
            </ul>
            <!--<div class="tips-masker" v-show="tips_isOpen"></div>-->
          </div>
          <div class="center">
            <!--显示当前页的名字-->
            <span>{{$store.state.currentPageName}}</span>
            <!--微信群 显示群名以及成员人数 好像和 dialogue 组件 写重了 sad -->
            <span class="parentheses" v-show='$route.query.group_num&&$route.query.group_num!=1'>{{$route.query.group_num}}</span>
          </div>
        </div>
      </header>
      <!--搜索框 只在“微信”和“通讯录”页面下显示-->
      <div id="search" v-show="$route.path.indexOf('explore')===-1&&$route.path.indexOf('self')===-1" :class="{'search-open':!$store.state.headerStatus}">
        <div class="weui-search-bar" id="search_bar" :class="{'weui-search-bar_focusing':!$store.state.headerStatus}">
          <form class="weui-search-bar__form">
            <div class="weui-search-bar__box">
              <i class="weui-icon-search"></i>
              <input type="search" v-model="searchIpt" class="weui-search-bar__input" id="search_input" placeholder="搜索" @focus="closeHeader"/>
              <a class="weui-icon-clear" v-on:click="searchClear"></a>
            </div>
            <label for="search_input" class="weui-search-bar__label" id="search_text">
              <i class="weui-icon-search"></i>
              <span>搜索</span>
            </label>
          </form>
          <a class="weui-search-bar__cancel-btn" id="search_cancel" v-on:click="$store.commit('toggleHeaderStatus',true)">取消</a>
        </div>
        <article>
          <h3 class="weui-media-box__desc">搜索指定内容</h3>
          <div class="tag"><span>朋友圈</span><span>文章</span><span>公众号</span><span>小说</span><span>音乐</span><span>表情</span></div>
          <div class="weui-cells">
            <a class="weui-cell weui-cell_access" href="javascript:;">
              <div class="weui-cell__hd"><img src="./assets/images/book.png" alt="" style="width:20px;margin-right:5px;display:block"></div>
              <div class="weui-cell__bd"><p>朋友圈热文</p></div>
              <div class="weui-cell__ft"></div>
            </a>
          </div>
        </article>
      </div>
      <!--四个门面页 “微信” “通讯录” “发现” “我”-->
      <section class="app-content">
        <keep-alive>
          <router-view name="default" ></router-view>
        </keep-alive>
      </section>
      <!--底部导航 路由 -->
      <footer class="app-footer">
        <div id="wx-nav">
          <nav>
            <router-link to="/" tag="dl" exact>
              <dt class="iconfont icon-wechat" >
                <i class="new-msg-count" v-show="$store.state.newMsgCount">{{$store.state.newMsgCount}}</i>
              </dt>
              <dd>微信</dd>
            </router-link>
            <router-link to="/contact" tag="dl">
              <dt class="iconfont icon-contact" ></dt>
              <dd>通讯录</dd>
            </router-link>
            <router-link to="/explore" tag="dl">
              <dt class="iconfont icon-find" >
                <i class="new-msg-dot"></i>
              </dt>
              <dd>发现</dd>
            </router-link>
            <router-link to="/self" tag="dl">
              <dt class="iconfont icon-me" >
              </dt>
              <dd>我</dd>
            </router-link>
          </nav>
        </div>
      </footer>
    </div>
    <transition name="custom-classes-transition" :enter-active-class="enterAnimate" :leave-active-class="leaveAnimate">
      <router-view name="subPage" class="sub-page"></router-view>
    </transition>
  </div>
</template>

<script>
const mixin = {
  mounted() {
    this.$store.commit("setPageName", this.pageName)
    // console.log('全局混合mounted')
  },
  activated() {
    this.$store.commit("setPageName", this.pageName)
    // console.log('全局混合activated')
  }
}
window.mixin = mixin
export default {
  name: 'app',
  data() {
    return {
      chatCount: true,
      searchIpt: "",
      "pageName": "",
      "routerAnimate": false,
      "enterAnimate": "", //页面进入动效
      "leaveAnimate": "" //页面离开动效
    }
  },
  watch: {
    // 监听 $route 为店内页设置不同的过渡效果
    "$route" (to, from) {
      const toDepth = to.path.split('/').length
      const fromDepth = from.path.split('/').length
      if (toDepth === 2) {
        this.$store.commit("setPageName", to.name)
      }
      //同一级页面无需设置过渡效果
      if (toDepth === fromDepth) {
        return;
      }
      this.enterAnimate = toDepth > fromDepth ? "animated fadeInRight" : "animated fadeInLeft"
      this.leaveAnimate = toDepth > fromDepth ? "animated fadeOutLeft" : "animated fadeOutRight"
      // 从店面页进入店内页 需要对店内页重新设置离开动效 因为他们处于不同 name 的 router-view
      if (toDepth === 3) {
        this.leaveAnimate = "animated fadeOutRight"
      }
    }
  },
  mounted() {
    for (var i in this.$store.state.msgList.baseMsg) {
      if (this.$store.state.msgList.baseMsg[i].read === false && this.$store.state.msgList.baseMsg[i].quiet === false) {
        this.$store.commit('addNewMsg')
      }
    }
  },
  methods: {
    // wx-header 隐藏
    closeHeader() {
      if (this.$store.state.headerStatus) {
        this.$store.commit('toggleHeaderStatus', false)
      }
    },
    // 清除输入的内容 可以直接写 v-on:click="searchIpt=''"
    searchClear() {
      this.searchIpt = ""
    },
    goBack() {
      this.$router.go(-1)
      //保证返回操作后正确显示页面名称
      // this.$store.commit("setPageName", this.$store.state.backPageName)
    }
  }
}
</script>
<style lang="less">
@import "assets/css/common.css";
#wx-header {
  position: relative;
  z-index: 99;
  // overflow: hidden;
  height: 45px;
  // font-size: 15px;
  padding: 0 15px 0 10px;
  line-height: 45px;
  background: #1b1b1b;
  opacity: 1;
  color: #fff;
  user-select: none;
  -webkit-user-select: none;
  transition: all 0.3s linear;
  .center {
    margin: 0 auto;
    text-align: center;
    font-size: 17px;
    span {
      font-family: Helvetica Neue, Helvetica, PingFang SC, Hiragino Sans GB, Microsoft YaHei, Noto Sans CJK SC, WenQuanYi Micro Hei, Arial, sans-serif
    }
    .icon-return-arrow {
      left: 10px;
      position: absolute;
      font-size: 16px;
    }
  }
  .other {
    position: absolute;
    cursor: pointer;
    right: 10px;
    &>span {
      font-size: 16px;
      display: inline-block;
    }
    &>.iconfont {
      font-size: 22px;
      width: 40px;
      text-align: center;
    }
    .tips-masker {
      position: fixed;
      left: 0;
      width: 100%;
      z-index: 1;
      top: 45px;
      bottom: 50px;
    }
    .tips-menu {
      position: absolute;
      z-index: 2;
      width: 133px;
      font-size: 16px;
      right: 0;
      top: 54px;
      text-align: left;
      border-radius: 2px;
      background-color: #49484b;
      padding: 0 15px;
      -webkit-transform-origin: 90% 0%;
      transform-origin: 90% 0%;
    }
  }
  .tips-open {
    -webkit-transition: initial;
    transition: initial;
    opacity: 1;
  }
  .tips-close {
    opacity: 0;
    -webkit-transition: .2s opacity ease, .6s transform ease;
    transition: .2s opacity ease, .6s transform ease;
    -webkit-transform: scale(0);
    transform: scale(0);
  }
  .other .tips-menu {
    li {
      position: relative;
      height: 40px;
      line-height: 40px;
      &:not(:last-child)::after {
        content: "";
        width: 200%;
        position: absolute;
        bottom: 0;
        left: 0;
        height: 1px;
        background-color: #5b5b5d;
        -webkit-transform: scale(0.5);
        transform: scale(0.5);
        -webkit-transform-origin: 0 100%;
        transform-origin: 0 100%;
      }
    }
    &::before {
      width: 0;
      height: 0;
      position: absolute;
      top: -7px;
      right: 15px;
      content: "";
      border-width: 0 6px 8px;
      border-color: rgba(0, 0, 0, 0) rgba(0, 0, 0, 0) #49484b rgba(0, 0, 0, 0);
      border-style: solid;
    }
    .iconfont {
      float: left;
      font-size: 16px;
      margin-right: 15px;
    }
  }
}
#search {
  position: relative;
  .weui-search-bar__label {
    line-height: 1.8
  }
  &.search-open {
    z-index: 10;
    height: 100%;
    width: 100%;
    transition: 0.3s;
    article {
      display: block;
    }
  }
  input {
    font-family: Helvetica Neue, Helvetica, PingFang SC, Hiragino Sans GB, Microsoft YaHei, Noto Sans CJK SC, WenQuanYi Micro Hei, Arial, sans-serif;
  }
  article {
    background: #eee;
    position: absolute;
    height: 800px;
    display: none;
    z-index: 3;
    overflow: hidden;
    padding-top: 30px;
    width: 100%;
    opacity: 0.99;
    h3 {
      text-align: center;
    }
    .tag {
      margin: 20px 0;
      span {
        font-size: 14px;
        text-align: center;
        width: 33.33%;
        display: inline-block;
        box-sizing: border-box;
        color: #09bb07;
        border-right: 1px solid rgba(220, 220, 220, 0.67);
        margin-bottom: 15px;
        &:nth-child(3n) {
          border-right-color: transparent;
        }
      }
    }
    .weui-cells {
      background-color: transparent;
      width: 85%;
      margin: 0 auto;
      .weui-cell {
        padding: 15px;
      }
      .weui-cell__hd {
        img {
          width: 16px;
        }
      }
      .weui-cell__bd {
        color: #999;
        font-size: 13px;
      }
    }
  }
  .weui-search-bar__label {
    transition: 0.3s;
  }
  .weui-search-bar_focusing {
    .weui-search-bar__label {
      // transition: 0.1s;
      display: block;
      transform: translate3d(-100%, 0, 0);
      opacity: 0.0;
    }
  }
}
#wx-nav {
  nav {
    display: -webkit-box;
    display: -ms-flexbox;
    display: flex;
    width: 100%;
    overflow: hidden;
    height: 50px;
    padding-top: 8px;
    background: #f9f9f9;
    font-size: 12px;
    dl {
      cursor: pointer;
      -moz-user-select: none;
      -ms-user-select: none;
      user-select: none;
      -webkit-user-select: none;
      -webkit-box-flex: 1;
      -ms-flex-positive: 1;
      flex-grow: 1;
      text-align: center;
      line-height: 1;
      &.router-link-active {
        dd,
        dt {
          color: #0bb908;
        }
      }
    }
    dt {
      position: relative;
      width: 28px;
      height: 28px;
      margin: 0 auto;
      font-size: 28px;
      color: #797979;
      margin-bottom: 2px;
    }
    dd {
      color: #929292;
      -webkit-transform-origin: 50% 0;
      transform-origin: 50% 0;
      -webkit-transform: scale(0.9);
      transform: scale(0.9);
    }
  }
}
/*阿里 fonticon*/

@import "assets/css/lib/iconfont.css";
/*过渡效果需要的动画库*/

@import "assets/css/lib/animate.css";
/*weui 样式库 非常适合高仿微信*/

@import "assets/css/lib/weui.min.css";
</style>