<template>
  <!--我的群聊组件-->
  <div :class="{'search-open-contact':!$store.state.headerStatus}">
    <header id="wx-header">
      <div class="center">
        <router-link to="/contact" tag="div" class="iconfont icon-return-arrow">
          <span>通讯录</span>
        </router-link>
        <span>群聊</span>
      </div>
    </header>
    <div id="search" :class="{'search-open':!$store.state.headerStatus}">
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
            <div class="weui-cell__hd"><img src="../../assets/images/book.png" alt="" style="width:20px;margin-right:5px;display:block"></div>
            <div class="weui-cell__bd">
              <p>朋友圈热文</p>
            </div>
            <div class="weui-cell__ft"></div>
          </a>
        </div>
      </article>
    </div>
    <section class="weui-cells">
      <template v-for="(groupInfo,index) in groupList">
        <a class="weui-cell weui-cell_access" :key="index">
          <div class="weui-cell__hd header-box">
            <div class="header multi-header">
              <img v-for="(user,index) in groupInfo.user" :key="index" :src="user.headerUrl">
            </div>
          </div>
          <div class="weui-cell__bd">
            <p>{{groupInfo.group_name}}</p>
          </div>
        </a>
      </template>
    </section>
  </div>
</template>
<script>
export default {
  data() {
    return {
      searchIpt: ""
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
    }
  },
  computed: {
    // 从消息数据中提取出群聊列表 不严谨 应该新建 groups.js，存放所有群聊数据
    groupList() {
      var temp = []
      for (var i in this.$store.state.msgList.baseMsg) {
        if (this.$store.state.msgList.baseMsg[i].type === 'group') {
          temp.push(this.$store.state.msgList.baseMsg[i])
        }
      }
      return temp
    }
  }
}
</script>
<style lang="less">
.header-box {
  position: relative;
  float: left;
  width: 38px;
  height: 38px;
  margin-right: 10px;
}

.header-box .header {
  height: 100%;
  display: flex;
  display: -webkit-flex;
  flex-direction: row;
  flex-wrap: wrap;
  align-items: flex-start;
  overflow: hidden;
  background: #dddbdb;
}

.header-box .header img {
  width: 10%;
  height: auto;
  flex-grow: 2;
  border: 0;
}

.multi-header img {
  margin: 1px;
}
#search {
  position: relative;
  .weui-search-bar__label {
    line-height: 1.8
  }
  &.search-open {
    // position: absolute;
    // top: 50px;
    z-index: 10;
    // bottom: 0;
    height: 100%;
    width: 100%;
    // margin-top: -45px;
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
</style>