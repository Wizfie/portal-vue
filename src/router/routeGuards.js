import store from "../store/store";

function isAuthenticated(to, from, next) {
	const authToken = localStorage.getItem("authToken");

	if (authToken) {
		try {
			const base64Url = authToken.split(".")[1];
			const base64 = base64Url.replace(/-/g, "+").replace(/_/g, "/");
			const decodedToken = JSON.parse(atob(base64));

			const currentTimestamp = Math.floor(Date.now() / 1000);

			if (decodedToken.exp > currentTimestamp) {
				// Token is not expired
				store.commit("setAuthToken", authToken);
				next();
			} else {
				// Token is expired
				alert("Session has expired. Please log in again.");
				store.commit("setAuthToken", null);
				next({ name: "login" });
			}
		} catch (error) {
			// Error decoding token
			console.error("Error decoding token:", error);
			alert("Error decoding token. Please log in again.");
			store.commit("setAuthToken", null);
			next({ name: "login" });
		}
	} else {
		// No token available
		alert("Session expired. Please log in again.");
		next({ name: "login" });
	}
}

export default isAuthenticated;
