import Vue from 'vue'
import Router from 'vue-router'

import Home from "./page/Home"
import Products from "./page/Products"
import Contact from "./page/Contact"
import Info from "./page/Info"

Vue.use(Router)

export default new Router({
  routes: [
      {
    path: '/home',
    redirect:{path:'/',query:{tab:0}}
  },
    {
      path: '/',
      name: 'Home',
      component: Home
    },{
      path: '/products',
      name: 'Products',
      component: Products
    },
    {
      path: '/contact',
      name: 'Contact',
      component: Contact
    },
    {
      path: '/info',
      name: 'Info',
      component: Info
    }
  ],
  mode: 'history' // hash
})
