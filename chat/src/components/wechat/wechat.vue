<template>
  <div id="wechat">
    <ul class="wechat-list">
      <!-- 电脑登录 -->
      <section class="computer" v-if="computershow">
        <router-link to='/computer' class="computer_link">
          <section class="computer_icon"><div class="iconfont icon-wechat"></div></section>
          <section class="computer_text">Windows 微信已登录<span v-if="mute">， 手机通知已关闭</span></section>
        </router-link>
      </section>
        <msg-item v-for="baseMsgObj in $store.state.msgList.baseMsg" :item="baseMsgObj" class="list-row line-bottom" :key="baseMsgObj.mid"></msg-item>
    </ul>
  </div>
</template>
<script>
    import msgItem from "../wechat/msg-item"
    export default {
        components: {
            msgItem
        },
        mixins: [window.mixin],
        data() {
            return {
              computershow: true,
                "pageName": "微信"
            }
        }
    }
</script>
<style lang="less">
.computer {
  height: 2.5rem;
  background: #f5f5f5;
  border-bottom: 1px solid #e0e0e0;
  .computer_link {
    display: flex;
    justify-content: flex-start;
    .computer_icon {
      width: 1.3rem;
      height: 1.9rem;
      margin-left: 1.0666666667rem;
      margin-right: 0.96rem;
    }
    .computer_text {
      line-height: 1.9626666667rem;
      font-size: 0.5rem;
      color: #474747;
      span {
        display: inline-block;
        font-size: 0.5rem;
        color: #474747;
      }
    }
  }
}
#wechat {
  .wechat-list {
    position: relative;
    overflow-x: hidden;
    z-index: 1;
    .list-row {
      height: 64px;
      position: relative;
      overflow: hidden;
      &.item-hide {
        transition: 0.3s;
        height: 0px;
        &:after {
          content: "";
          position: absolute;
          z-index: 2;
          top: 1px;
          bottom: 1px;
          width: 100%;
          background: rgba(0, 0, 0, 0.3)
        }
      }
      &:last-child:after {
        content: "";
        position: absolute;
        width: 200%;
        left: 0;
        z-index: 10;
        left: 8px;
        bottom: 0;
        transform: scale(.5);
        transform-origin: 0 0;
        -webkit-transform: scale(.5);
        -webkit-transform-origin: 0 0;
        background-color: #b7b7b7;
        height: 1px;
      }
      .list-info {
        position: relative;
        z-index: 2;
        left: 0;
        width: 100%;
        height: 64px;
        padding: 8px;
        background-color: #fff;
        .header-box {
          position: relative;
          float: left;
          width: 48px;
          height: 48px;
          margin-right: 10px;
          .header {
            height: 100%;
            border-radius: 5px;
            display: flex;
            display: -webkit-flex;
            flex-direction: row;
            flex-wrap: wrap;
            align-items: flex-start;
            overflow: hidden;
            background: #dddbdb;
            img {
              width: 10%;
              height: auto;
              flex-grow: 2;
              border: 0;
            }
            &.multi-header {
              img {
                margin: 1px;
              }
            }
          }
        }
        .desc-box {
          overflow: hidden;
          .desc-time {
            float: right;
            color: #b8b8b8;
          }
          .desc-author {
            height: 25px;
            line-height: 25px;
            font-size: 16px;
            color: #000;
          }
          .desc-msg {
            height: 23px;
            line-height: 23px;
            font-size: 14px;
            color: #888;
            .desc-mute {
              float: right;
              color: #b8b8b8;
            }
          }
        }
      }
      .operate-box {
        position: absolute;
        z-index: 1;
        height: 100%;
        right: 0;
        top: 0;
        display: flex;
        &>div {
          display: flex;
          justify-content: center;
          align-items: center;
          background-color: #c7c7cc;
          color: #fff;
          font-size: 18px;
          padding: 0 12px;
        }
        .operate-del {
          background-color: #ff3b30;
        }
      }
    }
  }
}
</style>