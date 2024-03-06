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
	const registeredData = ref([]);

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

	const getRegisteredById = async () => {
		try {
			const result = await axios.get(`/registration/${registrationId.value}`);
			console.log(result.data);
			registeredData.value = result.data;
		} catch (error) {
			console.error("Fail get RegisteredById" + error);
		}
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
				class="w-full max-w-md p-4 mt-4 bg-white border border-gray-200 rounded-lg shadow sm:p-8 dark:bg-gray-800 dark:border-gray-700"
			>
				<div class="flex items-center justify-between mb-4">
					<h5
						class="text-xl font-bold leading-none text-gray-900 dark:text-white"
					>
						{{
							registeredData.team ? registeredData.team.teamName : "Team Name "
						}}
					</h5>
					<a
						href="#"
						class="text-sm font-medium text-blue-600 dark:text-blue-500"
					>
						{{
							registeredData.event
								? registeredData.event.eventName
								: "Event Name "
						}}
					</a>
				</div>
				<div class="flow-root">
					<ul
						v-if="
							registeredData &&
							registeredData.team &&
							registeredData.team.teamMember
						"
						role="list"
						class="divide-y divide-gray-200 dark:divide-gray-700"
					>
						<li
							v-for="(team, index) in registeredData.team.teamMember"
							:key="index"
							class="py-3 sm:py-4"
						>
							<div class="flex items-center">
								<div class="flex-shrink-0"></div>
								<div class="flex-1 min-w-0 ms-4">
									<p
										class="text-sm font-medium text-gray-900 truncate dark:text-white"
									>
										{{ team.memberName }}
									</p>
									<!-- <p
										class="text-sm text-gray-500 truncate dark:text-gray-400"
									></p> -->
								</div>
								<div
									class="inline-flex items-center text-base font-semibold text-gray-900 dark:text-white"
								>
									{{ team.memberPosition }}
								</div>
							</div>
						</li>
					</ul>
				</div>
			</div>

			<div
				class="p-4 border-2 border-gray-200 border-opacity-100 rounded-lg dark:border-gray-700 mt-5"
			>
				<ol
					class="relative border-s border-gray-200 dark:border-gray-700 ms-2 p-4"
					v-if="
						registeredData &&
						registeredData.event &&
						registeredData.event.stages &&
						registeredData.uploadFiles
					"
				>
					<li
						v-for="(stage, index) in registeredData.event.stages"
						:key="index"
						class="mb-10 ms-6"
					>
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
							{{ stage.stageName }}
							<span
								v-for="file in registeredData.uploadFiles.filter(
									(file) =>
										file.registrationId === registeredData.registrationId &&
										file.stageId === stage.stageId
								)"
								:key="file.filesId"
								:class="{
									'bg-green-100 text-green-800':
										file.approvalStatus === 'APPROVE',
									'bg-yellow-100 text-yellow-800':
										file.approvalStatus !== 'APPROVE',
								}"
								class="text-sm font-medium me-2 px-2.5 py-0.5 rounded dark:bg-blue-900 dark:text-blue-300 ms-3"
							>
								{{ file.approvalStatus === "APPROVE" ? "Approved" : "Waiting" }}
							</span>
						</h3>
						<!-- <time
							class="block mb-2 text-sm font-normal leading-none text-gray-400 dark:text-gray-500"
							>Released on January 13th, 2022</time
						> -->
						<p
							class="mb-4 text-base font-normal text-gray-500 dark:text-gray-400"
						>
							{{ stage.description }}
						</p>

						<label
							class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
							for="file_input"
							>Upload file</label
						>
						<input
							class="block w-full text-sm text-gray-900 border border-gray-300 rounded-lg cursor-pointer bg-gray-50 dark:text-gray-400 focus:outline-none dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400"
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
