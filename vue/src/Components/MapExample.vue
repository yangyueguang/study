<template>
  <div class="box">
    <div class="map-example" @change="fullscreenChange" :fullscreen.sync="fullscreen" ref="fullscreen">
      <div class="map-container"></div>
      <button type="button" class="btn btn-default btn-map-fullscreen" @click="toggleFullScreen">
        <i class="mdi" :class="[fullscreen ? 'mdi-fullscreen-exit' : 'mdi-fullscreen']"></i>
      </button>
    </div>
  </div>
</template>

<script>
import fullscreen from 'vue-fullscreen'
import Vue from 'vue'
Vue.use(fullscreen)
let BMap = null
let map = null
let $map = null

export default {

  data () {
    return {
      fullscreen: false
    }
  },

  methods: {
    toggleFullScreen () {
      this.$fullscreen.toggle(this.$el.querySelector('.map-example'), {
        wrap: false,
        callback: this.fullscreenChange
      })
    },
    fullscreenChange (fullscreen) {
      this.fullscreen = fullscreen
      map.checkResize()
      map.setMapStyle({style: fullscreen ? 'bluish' : 'normal'})
    },
    getMapScript () {
      if (!global.BMap) {
        const ak = 'DVr9V80HdBU5pjBWHyGMI2ei9nFuFbAc'
        global.BMap = {}
        global.BMap._preloader = new Promise((resolve, reject) => {
          global._initBaiduMap = function () {
            resolve(global.BMap)
            global.document.body.removeChild($script)
            global.BMap._preloader = null
            global._initBaiduMap = null
          }
          const $script = document.createElement('script')
          global.document.body.appendChild($script)
          $script.src = `//api.map.baidu.com/api?v=2.0&ak=${ak}&callback=_initBaiduMap`
        })
        return global.BMap._preloader
      } else if (!global.BMap._preloader) {
        return Promise.resolve(global.BMap)
      } else {
        return global.BMap._preloader
      }
    }
  },

  mounted: function () {
    this.getMapScript().then((module) => {
      BMap = module
      $map = this.$el.querySelector('.map-container')
      map = new BMap.Map($map)
      map.enableKeyboard()
      map.enableScrollWheelZoom()
      map.centerAndZoom('杭州', 13)
    })
  }
}
</script>

<style lang="scss" rel="stylesheet/scss" scoped>
  .map-example {
    position: relative;
    height: 400px;

    .map-container {
      height: 100%;
    }

    .btn-map-fullscreen {
      position: absolute;
      right: 10px;
      top: 10px;
      width: 36px;
      height: 36px;
      padding: 0;
      font-size: 36px;
      line-height: 36px;
      text-align: center;
      outline: none;
    }

    &.fullscreen {
      width: 100%;
      height: 100%;
    }
  }
</style>
