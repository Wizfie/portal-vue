// router.js

import { createRouter, createWebHistory } from "vue-router";

import login from "@/Views/Auth/Login.vue";
import register from "@/Views/Auth/Register.vue";
import dashboard from "@/Views/Pages/Dashboard.vue";
import isAuthenticated from "./routeGuards";
import profile from "@/Views/Pages/Profile.vue";
import teams from "@/Views/Pages/Teams.vue";
import members from "@/Views/Pages/Members-Team.vue";
import event from "@/Views/Pages/Event.vue";
import eventDetail from "@/Views/Pages/Event-Details.vue";
import eventAdmin from "@/Views/Pages/Event-Admin.vue";

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
		path: "/teams/members/:teamId",
		name: "members",
		component: members,
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
		path: "/event/admin",
		name: "eventAdmin",
		component: eventAdmin,
		beforeEnter: isAuthenticated,
	},
];

const router = createRouter({
	history: createWebHistory(),
	routes,
});

export default router;
