<template>
  <el-menu class="navbar" mode="horizontal">
    <div class="hamburger-container">
      <i class="fa fa-bars hamburger" @click="toggleSideBar" :class="{'is-active':sidebar.opened}"></i>
    </div>

    <el-breadcrumb class="app-breadcrumb" separator="/">
      <transition-group name="breadcrumb">
        <el-breadcrumb-item v-for="(item,index)  in levelList" :key="item.path" v-if="item.meta.title">
          <span v-if="item.redirect==='noredirect'" class="no-redirect">{{item.meta.title}}</span>
          <router-link v-else :to="item.redirect||item.path">{{item.meta.title}}</router-link>
        </el-breadcrumb-item>
      </transition-group>
    </el-breadcrumb>

    <el-dropdown class="avatar-container" trigger="click">
      <div class="avatar-wrapper">
        <img class="user-avatar" :src="avatar||$config.assets.head">
        <i class="el-icon-caret-bottom"></i>
      </div>
      <el-dropdown-menu class="user-dropdown" slot="dropdown">
        <router-link class="inlineBlock" to="/">
          <el-dropdown-item>
            Home
          </el-dropdown-item>
        </router-link>
        <el-dropdown-item divided>
          <span @click="logout" style="display:block;">LogOut</span>
        </el-dropdown-item>
      </el-dropdown-menu>
    </el-dropdown>
  </el-menu>
</template>

<script>

export default {
  data(){
    return {
      levelList: []
    }
  },
  created() {
    let matched = this.$route.matched.filter(item => item.name)
    const first = matched[0]
    if (first && first.name !== 'dashboard') {
      matched = [{ path: '/dashboard', meta: { title: 'Dashboard' }}].concat(matched)
    }
    this.levelList = matched
  },
  computed: {
    sidebar(){
      return this.$store.state.sidebar
    },
    avatar(){
      return this.$store.state.user.avatar
    }
  },
  methods: {
    toggleSideBar() {
      this.$router.push('/404')
      // this.$store.state.sidebar.opened = !this.$store.state.sidebar.opened
    },
    logout() {
      this.$store.dispatch('LogOut').then(() => {
        location.reload() // 为了重新实例化vue-router对象 避免bug
      })
    }
  }
}
</script>

<style rel="stylesheet/scss" lang="scss" scoped>
.navbar {
  height: 50px;
  line-height: 50px;
  border-radius: 0px !important;
  .hamburger-container {
    line-height: 58px;
    height: 50px;
    float: left;
    padding: 0 10px;
    .hamburger {
      display: inline-block;
      cursor: pointer;
      width: 20px;
      height: 20px;
      transform: rotate(90deg);
      transition: .38s;
      transform-origin: 50% 50%;
    }
    .hamburger.is-active {
      transform: rotate(0deg);
    }
  }
  .app-breadcrumb.el-breadcrumb {
    display: inline-block;
    font-size: 14px;
    line-height: 50px;
    margin-left: 10px;
    .no-redirect {
      color: #97a8be;
      cursor: text;
    }
  }
  .screenfull {
    position: absolute;
    right: 90px;
    top: 16px;
    color: red;
  }
  .avatar-container {
    height: 50px;
    display: inline-block;
    position: absolute;
    right: 35px;
    .avatar-wrapper {
      cursor: pointer;
      margin-top: 5px;
      position: relative;
      .user-avatar {
        width: 40px;
        height: 40px;
        border-radius: 10px;
      }
      .el-icon-caret-bottom {
        position: absolute;
        right: -20px;
        top: 25px;
        font-size: 12px;
      }
    }
  }
}
</style>

