import '@babel/polyfill'
import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import './plugins/vuetify'
import { createProvider } from './plugins/apollo'
import vgl from 'vue-golden-layout'
import HighchartsVue from 'highcharts-vue'
import Highcharts from 'highcharts'
import stockInit from 'highcharts/modules/stock'

Vue.config.productionTip = false

Vue.use(vgl)
stockInit(Highcharts)
Vue.use(HighchartsVue)

import 'golden-layout/src/css/goldenlayout-light-theme.css'
import "../node_modules/ag-grid/dist/styles/ag-grid.css";
import "../node_modules/ag-grid/dist/styles/ag-theme-material.css";

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
