<template>
  <li :class="{'item-hide':deleteMsg}">
    <router-link
        :to="{ path: '/wechat/dialogue', query: { mid: item.mid,name:item.group_name||(item.user[0].remark||item.user[0].nickname),group_num:item.user.length}}"
        tag="div" class="list-info" v-swiper v-on:click.native="toggleMsgRead($event,'enter')">
      <div class="header-box">
        <i class="new-msg-count" v-show="!read&&!item.quiet">{{item.msg.length}}</i>
        <i class="new-msg-dot" v-show="!read&&item.quiet"></i>
        <div class="header" :class="[item.type=='group'?'multi-header':'']">
          <img v-for="(userInfo,index) in item.user" :key="index" :src="userInfo.headerUrl">
        </div>
      </div>
      <div class="desc-box">
        <div class="desc-time">{{item.msg[item.msg.length-1].date | fmtDate('hh:ss')}}</div>
        <div class="desc-author" v-if="item.type=='group'">{{item.group_name}}</div>
        <div class="desc-author" v-else>{{item.user[0].remark||item.user[0].nickname}}</div>
        <div class="desc-msg">
          <div class="desc-mute iconfont icon-mute" v-show="item.quiet"></div>
          <span v-show="item.type=='group'">{{item.msg[item.msg.length-1].name}}:</span>
          <span>{{item.msg[item.msg.length-1].text}}</span>
        </div>
      </div>
    </router-link>
    <div class="operate-box">
      <div class="operate-unread" v-if="read" v-on:click="toggleMsgRead">标为未读</div>
      <div class="operate-read" v-else v-on:click="toggleMsgRead">标为已读</div>
      <div class="operate-del" v-on:click="deleteMsgEvent">删除</div>
    </div>
  </li>
</template>
<script>
export default {
  props: ["item"],
  data() {
    return {
      read: this.item.read,
      deleteMsg: false
    }
  },
  methods: {
    //切换消息未读/已读状态
    toggleMsgRead(event, status) {
      if (status === 'enter') {
        if (this.read) {
          return ''
        }
        this.read = true
      } else {
        this.read = !this.read
      }
      if (!this.item.quiet) {
        if (this.read) {
          this.$store.commit('minusNewMsg')
        } else {
          this.$store.commit('addNewMsg')
        }
      }

      event.target.parentNode.parentNode.firstChild.style.marginLeft = 0 + "px"
    },
    deleteMsgEvent() {
      this.deleteMsg = true
      if (!this.item.quiet) {
        if (!this.read) {
          this.$store.commit('minusNewMsg')
        }
      }
    }
  },
  directives: {
    swiper: {
      bind: function (element) {
        var isTouchMove, startTx, startTy
        element.addEventListener('touchstart', function (e) {
          var touches = e.touches[0]
          startTx = touches.clientX
          startTy = touches.clientY
          isTouchMove = false;
        });
        element.addEventListener('touchmove', function (e) {
          e.preventDefault();
          var touches = e.changedTouches[0],
              endTx = touches.clientX,
              endTy = touches.clientY,
              distanceX = startTx - endTx,
              distanceY = startTy - endTy;
          if (distanceX < 0) { //右滑
            if (Math.abs(distanceX) >= Math.abs(distanceY)) {
              if (Math.abs(distanceX) > 20) {
                element.style.transition = "0.3s"
                element.style.marginLeft = 0 + "px"
              }
            }
          } else { //左滑
            if (Math.abs(distanceX) >= Math.abs(distanceY)) {
              if (distanceX < 156 && distanceX > 20) {
                element.style.transition = "0s"
                element.style.marginLeft = -distanceX + "px"
                isTouchMove = true
              }
            }
          }
        }, { passive: false });
        element.addEventListener('touchend', function (e) {
          if (!isTouchMove) {
            return;
          }
          var touches = e.changedTouches[0],
              endTx = touches.clientX,
              endTy = touches.clientY,
              distanceX = startTx - endTx,
              distanceY = startTy - endTy
          // isSwipe = false
          if (Math.abs(distanceX) >= Math.abs(distanceY)) {
            if (distanceX < 0) {
              return;
            }
            if (Math.abs(distanceX) < 60) {
              element.style.transition = "0.3s"
              element.style.marginLeft = 0 + "px"
            } else {
              element.style.transition = "0.3s"
              element.style.marginLeft = "-156px"
            }
          }
        });
      }
    }
  }
}
</script>