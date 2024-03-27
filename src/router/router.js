// router.js

import { createRouter, createWebHistory } from "vue-router";

import isAuthenticated from "./routeGuards";
import login from "@/Views/Auth/Login.vue";
import register from "@/Views/Auth/Register.vue";
import dashboard from "@/Views/Pages/Dashboard.vue";
import profile from "@/Views/Pages/Profile.vue";
import teams from "@/Views/Pages/Teams.vue";
import teamsDetail from "@/Views/Pages/TeamsDetails.vue";
import event from "@/Views/Pages/Event.vue";
import eventDetail from "@/Views/Pages/Event-Details.vue";
import panelAdmin from "@/Views/Pages/Admin.vue";

const routes = [
  {
    path: "/",
    name: "login",
    component: login,
  },
  {
    path: "/register",
    name: "register",
    component: register,
  },
  {
    path: "/dashboard",
    name: "dashboard",
    component: dashboard,
    beforeEnter: isAuthenticated,
  },
  {
    path: "/profile",
    name: "profile",
    component: profile,
    beforeEnter: isAuthenticated,
  },

  {
    path: "/teams",
    name: "teams",
    component: teams,
    beforeEnter: isAuthenticated,
  },
  {
    path: "/teams-details/:teamId",
    name: "teams-details",
    component: teamsDetail,
    beforeEnter: isAuthenticated,
  },

  {
    path: "/event",
    name: "event",
    component: event,
    beforeEnter: isAuthenticated,
  },
  {
    path: "/event/:registrationId",
    name: "eventDetail",
    component: eventDetail,
    beforeEnter: isAuthenticated,
  },
  {
    path: "/admin",
    name: "panelAdmin",
    component: panelAdmin,
    beforeEnter: isAuthenticated,
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
