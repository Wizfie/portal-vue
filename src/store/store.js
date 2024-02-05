import { createStore } from "vuex";

export default createStore({
	state: {
		authToken: null,
		authData: null,
	},
	mutations: {
		setAuthToken(state, token) {
			// console.log("Check Token : " + token);
			state.authToken = token;
		},

		setUserData(state, user) {
			state.authData = user;
			// console.log("Check User : " + user);
		},
		clearAuthToken(state) {
			state.authToken(null);
			state.authData(null);
		},
	},

	actions: {
		saveUserDataAndToken({ commit }, { token, user }) {
			commit("setAuthToken", token);
			commit("setUserData", user);
		},

		clearAuthToken({ commit }) {
			commit("clearAuthToken");
		},
	},
	getters: {
		isAuthenticated: (state) => !!state.authToken,
		getUserData: (state) => state.authData,
	},
});
