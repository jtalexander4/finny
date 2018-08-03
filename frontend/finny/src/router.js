import Vue from 'vue'
import Router from 'vue-router'
import Home from './components/HelloWorld.vue'
import Dashboard from './components/Dashboard.vue'
import AddAccount from './components/AddAccount.vue'
import AddAccountType from './components/AddAccountType.vue'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home
    },
    {
      path: '/dashboard',
      name: 'dashboard',
      component: Dashboard,
      // route level code-splitting
      // this generates a separate chunk (about.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      // component: () => import(/* webpackChunkName: "about" */ './views/Dashboard.vue')
    },
    {
      path: '/addAccount',
      name: 'addAccount',
      component: AddAccount
    },
    {
      path: '/addAccountType',
      name: 'addAccountType',
      component: AddAccountType
    },
  ]
})
