import Vue from "vue";
import Router from "vue-router";

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: "/",
      component: () => import("@/views/Home"),
      children: [
        {
          path: "",
          name: "home",
          component: () => import("@/views/HomeGlobal")
        },
        {
          path: "patients",
          name: "patients",
          component: () => import("@/views/patients")
        },
        {
          path: "investigations",
          name: "investigations",
          component: () => import("@/views/invests")
        },
        {
          path: "templates",
          name: "templates",
          component: () => import("@/views/templates")
        },
        {
          path: "prescribe",
          name: "prescribe",
          component: () => import("@/views/prescribe")
        },
        {
          path: "doctors",
          name: "doctors",
          component: () => import("@/views/doctors")
        },
        {
          path: "settings",
          name: "settings",
          component: () => import("@/views/settings")
        },
        {
          path: "addPatient",
          name: "addPatient",
          component: () => import("@/views/addPatient")
        },
        {
          path: "addTemplate",
          name: "addTemplate",
          component: () => import("@/views/addTemplate")
        },
        {
          path: "editTemplate",
          name: "editTemplate",
          component: () => import("@/views/editTemplate")
        },
        {
          path: "editPatient",
          name: "editPatient",
          component: () => import("@/views/editPatient")
        },
        {
          path: "patient",
          name: "patient",
          component: () => import("@/views/patient")
        },
        {
          path: "addInvest",
          name: "addInvest",
          component: () => import("@/views/addInvest")
        },
        {
          path: "fillInvestTemplate",
          name: "fillInvestTemplate",
          component: () => import("@/views/fillInvestTemplate")
        }
      ]
    }
  ]
});
