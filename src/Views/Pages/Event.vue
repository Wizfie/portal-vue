<script setup>
	import axios from "axios";
	import { initFlowbite } from "flowbite";
	import { onMounted, ref } from "vue";
	import SidebarWithNavbar from "../../components/SidebarWithNavbar.vue";

	let token = "Bearer " + localStorage.getItem("authToken");
	const role = ref("");

	// Variable
	let eventName = ref("");
	let eventYear = ref("");
	let steps = ref([]);

	// Fungsi untuk menambahkan langkah-langkah baru
	const addStep = () => {
		steps.value.push({ name: "", startDate: "", endDate: "", description: "" });
	};

	const removeStep = () => {
		steps.value.pop();
	};

	onMounted(() => {
		const userData = localStorage.getItem("userData");
		if (userData) {
			const parseJson = JSON.parse(userData);
			role.value = parseJson.role;
		}
		initFlowbite();
	});

	const resetForm = () => {
		eventName.value = "";
		eventYear.value = "";
		steps.value = [];
	};

	const createEvent = async () => {
		try {
			// Buat event
			const eventData = {
				eventName: eventName.value,
				eventYear: eventYear.value,
			};
			const eventResponse = await axios.post("/create-event", eventData, {
				headers: {
					Authorization: token,
				},
			});
			const eventId = eventResponse.data.eventId;
			console.log(eventResponse.data);
			console.log(eventId);

			// Tambahkan langkah-langkah
			for (const step of steps.value) {
				const stepData = {
					stepName: step.name,
					startDate: step.startDate,
					endDate: step.endDate,
					description: step.description,
				};
				await axios.post(`/step/add/${eventId}`, stepData, {
					headers: {
						Authorization: token,
					},
				});
			}

			const emailData = {
				to: "wizfiee@gmail.com",
				from: "wizfie@outlook.com",
				subject: "Event Baru",
				name: "Kadal",
				text: `Event ${eventName.value} Sudah Buka Pendaftarannya silahkan cek di Web `,
			};

			const email = await axios.post("/email/send", emailData, {
				headers: {
					Authorization: token,
				},
			});
			console.log(email.data);
			// Reset form
			resetForm();
			alert("Event and steps created successfully");
		} catch (error) {
			console.error("Error:", error);
			// Handle error
		}
	};
</script>

<template>
	<div>
		<SidebarWithNavbar></SidebarWithNavbar>
		<div class="p-4 sm:ml-64">
			<div
				class="p-4 border-2 border-gray-200 border-opacity-100 rounded-lg dark:border-gray-700 mt-14"
			>
				<h1 class="text-2xl">Registration</h1>
			</div>
			<div
				v-show="role === `ADMIN`"
				class="p-4 border-2 border-gray-200 border-opacity-100 rounded-lg dark:border-gray-700 mt-5"
			>
				<div>
					<!-- Modal toggle -->
					<button
						data-modal-target="awards-modal"
						data-modal-toggle="awards-modal"
						class="block text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
						type="button"
					>
						Add Event
					</button>

					<!-- Main modal -->
					<div
						data-modal-backdrop="static"
						id="awards-modal"
						tabindex="1"
						aria-hidden="true"
						class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full"
					>
						<div class="relative p-4 w-full max-w-md max-h-full">
							<!-- Modal content -->
							<div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
								<!-- Modal header -->
								<div
									class="flex items-center justify-between p-4 md:p-5 border-b rounded-t dark:border-gray-600"
								>
									<h3
										class="text-lg font-semibold text-gray-900 dark:text-white"
									>
										Create New Event
									</h3>
									<button
										type="button"
										@click="resetForm"
										class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
										data-modal-toggle="awards-modal"
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
								<form @submit.prevent="createEvent" class="p-4 md:p-5">
									<div class="grid gap-4 mb-4 grid-cols-2">
										<div class="col-span-2">
											<label
												for="name-event"
												class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
											>
												Name Event
											</label>
											<input
												v-model="eventName"
												type="text"
												name="name-event"
												id="name-event"
												class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
												placeholder="Name Event"
												required
											/>
										</div>
										<div class="col-span-2">
											<label
												for="description"
												class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
											>
												Event Year</label
											>
											<input
												v-model="eventYear"
												type="text"
												required
												id="event-year"
												class="block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
												placeholder="Year"
											/>
										</div>
										<div class="col-span-2">
											<strong class="underline">Steps</strong>
										</div>
										<div
											class="col-span-2"
											v-for="(step, index) in steps"
											:key="index"
										>
											<label
												for="step"
												class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
											>
												Step Name</label
											>
											<input
												v-model="step.name"
												required
												type="text"
												id="step"
												class="block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
												placeholder="Name Steps"
											/>
											<div class="flex gap-2">
												<div class="w-full">
													<label
														for="start-date"
														class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
													>
														Start Date
													</label>
													<input
														v-model="step.startDate"
														required
														type="date"
														id="start-date"
														class="block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
													/>
												</div>
												<div class="w-full">
													<label
														for="end-date"
														class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
													>
														End Date
													</label>
													<input
														v-model="step.endDate"
														required
														type="date"
														id="end-date"
														class="block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
													/>
												</div>
											</div>
											<label
												for="description"
												class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
											>
												Description</label
											>
											<textarea
												v-model="step.description"
												required
												id="description"
												class="block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
												placeholder="Description"
											></textarea>
											<hr class="mb-3" />
										</div>
									</div>
									<div>
										<button
											class="text-white inline-flex items-center mb-3 bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
											@click.prevent="addStep"
										>
											Add
										</button>
										<button
											class="text-white inline-flex items-center mb-3 ms-2 bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
											@click.prevent="removeStep"
										>
											Remove
										</button>
									</div>
									<hr class="mb-3" />

									<!-- Daftar Langkah yang Sudah Ditambahkan -->
									<!-- <div v-if="steps.length > 0" class="mt-4">
										<h2 class="text-lg font-semibold">Steps Added:</h2>
										<ul>
											<li v-for="(step, index) in steps" :key="index">
												Name Step: {{ step.name }} <br />
												Start Date: {{ step.startDate }} <br />
												End Date: {{ step.endDate }} <br />
												Description: {{ step.description }}
												<hr class="my-2" />
											</li>
										</ul>
									</div> -->

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
</template>

<style></style>
