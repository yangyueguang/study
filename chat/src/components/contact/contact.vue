<template>
    <div id="contact">
        <section>
            <div class="weui-cells_contact-head weui-cells weui-cells_access" style="margin-top:-1px">
                <router-link to="/contact/new-friends" class="weui-cell">
                    <div class="weui-cell_hd"> <img class="img-obj-cover" src="../../assets/images/contact_top-friend-notify.png"> </div>
                    <div class="weui-cell_bd weui-cell_primary"><p>新的朋友</p></div>
                </router-link>
                <router-link to="/contact/group-list" class="weui-cell">
                    <div class="weui-cell_hd"> <img class="img-obj-cover" src="../../assets/images/contact_top-addgroup.png"> </div>
                    <div class="weui-cell_bd weui-cell_primary"><p>群聊</p></div>
                </router-link>
                <router-link to="/contact/tags" class="weui-cell">
                    <div class="weui-cell_hd"> <img class="img-obj-cover" src="../../assets/images/contact_top-tag.png">
                    </div>
                    <div class="weui-cell_bd weui-cell_primary"><p>标签</p></div>
                </router-link>
                <router-link to="/contact/official-accounts" class="weui-cell">
                    <div class="weui-cell_hd"><img class="img-obj-cover" src="../../assets/images/contact_top-offical.png"></div>
                    <div class="weui-cell_bd weui-cell_primary"><p>公众号</p></div>
                </router-link>
            </div>
            <!--联系人集合-->
            <template v-for="(value,key) in contactsList">
                <div :ref="`key_${key}`" :key="key" class="weui-cells__title">{{key}}</div>
                <div class="weui-cells" :key="key+1">
                    <router-link :key="item.wxid" :to="{path:'/contact/details',query:{wxid:item.wxid}}"
                        class="weui-cell weui-cell_access" v-for="item in value" tag="div">
                        <div class="weui-cell__hd"><img :src="item.headerUrl" class="home__mini-avatar___1nSrW"></div>
                        <div class="weui-cell__bd">{{item.remark?item.remark:item.nickname}}</div>
                    </router-link>
                </div>
            </template>
        </section>
        <div class="initial-bar"><span @click="toPs(i)" :key="i+1" v-for="i in contactsInitialList">{{i}}</span></div>
    </div>
</template>
<script>
    export default {
        mixins: [window.mixin],
        data() {
            return {
                "pageName": "通讯录"
            }
        },
        mounted() {
            // mutations.js中有介绍
            this.$store.commit("toggleTipsStatus", -1)
        },
        activated() {
            this.$store.commit("toggleTipsStatus", -1)
        },
        computed: {
            contactsInitialList() {
                return this.$store.getters.contactsInitialList
            },
            contactsList() {
                return this.$store.getters.contactsList
            }
        },
        methods: {
            toPs(i) {
                window.scrollTo(0, this.$refs['key_' + i][0].offsetTop)
            }
        }
    }
</script>
<style lang="less">
#contact {
  img {
    width: 32px;
    height: 32px;
    display: block;
    margin-right: 10px;
    // border-radius: 4px;
  }
  .initial-bar {
    position: fixed;
    top: 50%;
    font-size: 11px;
    line-height: 1.2;
    right: 2px;
    width: 10px;
    transform: translate3d(0, -50%, 0);
    span {
      display: block;
      text-align: left;
    }
  }
}
</style>