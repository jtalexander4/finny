import '@babel/polyfill'
import Vue from 'vue'
import './plugins/vuetify'
import App from './App.vue'
import router from './router'
import store from './store'
import { createProvider } from './plugins/apollo'
import vgl from 'vue-golden-layout'
import $ from 'jquery'

Vue.use(vgl);

import 'golden-layout/src/css/goldenlayout-light-theme.css'

Vue.config.productionTip = false

new Vue({
  router,
  store,
  provide: createProvider().provide(),
  render: h => h(App)
}).$mount('#app')
