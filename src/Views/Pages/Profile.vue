<script setup>
	import { onMounted, ref } from "vue";
	import SiddebarWithNavbar from "../../components/SidebarWithNavbar.vue";
	import { useStore } from "vuex";

	const store = useStore();
	const userData = ref("");

	onMounted(() => {
		userData.value = store.getters.getUserData;
		console.log(userData.value);
	});
</script>
<template>
	<div>
		<SiddebarWithNavbar></SiddebarWithNavbar>
		<div class="p-4 sm:ml-64">
			<div
				class="p-4 border-2 border-gray-200 border-opacity-100 rounded-lg dark:border-gray-700 mt-14"
			>
				<div>
					<div>
						<h1>Profile</h1>
						<p>{{ userData.role }}</p>
					</div>
					<button
						type="button"
						class="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-blue-600 dark:hover:bg-blue-700 focus:outline-none dark:focus:ring-blue-800"
					>
						Default
					</button>

					<button
						id="dropdownDefaultButton"
						data-dropdown-toggle="dropdown"
						class="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center inline-flex items-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
						type="button"
					>
						Dropdown button
						<svg
							class="w-2.5 h-2.5 ms-3"
							aria-hidden="true"
							xmlns="http://www.w3.org/2000/svg"
							fill="none"
							viewBox="0 0 10 6"
						>
							<path
								stroke="currentColor"
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="m1 1 4 4 4-4"
							/>
						</svg>
					</button>

					<!-- Dropdown menu -->
					<div
						id="dropdown"
						class="z-10 hidden bg-white divide-y divide-gray-100 rounded-lg shadow w-44 dark:bg-gray-700"
					>
						<ul
							class="py-2 text-sm text-gray-700 dark:text-gray-200"
							aria-labelledby="dropdownDefaultButton"
						>
							<li>
								<a
									href="#"
									class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
									>Dashboard</a
								>
							</li>
							<li>
								<a
									href="#"
									class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
									>Settings</a
								>
							</li>
							<li>
								<a
									href="#"
									class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
									>Earnings</a
								>
							</li>
							<li>
								<a
									href="#"
									class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
									>Sign out</a
								>
							</li>
						</ul>
					</div>

					<div
						class="flex items-center justify-center h-24 rounded bg-gray-50 dark:bg-gray-800"
					>
						<p class="text-2xl text-gray-400 dark:text-gray-500">
							<svg
								class="w-3.5 h-3.5"
								aria-hidden="true"
								xmlns="http://www.w3.org/2000/svg"
								fill="none"
								viewBox="0 0 18 18"
							>
								<path
									stroke="currentColor"
									stroke-linecap="round"
									stroke-linejoin="round"
									stroke-width="2"
									d="M9 1v16M1 9h16"
								/>
							</svg>
						</p>
					</div>
					<div
						class="flex items-center justify-center h-24 rounded bg-gray-50 dark:bg-gray-800"
					>
						<p class="text-2xl text-gray-400 dark:text-gray-500">
							<svg
								class="w-3.5 h-3.5"
								aria-hidden="true"
								xmlns="http://www.w3.org/2000/svg"
								fill="none"
								viewBox="0 0 18 18"
							>
								<path
									stroke="currentColor"
									stroke-linecap="round"
									stroke-linejoin="round"
									stroke-width="2"
									d="M9 1v16M1 9h16"
								/>
							</svg>
						</p>
					</div>
					<div
						class="flex items-center justify-center h-24 rounded bg-gray-50 dark:bg-gray-800"
					>
						<p class="text-2xl text-gray-400 dark:text-gray-500">
							<svg
								class="w-3.5 h-3.5"
								aria-hidden="true"
								xmlns="http://www.w3.org/2000/svg"
								fill="none"
								viewBox="0 0 18 18"
							>
								<path
									stroke="currentColor"
									stroke-linecap="round"
									stroke-linejoin="round"
									stroke-width="2"
									d="M9 1v16M1 9h16"
								/>
							</svg>
						</p>
					</div>
				</div>
				<div
					class="flex items-center justify-center h-48 mb-4 rounded bg-gray-50 dark:bg-gray-800"
				>
					<p class="text-2xl text-gray-400 dark:text-gray-500">
						<svg
							class="w-3.5 h-3.5"
							aria-hidden="true"
							xmlns="http://www.w3.org/2000/svg"
							fill="none"
							viewBox="0 0 18 18"
						>
							<path
								stroke="currentColor"
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M9 1v16M1 9h16"
							/>
						</svg>
					</p>
				</div>
				<div class="grid grid-cols-2 gap-4 mb-4">
					<div
						class="flex items-center justify-center rounded bg-gray-50 h-28 dark:bg-gray-800"
					>
						<p class="text-2xl text-gray-400 dark:text-gray-500">
							<svg
								class="w-3.5 h-3.5"
								aria-hidden="true"
								xmlns="http://www.w3.org/2000/svg"
								fill="none"
								viewBox="0 0 18 18"
							>
								<path
									stroke="currentColor"
									stroke-linecap="round"
									stroke-linejoin="round"
									stroke-width="2"
									d="M9 1v16M1 9h16"
								/>
							</svg>
						</p>
					</div>
					<div
						class="flex items-center justify-center rounded bg-gray-50 h-28 dark:bg-gray-800"
					>
						<p class="text-2xl text-gray-400 dark:text-gray-500">
							<svg
								class="w-3.5 h-3.5"
								aria-hidden="true"
								xmlns="http://www.w3.org/2000/svg"
								fill="none"
								viewBox="0 0 18 18"
							>
								<path
									stroke="currentColor"
									stroke-linecap="round"
									stroke-linejoin="round"
									stroke-width="2"
									d="M9 1v16M1 9h16"
								/>
							</svg>
						</p>
					</div>
					<div
						class="flex items-center justify-center rounded bg-gray-50 h-28 dark:bg-gray-800"
					>
						<p class="text-2xl text-gray-400 dark:text-gray-500">
							<svg
								class="w-3.5 h-3.5"
								aria-hidden="true"
								xmlns="http://www.w3.org/2000/svg"
								fill="none"
								viewBox="0 0 18 18"
							>
								<path
									stroke="currentColor"
									stroke-linecap="round"
									stroke-linejoin="round"
									stroke-width="2"
									d="M9 1v16M1 9h16"
								/>
							</svg>
						</p>
					</div>
					<div
						class="flex items-center justify-center rounded bg-gray-50 h-28 dark:bg-gray-800"
					>
						<p class="text-2xl text-gray-400 dark:text-gray-500">
							<svg
								class="w-3.5 h-3.5"
								aria-hidden="true"
								xmlns="http://www.w3.org/2000/svg"
								fill="none"
								viewBox="0 0 18 18"
							>
								<path
									stroke="currentColor"
									stroke-linecap="round"
									stroke-linejoin="round"
									stroke-width="2"
									d="M9 1v16M1 9h16"
								/>
							</svg>
						</p>
					</div>
				</div>
				<div
					class="flex items-center justify-center h-48 mb-4 rounded bg-gray-50 dark:bg-gray-800"
				>
					<p class="text-2xl text-gray-400 dark:text-gray-500">
						<svg
							class="w-3.5 h-3.5"
							aria-hidden="true"
							xmlns="http://www.w3.org/2000/svg"
							fill="none"
							viewBox="0 0 18 18"
						>
							<path
								stroke="currentColor"
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M9 1v16M1 9h16"
							/>
						</svg>
					</p>
				</div>
				<div class="grid grid-cols-2 gap-4">
					<div
						class="flex items-center justify-center rounded bg-gray-50 h-28 dark:bg-gray-800"
					>
						<p class="text-2xl text-gray-400 dark:text-gray-500">
							<svg
								class="w-3.5 h-3.5"
								aria-hidden="true"
								xmlns="http://www.w3.org/2000/svg"
								fill="none"
								viewBox="0 0 18 18"
							>
								<path
									stroke="currentColor"
									stroke-linecap="round"
									stroke-linejoin="round"
									stroke-width="2"
									d="M9 1v16M1 9h16"
								/>
							</svg>
						</p>
					</div>
					<div
						class="flex items-center justify-center rounded bg-gray-50 h-28 dark:bg-gray-800"
					>
						<p class="text-2xl text-gray-400 dark:text-gray-500">
							<svg
								class="w-3.5 h-3.5"
								aria-hidden="true"
								xmlns="http://www.w3.org/2000/svg"
								fill="none"
								viewBox="0 0 18 18"
							>
								<path
									stroke="currentColor"
									stroke-linecap="round"
									stroke-linejoin="round"
									stroke-width="2"
									d="M9 1v16M1 9h16"
								/>
							</svg>
						</p>
					</div>
					<div
						class="flex items-center justify-center rounded bg-gray-50 h-28 dark:bg-gray-800"
					>
						<p class="text-2xl text-gray-400 dark:text-gray-500">
							<svg
								class="w-3.5 h-3.5"
								aria-hidden="true"
								xmlns="http://www.w3.org/2000/svg"
								fill="none"
								viewBox="0 0 18 18"
							>
								<path
									stroke="currentColor"
									stroke-linecap="round"
									stroke-linejoin="round"
									stroke-width="2"
									d="M9 1v16M1 9h16"
								/>
							</svg>
						</p>
					</div>
					<div
						class="flex items-center justify-center rounded bg-gray-50 h-28 dark:bg-gray-800"
					>
						<p class="text-2xl text-gray-400 dark:text-gray-500">
							<svg
								class="w-3.5 h-3.5"
								aria-hidden="true"
								xmlns="http://www.w3.org/2000/svg"
								fill="none"
								viewBox="0 0 18 18"
							>
								<path
									stroke="currentColor"
									stroke-linecap="round"
									stroke-linejoin="round"
									stroke-width="2"
									d="M9 1v16M1 9h16"
								/>
							</svg>
						</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>

<style></style>
