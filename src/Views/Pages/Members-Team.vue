<script setup>
	import { onMounted, ref } from "vue";
	import SiddebarWithNavbar from "../../components/SidebarWithNavbar.vue";
	import { useStore } from "vuex";
	import { useRoute } from "vue-router";
	import axios from "axios";
	const store = useStore();
	const route = useRoute();
	const userData = ref("");
	const teamId = ref("");
	const memberTeam = ref([]);
	const showModal = ref(false); // Added ref for modal visibility
	const editedMember = ref({}); // Added re

	onMounted(() => {
		userData.value = store.getters.getUserData;
		teamId.value = route.params.teamId;
		console.log(teamId.value);
		console.log(userData.value);
		getAllByTeamId();
	});

	const getAllByTeamId = async () => {
		const id = teamId.value;

		try {
			axios.get(`/member/${id}`).then((response) => {
				console.log(response.data);
				memberTeam.value = response.data;
			});
		} catch (e) {
			console.error(e);
		}
	};

	const editMember = (member) => {
		// Populate editedMember with the member data
		editedMember.value = { ...member };
		showModal.value = true;
	};

	const closeModal = () => {
		// Reset editedMember and close modal
		editedMember.value = {};
		showModal.value = false;
	};

	const submitForm = async () => {
		try {
			const response = await axios.put(
				`/member/${editedMember.value.id}`,
				editedMember.value
			);
			console.log("Member updated:", response.data);
			alert("Updated");
			closeModal();
			getAllByTeamId();
		} catch (error) {
			console.error("Error updating member:", error);
			alert("error");
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
				<div
					class="p-4 border-2 text-2xl font-semibold border-gray-200 border-opacity-100 rounded-lg dark:border-gray-700 mt-5 mb-5"
				>
					Teams Member
				</div>
				<div class="relative overflow-x-auto shadow-md sm:rounded-lg">
					<table
						class="w-full text-sm text-left rtl:text-right text-gray-500 dark:text-gray-400"
					>
						<thead
							class="text-xs text-gray-700 uppercase border-2 border-b-stone-700 bg-gray-50 dark:bg-gray-700 dark:text-gray-400"
						>
							<tr>
								<th scope="col" class="px-6 py-3">Member</th>
								<th scope="col" class="px-6 py-3">Position</th>
								<th scope="col" class="px-6 py-3">Awards</th>
								<th scope="col" class="px-6 py-3">Team</th>
								<th scope="col" class="px-6 py-3">Action</th>
							</tr>
						</thead>
						<tbody>
							<tr v-for="member in memberTeam" :key="member.id">
								<th
									scope="row"
									class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white"
								>
									{{ member.nameMember }}
								</th>
								<td class="px-6 py-4">{{ member.position }}</td>
								<td class="px-6 py-4">{{ member.awards.nameAward }}</td>
								<td class="px-6 py-4">{{ member.team.nameTeam }}</td>
								<td class="px-6 py-4">
									<a
										@click="editMember(member)"
										href="#"
										class="font-medium text-blue-600 dark:text-blue-500 hover:underline"
										>Edit</a
									>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- Modal -->
	<div
		class="fixed z-10 inset-0 overflow-y-auto mt-14"
		v-if="showModal"
		aria-labelledby="modal-title"
		role="dialog"
		aria-modal="true"
	>
		<div
			class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0"
		>
			<div
				class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"
				aria-hidden="true"
			></div>

			<span
				class="hidden sm:inline-block sm:align-middle sm:h-screen"
				aria-hidden="true"
				>&#8203;</span
			>

			<div
				class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full"
				role="dialog"
				aria-labelledby="modal-title"
				aria-describedby="modal-description"
			>
				<div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
					<div class="sm:flex sm:items-start">
						<div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
							<h3
								class="text-lg leading-6 font-medium text-gray-900"
								id="modal-title"
							>
								Edit Member
							</h3>
							<div class="mt-2">
								<form @submit.prevent="submitForm">
									<div class="mb-4">
										<label
											for="nameMember"
											class="block text-gray-700 text-sm font-bold mb-2"
											>Member Name:</label
										>
										<input
											v-model="editedMember.nameMember"
											@input="
												editedMember.nameMember =
													editedMember.nameMember.toUpperCase()
											"
											type="text"
											id="nameMember"
											name="nameMember"
											class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
										/>
									</div>
									<div class="mb-4">
										<label
											for="position"
											class="block text-gray-700 text-sm font-bold mb-2"
											>Position:</label
										>
										<input
											v-model="editedMember.position"
											@input="
												editedMember.position =
													editedMember.position.toUpperCase()
											"
											type="text"
											id="position"
											name="position"
											class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
										/>
									</div>
									<div class="mb-4">
										<label
											for="awards"
											class="block text-gray-700 text-sm font-bold mb-2"
											>Awards:</label
										>
										<input
											disabled
											v-model="editedMember.awards.nameAward"
											type="text"
											id="awards"
											name="awards"
											class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
										/>
									</div>
									<div class="mb-4">
										<label
											for="team"
											class="block text-gray-700 text-sm font-bold mb-2"
											>Team:</label
										>
										<input
											disabled
											v-model="editedMember.team.nameTeam"
											type="text"
											id="team"
											name="team"
											class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
										/>
									</div>
									<button
										type="submit"
										class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
									>
										Save
									</button>
									<button
										type="button"
										@click="closeModal"
										class="ml-2 bg-gray-300 hover:bg-gray-400 text-gray-800 font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
									>
										Cancel
									</button>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>

<style>
	input {
		border: 2px solid transparent;
		border-radius: 5px;
		padding: 10px;
		transition: all 0.3s ease;
	}

	input:hover {
		border-color: #3498db;
		box-shadow: 0px 0px 10px 0px rgba(52, 152, 219, 0.5);
	}
	input:disabled {
		cursor: not-allowed;
	}
</style>
