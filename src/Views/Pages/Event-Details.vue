<script setup>
	import { onMounted, ref } from "vue";
	import SiddebarWithNavbar from "../../components/SidebarWithNavbar.vue";
	import { useStore } from "vuex";
	import { useRoute, useRouter } from "vue-router";
	import axios from "axios";

	const store = useStore();
	const userData = ref("");
	const registrationId = ref(null);
	const router = useRouter();
	const route = useRoute();

	// Methods
	const goBack = () => {
		router.back();
	};

	onMounted(() => {
		userData.value = store.getters.getUserData;
		console.log(userData.value);
		//
		registrationId.value = route.params.registrationId;
		console.log(registrationId.value);
		getRegisteredById();
	});

	const getRegisteredById = () => {
		try {
			const result = axios.get(`/registration/${registrationId.value}`);
			console.log(result.value);
		} catch (error) {}
	};
</script>
<template>
	<div>
		<SiddebarWithNavbar></SiddebarWithNavbar>
		<div class="p-4 sm:ml-64">
			<div
				class="p-4 border-2 border-gray-200 border-opacity-100 rounded-lg dark:border-gray-700 mt-14"
			>
				<h1 class="text-xl">Details</h1>
			</div>
			<div
				class="p-4 border-2 border-gray-200 border-opacity-100 rounded-lg dark:border-gray-700 mt-14"
			>
				<h1 class="text-2xl">Team</h1>
				<small>Event</small>
			</div>
			<div
				class="p-4 border-2 border-gray-200 border-opacity-100 rounded-lg dark:border-gray-700 mt-5"
			>
				<ol
					class="relative border-s border-gray-200 dark:border-gray-700 ms-2 p-4"
				>
					<li class="mb-10 ms-6">
						<span
							class="absolute flex items-center justify-center w-6 h-6 bg-blue-100 rounded-full -start-3 ring-8 ring-white dark:ring-gray-900 dark:bg-blue-900"
						>
							<svg
								class="w-2.5 h-2.5 text-blue-800 dark:text-blue-300"
								aria-hidden="true"
								xmlns="http://www.w3.org/2000/svg"
								fill="currentColor"
								viewBox="0 0 20 20"
							>
								<path
									d="M20 4a2 2 0 0 0-2-2h-2V1a1 1 0 0 0-2 0v1h-3V1a1 1 0 0 0-2 0v1H6V1a1 1 0 0 0-2 0v1H2a2 2 0 0 0-2 2v2h20V4ZM0 18a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V8H0v10Zm5-8h10a1 1 0 0 1 0 2H5a1 1 0 0 1 0-2Z"
								/>
							</svg>
						</span>
						<h3
							class="flex items-center mb-1 text-lg font-semibold text-gray-900 dark:text-white"
						>
							Flowbite Application UI v2.0.0
							<span
								class="bg-blue-100 text-blue-800 text-sm font-medium me-2 px-2.5 py-0.5 rounded dark:bg-blue-900 dark:text-blue-300 ms-3"
								>Latest</span
							>
						</h3>
						<time
							class="block mb-2 text-sm font-normal leading-none text-gray-400 dark:text-gray-500"
							>Released on January 13th, 2022</time
						>
						<p
							class="mb-4 text-base font-normal text-gray-500 dark:text-gray-400"
						>
							Get access to over 20+ pages including a dashboard layout, charts,
							kanban board, calendar, and pre-order E-commerce & Marketing
							pages.
						</p>

						<label
							class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
							for="file_input"
							>Upload file</label
						>
						<input
							class="block w-1/2 text-sm text-gray-900 border border-gray-300 rounded-lg cursor-pointer bg-gray-50 dark:text-gray-400 focus:outline-none dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400"
							id="file_input"
							type="file"
						/>
					</li>
				</ol>
			</div>
		</div>
	</div>
</template>

<style></style>
