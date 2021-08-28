<template>
  <div id="explore">
    <section>
      <div class="weui-cells">
        <router-link to="/explore/moments" class="weui-cell weui-cell_access" tag="div"
          v-on:click.native="momentNewMsg=false">
          <div class="weui-cell__hd"><img src="../../assets/images/find_icon-circle.png"></div>
          <div class="weui-cell__bd" style="line-height: 28px;">朋友圈</div>
          <div class="weui-cell__ft">
            <div class="home__notice" v-show="momentNewMsg">
              <img src="https://sinacloud.net/vue-wechat/images/headers/yehua.jpg" alt="" class="">
              <i class="new-msg-dot"></i>
            </div>
          </div>
        </router-link>
      </div>
      <div class="weui-cells">
        <div class="weui-cell weui-cell_access" id="scanCell" @click="alertreminder=true">
          <div class="weui-cell__hd"><img src="../../assets/images/find_icon-qrcode.png"></div>
          <div class="weui-cell__bd">扫一扫</div>
        </div>
        <div class="weui-cell weui-cell_access">
          <div class="weui-cell__hd"><img src="../../assets/images/find_icon-shake.png"></div>
          <div class="weui-cell__bd">摇一摇</div>
        </div>
      </div>
      <div class="weui-cells">
        <div class="weui-cell weui-cell_access">
          <div class="weui-cell__hd"><img src="../../assets/images/find_icon-shake.png"></div>
          <div class="weui-cell__bd">附近的人</div>
        </div>
        <div class="weui-cell weui-cell_access">
          <div class="weui-cell__hd"><img src="../../assets/images/find_icon-shake.png"></div>
          <div class="weui-cell__bd">漂流瓶</div>
        </div>
      </div>
      <div class="weui-cells">
        <a class="weui-cell weui-cell_access">
          <div class="weui-cell__hd"><img src="../../assets/images/find_icon-shopping.png"></div>
          <div class="weui-cell__bd">购物</div>
        </a>
        <div class="weui-cell weui-cell_access">
          <div class="weui-cell__hd"><img src="../../assets/images/find_icon-moregame.png"></div>
          <div class="weui-cell__bd">游戏</div>
        </div>
      </div>
    </section>
    <section class="reminder" v-if="alertreminder">
      <div class="reminder_cover"></div>
      <div class="reminder_content" :class="{alertshow : true, alerthide : false}">
        <img :src="gifSrc" alt="" class="alertimg">
        <p class="alert_text">正在开发中...</p>
        <div class="alert_affirm" @click="alertreminder=false">确认</div>
      </div>
    </section>
  </div>
</template>
<script>
  export default {
    mixins: [window.mixin],
    data() {
      return {
        pageName: "发现",
        alertreminder: false,
        momentNewMsg: true
      }
    },
    activated() {
      this.$store.commit("toggleTipsStatus", -1)
    }
  }
</script>
<style lang="less">
#explore {
  .weui-cell__hd {
    img {
      width: 20px;
      margin-right: 10px;
      display: block;
    }
  }
  .home__notice {
    position: relative;
    img {
      width: 28px;
      height: 28px;
      vertical-align: middle;
    }
  }
  .new-msg-dot {
    position: absolute;
    top: -4px;
    right: -5px;
    display: inline-block;
    width: 9px;
    height: 9px;
    border-radius: 50%;
    background-color: red;
  }
}
.reminder{
  position: fixed;
 width: 100%;
  Height:100%;
  top:0;
  z-index:10;
  .reminder_cover{
    position: absolute;
    top:0;
    width: 100%;
    Height:100%;
    background:#000;
    opacity:.4;
  }
  .reminder_content{
    position: absolute;
    background:#fff;
    border-radius:8px;
    width:13rem;
    height:14rem;
    top:50%;
    margin-top:-7rem;
    left:50%;
    margin-left:-6.5rem;
    .alertimg{
      display:block;
      width: 6.4rem;
      Height:6rem;
      margin:0.4266666667rem auto 1.28rem;
    }
    .alert_text{
      width:100%;
      text-align:center;
      font-weight:700;
      font-size: 0.8rem;
      color: #B6FF00;
      -webkit-animation: neon4 0.5s ease-in-out infinite alternate;
      -moz-animation: neon4 0.5s ease-in-out infinite alternate;
      animation: neon4 0.5s ease-in-out infinite alternate;
    }
    .alert_affirm{
      width:8rem;
      margin:2.1333333333rem auto 0;
      line-height:1.8rem;
      border-radius:5px;
      text-align:center;
      background:#1aad19;
      letter-spacing:0.1066666667rem;
      font-size: 0.7rem;
      color: #fff;
    }
  }
  .alertshow{
    animation: tada 1s 1 ease-in-out both;
  }
  .alerthide{
    animation: zoomOutDown 1s 1 ease-in-out both;
  }
}
</style>