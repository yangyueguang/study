<template>
  <scroll-bar>
    <el-menu
      mode="vertical"
      :show-timeout="200"
      :default-active="$route.path"
      :collapse="isCollapse"
      background-color="#304156"
      text-color="#bfcbd9"
      active-text-color="#409EFF"
    >
      <div class="menu-wrapper">
        <template v-for="item in routes" v-if="!item.hidden&&item.children">

          <router-link v-if="hasOneShowingChildren(item.children) && !item.children[0].children&&!item.alwaysShow" :to="item.path+'/'+item.children[0].path"
                       :key="item.children[0].name">
            <el-menu-item :index="item.path+'/'+item.children[0].path" class="submenu-title-noDropdown">
              <view v-if="item.children[0].meta&&item.children[0].meta.icon" :icon-class="item.children[0].meta.icon"></view>
              <span v-if="item.children[0].meta&&item.children[0].meta.title" slot="title">{{item.children[0].meta.title}}</span>
            </el-menu-item>
          </router-link>

          <el-submenu v-else :index="item.name||item.path" :key="item.name">
            <template slot="title">
              <view v-if="item.meta&&item.meta.icon" :icon-class="item.meta.icon"></view>
              <span v-if="item.meta&&item.meta.title" slot="title">{{item.meta.title}}</span>
            </template>

            <template v-for="child in item.children" v-if="!child.hidden">
              <sidebar-item :is-nest="true" class="nest-menu" v-if="child.children&&child.children.length>0" :routes="[child]" :key="child.path"></sidebar-item>

              <router-link v-else :to="item.path+'/'+child.path" :key="child.name">
                <el-menu-item :index="item.path+'/'+child.path">
                  <view v-if="child.meta&&child.meta.icon" :icon-class="child.meta.icon"></view>
                  <span v-if="child.meta&&child.meta.title" slot="title">{{child.meta.title}}</span>
                </el-menu-item>
              </router-link>
            </template>
          </el-submenu>

        </template>
      </div>
    </el-menu>
  </scroll-bar>
</template>

<script>
import ScrollBar from '@/components/scrollbar'

export default {
  components: { ScrollBar },
  computed: {
    sidebar(){
      return this.$store.state.sidebar
    },
    routes() {
      return this.$router.options.routes
    },
    isCollapse() {
      return !this.sidebar.opened
    }
  },
  methods: {
    hasOneShowingChildren(children) {
      const showingChildren = children.filter(item => {
        return !item.hidden
      })
      if (showingChildren.length === 1) {
        return true
      }
      return false
    }
  }
}
</script>
