<script setup>
	import { onMounted, ref } from "vue";
	import SiddebarWithNavbar from "../../components/SidebarWithNavbar.vue";
	import { useStore } from "vuex";
	import axios from "axios";

	const store = useStore();
	const userData = ref("");
	const registrations = ref([]);

	onMounted(() => {
		userData.value = store.getters.getUserData;
		console.log(userData.value);
		getRegitrationList();
	});

	const getRegitrationList = () => {
		axios
			.get("/registration/get-all")
			.then((response) => {
				registrations.value = response.data;
				console.log(registrations.value);
			})
			.catch((ex) => {
				console.error("FAIL GET REGISTRAATION : " + ex);
			});
	};

	const formatUploadedDate = (uploadedAt) => {
		const date = new Date(uploadedAt);
		const formattedDate = `${date.getFullYear()}-${
			date.getMonth() + 1
		}-${date.getDate()}`;
		const formattedTime = `${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}`;
		return `${formattedDate} <br>${formattedTime}`;
	};
</script>
<template>
	<div>
		<SiddebarWithNavbar></SiddebarWithNavbar>
		<div class="p-4 sm:ml-64">
			<div
				class="p-4 border-2 border-gray-200 border-opacity-100 rounded-lg dark:border-gray-700 mt-14"
			>
				<div>
					<button
						type="button"
						class="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-blue-600 dark:hover:bg-blue-700 focus:outline-none dark:focus:ring-blue-800"
					>
						Default
					</button>

					<div>
						<h2>Registrations</h2>
						<table>
							<thead>
								<tr>
									<th>Team daw</th>
									<th>Event Name</th>
									<th>File Name</th>
									<th>Uploaded At</th>
									<th>Uploaded By</th>
									<th>Status</th>
									<th>Action</th>
								</tr>
							</thead>
							<tbody>
								<template v-for="registration in registrations">
									<template v-if="registration.uploadFiles.length > 0">
										<tr
											v-for="(file, index) in registration.uploadFiles"
											:key="file.filesId"
										>
											<template v-if="index === 0">
												<td :rowspan="registration.uploadFiles.length">
													{{ registration.team.teamName }}
												</td>
												<td :rowspan="registration.uploadFiles.length">
													{{ registration.event.eventName }}
												</td>
											</template>
											<td>
												<a :href="file.filePath" :download="file.fileName">{{
													file.fileName
												}}</a>
											</td>
											<td v-html="formatUploadedDate(file.uploadedAt)"></td>
											<!-- <td>{{ file.uploadedBy }}</td> -->
											<td>{{ file.approvalStatus }}</td>
											<td>
												<button
													@click="
														approveFile(
															registration.registrationId,
															file.filesId
														)
													"
												>
													Approve
												</button>
											</td>
										</tr>
									</template>
								</template>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>

<style></style>
