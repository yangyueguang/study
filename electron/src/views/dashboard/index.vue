<template>
  <div class="dashboard-container">
    <div class="dashboard-text">name:{{user.name}}</div>
    <div class="dashboard-text">roles:<span v-for='role in user.roles' :key='role'>{{user.roles}}</span></div>
  </div>
</template>

<script>

export default {
  name: 'dashboard',
  computed: {
    user(){
      return this.$store.state.user
    }
  }
}
</script>

<style rel="stylesheet/scss" lang="scss" scoped>
.dashboard {
  &-container {
    margin: 30px;
  }
  &-text {
    font-size: 30px;
    line-height: 46px;
  }
}
</style>
