<script setup>
	import axios from "axios";
	import { computed, onMounted, ref } from "vue";
	import { useStore } from "vuex";
	import SidebarWithNavbarVue from "../../components/SidebarWithNavbar.vue";

	let awards = ref([]);
	let teams = ref([]);
	let nameTeam = ref("");
	let idAward = ref(null);
	let idTeam = ref(null);
	let memberName = ref("");
	let memberPosition = ref("");
	let teamWithMembers = ref([]);
	const userData = ref("");
	const store = useStore();
	onMounted(() => {
		userData.value = store.getters.getUserData;
		getAwarding();
		getTeamWithMembers();
	});

	const filteredTeam = computed(() => {
		console.log("Teams:", teams.value);
		console.log("User Data:", userData.value);
		return teamWithMembers.value.filter(
			(team) => team.idUser == userData.value.id
		);
	});

	const getAwarding = async () => {
		axios.get("/get-all-awards").then((response) => {
			awards.value = response.data;
		});
	};

	const createTeam = async () => {
		const teamData = {
			nameTeam: nameTeam.value,
			idUser: userData.value.id,
		};
		try {
			// console.log(teamData);
			axios.post("/team/create", teamData).then((response) => {
				nameTeam.value = "";
				alert("OK");
				getTeam();
			});
		} catch (error) {
			console.log("error " + error);
			alert("Error");
		}
	};

	const addMemberTeam = async () => {
		const memberData = {
			nameMember: memberName.value,
			position: memberPosition.value,
			idTeam: idTeam.value,
			idAwards: idAward.value,
		};

		try {
			// console.log(memberData);
			axios.post("/member/add", memberData).then((response) => {
				console.log(response.data);

				alert("Succes Added ");
				memberName.value = "";
				memberPosition.value = "";

				getTeamWithMembers();
			});
		} catch (error) {
			console.error("Error add member " + error);
		}
	};

	const getTeamWithMembers = async () => {
		try {
			await axios.get("team/with-members").then((response) => {
				console.log(response.data);
				teamWithMembers.value = response.data;
			});
		} catch (error) {
			console.error("error get Team with member" + error);
		}
	};
</script>

<template>
	<SidebarWithNavbarVue></SidebarWithNavbarVue>
	<div class="p-4 sm:ml-64">
		<div
			class="p-4 border-2 border-gray-200 border-opacity-100 rounded-lg dark:border-gray-700 mt-14"
		>
			<div>
				<div>
					<h1 class="font-medium text-3xl p-6">Teams</h1>

					<div
						class="p-4 border-2 border-gray-200 border-opacity-100 rounded-lg dark:border-gray-700 mt-5"
					>
						<div class="flex gap-4">
							<div>
								<!-- Modal toggle -->
								<button
									data-modal-target="create-team-modal"
									data-modal-toggle="create-team-modal"
									class="block text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
									type="button"
								>
									Create Team
								</button>

								<!-- Main modal -->
								<div
									data-modal-backdrop="static"
									id="create-team-modal"
									tabindex="1"
									aria-hidden="true"
									class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full"
								>
									<div class="relative p-4 w-full max-w-md max-h-full">
										<!-- Modal content -->
										<div
											class="relative bg-white rounded-lg shadow dark:bg-gray-700"
										>
											<!-- Modal header -->
											<div
												class="flex items-center justify-between p-4 md:p-5 border-b rounded-t dark:border-gray-600"
											>
												<h3
													class="text-lg font-semibold text-gray-900 dark:text-white"
												>
													Create New Team
												</h3>
												<button
													type="button"
													class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
													data-modal-toggle="create-team-modal"
												>
													<svg
														class="w-3 h-3"
														aria-hidden="true"
														xmlns="http://www.w3.org/2000/svg"
														fill="none"
														viewBox="0 0 14 14"
													>
														<path
															stroke="currentColor"
															stroke-linecap="round"
															stroke-linejoin="round"
															stroke-width="2"
															d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"
														/>
													</svg>
													<span class="sr-only">Close modal</span>
												</button>
											</div>
											<!-- Modal body -->
											<form @submit.prevent="createTeam" class="p-4 md:p-5">
												<div class="grid gap-4 mb-4 grid-cols-2">
													<div class="col-span-2">
														<label
															for="name-event"
															class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
															>Team Name
														</label>
														<input
															v-model="nameTeam"
															@input="
																nameTeam = $event.target.value.toUpperCase()
															"
															type="text"
															name="name-event"
															id="name-event"
															class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
															placeholder="Team Name"
															required
														/>
													</div>
												</div>
												<button
													type="submit"
													class="text-white inline-flex items-center bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
												>
													Save
												</button>
											</form>
										</div>
									</div>
								</div>
							</div>
							<div>
								<!-- Modal toggle -->
								<button
									data-modal-target="add-team-member-modal"
									data-modal-toggle="add-team-member-modal"
									class="block text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
									type="button"
								>
									Add Member Team
								</button>

								<!-- Main modal -->
								<div
									data-modal-backdrop="static"
									id="add-team-member-modal"
									tabindex="1"
									aria-hidden="true"
									class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full"
								>
									<div class="relative p-4 w-full max-w-md max-h-full">
										<!-- Modal content -->
										<div
											class="relative bg-white rounded-lg shadow dark:bg-gray-700"
										>
											<!-- Modal header -->
											<div
												class="flex items-center justify-between p-4 md:p-5 border-b rounded-t dark:border-gray-600"
											>
												<h3
													class="text-lg font-semibold text-gray-900 dark:text-white"
												>
													Add New Team Member
												</h3>
												<button
													type="button"
													class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
													data-modal-toggle="add-team-member-modal"
												>
													<svg
														class="w-3 h-3"
														aria-hidden="true"
														xmlns="http://www.w3.org/2000/svg"
														fill="none"
														viewBox="0 0 14 14"
													>
														<path
															stroke="currentColor"
															stroke-linecap="round"
															stroke-linejoin="round"
															stroke-width="2"
															d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"
														/>
													</svg>
													<span class="sr-only">Close modal</span>
												</button>
											</div>
											<!-- Modal body -->
											<form @submit.prevent="addMemberTeam" class="p-4 md:p-5">
												<div class="grid gap-4 mb-4 grid-cols-2">
													<div class="col-span-2">
														<label
															for="countries"
															class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
															>Select a Team</label
														>
														<select
															id="countries"
															required
															v-model="idTeam"
															class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
														>
															<option disabled value="Select Award"></option>
															<option
																v-for="team in filteredTeam"
																:key="team.id"
																:value="team.id"
															>
																{{ team.nameTeam }}
															</option>
														</select>
													</div>
													<div class="col-span-2">
														<label
															for="countries"
															class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
															>Select an Awarding</label
														>
														<select
															id="countries"
															required
															v-model="idAward"
															class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
														>
															<option disabled value="Select Award"></option>
															<option
																v-for="award in awards"
																:key="award.id"
																:value="award.id"
															>
																{{ award.nameAward }}
															</option>
														</select>
													</div>
													<div class="col-span-2">
														<label
															for="name-member"
															class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
															>Member Name
														</label>
														<input
															v-model="memberName"
															@input="
																memberName = $event.target.value.toUpperCase()
															"
															type="text"
															name="name-member"
															id="name-member"
															class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
															placeholder="Member Name"
															required
														/>
													</div>
													<div class="col-span-2">
														<label
															for="position-member"
															class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
															>Position
														</label>
														<input
															v-model="memberPosition"
															@input="
																memberPosition =
																	$event.target.value.toUpperCase()
															"
															type="text"
															name="position-member"
															id="position-member"
															class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
															placeholder="Position"
															required
														/>
													</div>
												</div>
												<button
													type="submit"
													class="text-white inline-flex items-center bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
												>
													Save
												</button>
											</form>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>

				<div class="relative overflow-x-auto shadow-md sm:rounded-lg mt-5">
					<table
						class="w-full text-sm text-left rtl:text-right text-gray-500 dark:text-gray-400"
					>
						<thead
							class="text-xs text-gray-700 uppercase border-2 bg-slate-600 dark:bg-gray-700 dark:text-gray-400"
						>
							<tr>
								<th scope="col" class="px-6 py-3">No</th>
								<th scope="col" class="px-6 py-3">Team Name</th>
								<th scope="col" class="px-6 py-3">Team Member</th>
								<th scope="col" class="px-6 py-3">
									<span class="sr-only">View</span>
								</th>
							</tr>
						</thead>
						<tbody>
							<tr
								v-for="(team, index) in filteredTeam"
								:key="index"
								class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600"
							>
								<td class="px-6 py-4">{{ index + 1 }}</td>
								<th
									scope="row"
									class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white"
								>
									{{ team.nameTeam }}
								</th>
								<td class="px-6 py-4">
									<router-link
										:to="{ name: 'members', params: { teamId: team.idTeam } }"
										type="button"
										class="font-medium text-blue-600 dark:text-blue-500 hover:underline"
									>
										View
									</router-link>
									<!-- Modal view -->
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</template>

<style></style>
