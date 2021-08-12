<template>
  <div class="app-wrapper" :class="classObj">
    <sidebar class="sidebar-container"></sidebar>
    <div class="main-container">
      <navbar></navbar>
      <section class="app-main">
        <transition name="fade" mode="out-in">
          <router-view></router-view>
        </transition>
      </section>
    </div>
  </div>
</template>

<script>
import Navbar from '@/components/Navbar'
import Sidebar from '@/components/Sidebar'

export default {
  name: 'layout',
  components: {
    Navbar,
    Sidebar,
  },
  watch: {
    $route(route) {
      if (this.device === 'mobile') {
        store.dispatch('CloseSideBar', { withoutAnimation: false })
      }
    }
  },
  beforeMount() {
    window.addEventListener('resize', this.resizeHandler)
  },
  mounted() {
    const isMobile = this.isMobile()
    if (isMobile) {
      store.dispatch('ToggleDevice', 'mobile')
      store.dispatch('CloseSideBar', { withoutAnimation: true })
    }
  },
  computed: {
    classObj() {
      return {
        hideSidebar: !this.$store.state.sidebar.opened,
        withoutAnimation: this.$store.state.sidebar.withoutAnimation,
        mobile: this.$store.state.device === 'mobile'
      }
    }
  },
  methods: {
    isMobile() {
      const rect = document.body.getBoundingClientRect()
      return rect.width - 3 < 1024
    },
    resizeHandler() {
      if (!document.hidden) {
        const isMobile = this.isMobile()
        store.dispatch('ToggleDevice', isMobile ? 'mobile' : 'desktop')

        if (isMobile) {
          store.dispatch('CloseSideBar', { withoutAnimation: true })
        }
      }
    }
  }
}
</script>

<style rel="stylesheet/scss" lang="scss" scoped>
  @import "../../static/css/uni";
  .app-wrapper {
    @include clearfix;
    position: relative;
    height: 100%;
    width: 100%;
  }
</style>
