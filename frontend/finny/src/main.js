import '@babel/polyfill'
import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import './plugins/vuetify'
import { createProvider } from './plugins/apollo'
import vgl from 'vue-golden-layout'
import $ from 'jquery'

Vue.config.productionTip = false

Vue.use(vgl);

import 'golden-layout/src/css/goldenlayout-light-theme.css'

Vue.filter('toCurrency', function (value) {
  var formatter = new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
      minimumFractionDigits: 2
  });
  return formatter.format(value);
})

new Vue({
  router,
  store,
  provide: createProvider().provide(),
  render: h => h(App)
}).$mount('#app')
