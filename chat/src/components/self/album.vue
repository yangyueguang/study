<template>
    <div class="album">
        <header id="wx-header">
            <div class="center">
                <router-link to="/self" tag="div" class="iconfont icon-return-arrow">
                    <span>我</span>
                </router-link>
                <span>相册</span>
            </div>
        </header>
        <div class="home-pic">
            <div class="home-pic-base">
                <div class="top-pic">
                    <div class="top-pic-inner">
                        <img src="https://sinacloud.net/vue-wechat/images/headers/header01.png">
                    </div>
                </div>
                <div class="top-name _ellipsis">阿荡</div>
            </div>
            <p class="sign">填坑小能手</p>
        </div>
        <section class="album-box clearfix">
            <div class="post-date">
                <b class="day">04</b>
                <b class="month">3月</b>
            </div>
            <div class="post-content">
                <div class="tumb-box">
                    <img src="https://sinacloud.net/vue-wechat/images/headers/header01.png" alt="">
                    <img src="https://sinacloud.net/vue-wechat/images/headers/header01.png" alt="">
                    <img src="https://sinacloud.net/vue-wechat/images/headers/header01.png" alt="">
                </div>
                <div class="thumb-desc">
                    这里字比较多，这里字比较多，这里字比较多，这里字比较多，这里字比较多，这里字比较多，这里字比较多，这里字比较多，这里字比较多，
                    <p class="number">共3张</p>
                </div>
            </div>
        </section>
        <section class="album-box clearfix">
            <div class="post-date">
                <b class="day">12</b>
                <b class="month">2月</b>
            </div>
            <div class="post-content">
                <div class="tumb-box">
                    <img src="https://sinacloud.net/vue-wechat/images/headers/header01.png" alt="">
                     <img src="https://sinacloud.net/vue-wechat/images/headers/header01.png" alt="">
                </div>
                <div class="thumb-desc">
                    装逼如风 常伴吾生
                    <p class="number">共2张</p>
                </div>
            </div>
        </section>
        <section class="album-box clearfix">
            <div class="post-date">
                <b class="day">23</b>
                <b class="month">1月</b>
            </div>
            <div class="post-content">
                <div class="tumb-box">
                    <img src="https://sinacloud.net/vue-wechat/images/headers/header01.png" alt="">
                </div>
                <div class="thumb-desc">
                    装逼如风 常伴吾生
                    <p class="number">共1张</p>
                </div>
            </div>
        </section>
    </div>
</template>
<script>
    export default {}
</script>
<style lang="less">
.album {
  background: #fff;
  bottom: inherit;
  height: inherit;
  .home-pic {
    width: 100%;
    margin-top: -90px;
    position: relative;
    height: 370px;
    z-index: 5;
    background: url(https://sinacloud.net/vue-wechat/images/bg/cover.jpg) no-repeat center center;
    background-size: cover;
    margin-bottom: 60px;
  }
  .home-pic-base {
    position: absolute;
    left: 0;
    bottom: -22px;
    width: 100%;
    height: 70px;
    padding: 0 15px;
    .top-pic {
      width: 140px;
      height: 140px;
      padding: 3px;
      -webkit-transform: scale(0.5);
      transform: scale(0.5);
      -webkit-transform-origin: 100% 0%;
      transform-origin: 100% 0%;
      background-color: #ffffff;
      border: 1px solid #cccccc;
      float: right;
    }
    .top-name {
      position: absolute;
      left: 20px;
      right: 105px;
      top: 10px;
      font-size: 20px;
      text-align: right;
      color: #ffffff;
      overflow: hidden;
    }
  }
  .top-pic-inner {
    width: 100%;
    height: 100%;
    img {
      width: 100%;
    }
  }
  .drag-reflash {
    position: absolute;
    left: 20px;
    top: -40px;
    z-index: 2;
    width: 30px;
    height: 30px;
    background: url(../../assets/images/find-album-reflash-icon.png) no-repeat 0 0;
    background-size: contain;
  }
  .home-content {
    padding-top: 45px;
    min-height: 500px;
  }
  .album-box {
    margin: 15px;
    // width: 100%;
    .post-date {
      float: left;
      width: 20%;
      .day {
        font-size: 24px;
        margin-right: -3px;
      }
    }
    .post-content {
      padding-top: 10px;
      float: left;
      // margin-left: 15px;
      width: 80%;
    }
  }
  .tumb-box {
    width: 90px;
    height: 90px;
    float: left;
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    align-items: flex-start;
    width: 20%;
    img {
      flex-grow: 2;
      width: 10%;
    }
  }
  .thumb-desc {
    float: left;
    width: 80%;
    padding-left: 10px;
  }
}
</style>