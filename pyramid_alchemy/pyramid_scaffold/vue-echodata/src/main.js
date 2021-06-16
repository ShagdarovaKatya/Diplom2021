import Vue from "vue";
import App from "./App.vue";
import router from "./router";
import "./registerServiceWorker";

import ApiService from "./common/api.service";
import DateFilter from "./common/date.filter";
import ErrorFilter from "./common/error.filter";

import { BootstrapVue, IconsPlugin } from 'bootstrap-vue'
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'


Vue.config.productionTip = false;
Vue.filter("date", DateFilter);
Vue.filter("error", ErrorFilter);

Vue.use(BootstrapVue);
Vue.use(IconsPlugin);

ApiService.init();

new Vue({
  router,
  render: h => h(App)
}).$mount("#app");
