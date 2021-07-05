<template>
    <div id="home">
        <v-header :title="title" :homemsg='msg'  :run="run"  :home="this"></v-header>
        <hr>首页组件

        <router-link to="/home">首页</router-link>
        <router-link to="/news">新闻</router-link>
        <hr>
        <router-view></router-view>
        <br/>
        <button @click="getData()">请求数据</button>
        <hr>
        <br>

        <ul>
            <li v-for="item in list">

                {{item.title}}
            </li>
        </ul>
    </div>
</template>
<script>
    // 1、安装  cnpm  install  axios --save
    import Axios from 'axios';
    import Header from './Header.vue';
    export default {
        data(){
            return {
               msg:'我是一个home组件',
               title:'首页111',
                list:[]
            }
        },
        components:{
            'v-header':Header
        },
        methods:{
            run(data){
                alert('我是Home组件的run方法'+data);
            },
            getData(){
                var api='http://www.phonegap100.com/appapi.php?a=getPortalList&catid=20&page=1';
                Axios.get(api).then((response)=>{
                    this.list=response.data.result;
                }).catch((error)=>{
                    console.log(error);
                })
            }
        },
        beforeCreate(){
            console.log('实例刚刚被创建1');
        },
        created(){
            console.log('实例已经创建完成2');
        },
        beforeMount(){
            console.log('模板编译之前3');
        },
        mounted(){     /*请求数据，操作dom , 放在这个里面  mounted*/
            console.log('模板编译完成4');
            this.getData();
        },
        beforeUpdate(){
            console.log('数据更新之前');
        },
        updated(){
            console.log('数据更新完毕');
        },
        beforeDestroy(){   /*页面销毁的时候要保存一些数据，就可以监听这个销毁的生命周期函数*/
            console.log('实例销毁之前');
        },
        destroyed(){
            console.log('实例销毁完成');
        }
    }
</script>
<style lang="scss" scoped>
    h2{
        color:red
    }

</style>
