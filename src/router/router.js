// router.js

import { createRouter, createWebHistory } from "vue-router";

import login from "../Views/Auth/Login.vue";
import register from "../Views/Auth/Register.vue";
import dashboard from "../Views/Pages/Dashboard.vue";
import isAuthenticated from "./routeGuards";
import profile from "../Views/Pages/Profile.vue";
import teams from "../Views/Pages/Teams.vue";
import awards from "../Views/Pages/Awards.vue";

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
		path: "/awards",
		name: "awards",
		component: awards,
		beforeEnter: isAuthenticated,
	},
];

const router = createRouter({
	history: createWebHistory(),
	routes,
});

export default router;
