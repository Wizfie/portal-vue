<script setup>
import axios from "axios";
import { initFlowbite } from "flowbite";
import { onMounted, ref } from "vue";
import SidebarWithNavbar from "../../components/SidebarWithNavbar.vue";

//  identity
const token = "Bearer " + localStorage.getItem("authToken");
const role = ref("");
const userId = ref("");

const eventName = ref("");
const eventYear = ref("");
const steps = ref([]);
const events = ref([]);
const filteredTeams = ref([]);
const stageName = ref("");
const stageDesc = ref("");
const eventIdStage = ref("");
const selectedEvent = ref();
const selectedTeam = ref();
const registrationList = ref([]);
const currentDate = new Date();
const currentYear = currentDate.getFullYear().toString();

// Methods
onMounted(() => {
  initFlowbite();
  const userData = localStorage.getItem("userData");
  if (userData) {
    const parseJson = JSON.parse(userData);
    role.value = parseJson.role;
    userId.value = parseJson.id.toString();
  }
  getEvents();
  fetchTeams();
  getRegistration();
});

const resetForm = () => {
  eventName.value = "";
  eventYear.value = "";
  steps.value = [];
};

const registerTeam = async () => {
  try {
    const registrationData = {
      teamId: selectedTeam.value,
      eventId: selectedEvent.value,
      registrationStatus: "Pending",
      createdBy: userId.value,
    };

    await axios.post("/registration/register", registrationData);

    getRegistration();

    alert("Registration Successful");

    selectedEvent.value = "";
    selectedTeam.value = "";
  } catch (error) {
    console.error("Failed to register team:", error);
  }
};

const createEvent = async () => {
  try {
    if (steps.value.length === 0) {
      alert("Please add steps to the event");
      return;
    }

    const eventData = {
      eventName: eventName.value,
      eventYear: eventYear.value,
    };

    const { data: eventId } = await axios.post(
      "event/create-event",
      eventData,
      {
        headers: { Authorization: token },
      }
    );

    const stepPromises = steps.value.map(
      ({ name, startDate, endDate, description }) => {
        const stepData = { stepName: name, startDate, endDate, description };
        return axios.post(`/step/add/${eventId}`, stepData, {
          headers: { Authorization: token },
        });
      }
    );

    await Promise.all(stepPromises);

    alert("Event and steps created successfully");
    resetForm();
  } catch {
    alert("Failed to create event and steps. Please try again.");
  }
};

const createStage = async () => {
  const data = {
    name: stageName.value,
    description: stageDesc.value,
    eventId: eventIdStage.value,
  };

  try {
    const { data: createdStage } = await axios.post(
      "/event-stage/create",
      data
    );
    alert(`Stage ${createdStage.name} created`);
  } catch (error) {
    console.error("Failed to create stage", error);
  }

  stageName.value = "";
  stageDesc.value = "";
};

const getEvents = () => {
  axios.get("/event/get-event").then((response) => {
    const filteredEvents = response.data.filter(
      (item) => item.event.eventYear === currentYear
    );

    events.value = filteredEvents.map((item) => item.event);
    console.log(events.value);
  });
};

const fetchTeams = async () => {
  try {
    const { data } = await axios.get("/team/get-all");
    filteredTeams.value = data.filter(
      (team) => team.team.userId === userId.value
    );
  } catch (error) {
    console.error("Error fetching teams:", error);
  }
};

const getRegistration = () => {
  axios
    .get("/registration/get-all")
    .then((response) => {
      registrationList.value = response.data.filter((item) => {
        return (
          item.createdBy === userId.value && item.createdAt === currentYear
        );
      });
      console.log(registrationList.value);
    })
    .catch((ex) => {
      console.error("FAIL GET REGISTRAATION : " + ex);
    });
};

// utils
const addStep = () => {
  steps.value.push({ name: "", startDate: "", endDate: "", description: "" });
};

const removeStep = () => {
  steps.value.pop();
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
        <div class="flex gap-2">
          <!-- Modal toggle -->
          <button
            data-modal-target="awards-modal"
            data-modal-toggle="awards-modal"
            class="block text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
            type="button"
          >
            Add Event
          </button>

          <button
            data-modal-target="stages-modal"
            data-modal-toggle="stages-modal"
            class="block text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
            type="button"
          >
            Add Stages
          </button>

          <!-- Main modal Stages -->
          <div
            data-modal-backdrop="static"
            id="stages-modal"
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
                    Create Registration Stages
                  </h3>
                  <button
                    type="button"
                    class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
                    data-modal-toggle="stages-modal"
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
                <form @submit.prevent="createStage" class="p-4 md:p-5">
                  <div class="grid gap-4 mb-4 grid-cols-2">
                    <div class="col-span-2">
                      <label
                        for="name-event"
                        class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                      >
                        Name Stage
                      </label>
                      <input
                        @input="stageName = $event.target.value.toUpperCase()"
                        v-model="stageName"
                        type="text"
                        name="name-event"
                        id="name-event"
                        class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                        placeholder="Name Stage"
                        required
                      />
                    </div>
                    <div class="col-span-2">
                      <label
                        for="select-event"
                        class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                      >
                        Name Stage
                      </label>
                      <select
                        name="select-event"
                        id="select-event"
                        v-model="eventIdStage"
                        required
                        class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                      >
                        <option disabled value="">Select Event</option>
                        <option
                          v-for="event in events"
                          :key="event.eventId"
                          :value="event.eventId"
                        >
                          {{
                            event.length === 0 ? "No Event" : event.eventName
                          }}
                        </option>
                      </select>
                    </div>
                    <div class="col-span-2">
                      <label
                        for="description"
                        class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                      >
                        Description</label
                      >
                      <textarea
                        v-model="stageDesc"
                        type="text"
                        required
                        id="event-year"
                        class="block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                        placeholder="Desc"
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

          <!-- Modal Event -->
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
                        @input="eventName = $event.target.value.toUpperCase()"
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
                        type="number"
                        required
                        id="event-year"
                        class="block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                        placeholder="Year"
                      />
                    </div>
                    <div class="col-span-2">
                      <strong class="underline">Steps Event</strong>
                    </div>

                    <!-- Form untuk step tambahan -->
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
                        @input="step.name = $event.target.value.toUpperCase()"
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

                  <!-- Tombol untuk menambahkan step -->
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
      <!-- v-show="role === `USER`" -->
      <div
        class="p-4 border-2 border-gray-200 border-opacity-100 rounded-lg dark:border-gray-700 mt-5"
      >
        <div>
          <!-- Modal Registration -->

          <button
            data-modal-target="registration-modal"
            data-modal-toggle="registration-modal"
            class="block text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
            type="button"
          >
            Register Event
          </button>

          <!-- Main modal Registration -->
          <div
            data-modal-backdrop="static"
            id="registration-modal"
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
                    Registration Event
                  </h3>
                  <button
                    type="button"
                    class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
                    data-modal-toggle="registration-modal"
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
                <form @submit.prevent="registerTeam" class="p-4 md:p-5">
                  <div class="grid gap-4 mb-4 grid-cols-2">
                    <div class="col-span-2">
                      <label
                        for="selet-team"
                        class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                        >Select a Team</label
                      >
                      <select
                        id="selet-team"
                        required
                        v-model="selectedTeam"
                        class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                      >
                        <option disabled>Select Team</option>
                        <template v-if="filteredTeams.length === 0">
                          <option disabled>Belum Ada Team</option>
                        </template>
                        <option
                          v-for="team in filteredTeams"
                          :key="team.team.teamId"
                          :value="team.team.teamId"
                        >
                          {{ team.team.teamName }}
                        </option>
                      </select>
                    </div>
                    <div class="col-span-2">
                      <label
                        for="select-event"
                        class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                        >Select an Event</label
                      >
                      <select
                        id="select-event"
                        required
                        v-model="selectedEvent"
                        class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                      >
                        <option disabled>Select Event</option>
                        <option
                          v-for="event in events"
                          :key="event.eventId"
                          :value="event.eventId"
                        >
                          {{ event.eventName }}
                        </option>
                      </select>
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

      <div
        class="p-4 border-2 border-gray-200 border-opacity-100 rounded-lg dark:border-gray-700 mt-5"
      >
        <div class="relative overflow-x-auto shadow-md sm:rounded-lg mt-2">
          <table
            class="w-full text-sm text-left rtl:text-right text-gray-500 dark:text-gray-400"
          >
            <caption>
              <h1 class="text-2xl my-4">Event List</h1>
            </caption>
            <thead
              class="text-xs text-gray-700 uppercase bg-gray-400 dark:bg-gray-700 dark:text-gray-400"
            >
              <tr>
                <th scope="col" class="px-6 py-3">No</th>
                <th scope="col" class="px-6 py-3">Team</th>
                <th scope="col" class="px-6 py-3">Event</th>
                <th scope="col" class="px-6 py-3">Status</th>
                <th scope="col" class="px-6 py-3">Action</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="(register, index) in registrationList"
                :key="register.registrationId"
                class="bg-white border-b-2 dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600"
              >
                <td class="px-6 py-4">{{ index + 1 }}</td>
                <th
                  scope="row"
                  class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white"
                >
                  {{ register.team.teamName }}
                </th>
                <td class="px-6 py-4">{{ register.event.eventName }}</td>
                <td class="px-6 py-4">{{ register.registrationStatus }}</td>
                <td class="px-6 py-4">
                  <router-link
                    :to="{
                      name: 'eventDetail',
                      params: { registrationId: register.registrationId },
                    }"
                    class="font-medium text-blue-600 dark:text-blue-500 hover:underline"
                    >Details</router-link
                  >
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
