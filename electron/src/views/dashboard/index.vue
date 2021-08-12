<template>
  <div class="dashboard">
    <div class="text">name:{{user.name}}</div>
    <div class="text">roles:<span v-for='role in user.roles' :key='role'>{{role}}</span></div>
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
  margin: 30px;
  .text {
    font-size: 30px;
    line-height: 46px;
  }
}
</style>
