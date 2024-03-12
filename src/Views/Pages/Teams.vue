<script setup>
import axios from "axios";
import { computed, onMounted, ref } from "vue";
import { useStore } from "vuex";
import SidebarWithNavbarVue from "../../components/SidebarWithNavbar.vue";

const teamName = ref("");
const description = ref("");
const events = ref([]);
const userData = ref("");
const store = useStore();

// Registeam

const selectedEvent = ref("");
const selectedTeam = ref("");
const memberName = ref("");
const memberPosition = ref("");

const filteredTeams = ref([]);

const currentDate = new Date();
const currentYear = currentDate.getFullYear().toString();
onMounted(() => {
  userData.value = store.getters.getUserData;
  getEvents();
  getTeams();
});

const getEvents = () => {
  axios.get("/event/get-event").then((response) => {
    const filteredEvents = response.data.filter(
      (item) => item.event.eventYear === currentYear
    );

    events.value = filteredEvents.map((item) => item.event);
    console.log(events.value);
  });
};

const getTeams = () => {
  axios
    .get("/team/get-all")
    .then((response) => {
      // Assign data dari response ke filteredTeams.value
      filteredTeams.value = response.data;

      // Sekarang Anda bisa melakukan filtering
      const currentYear = new Date().getFullYear();
      filteredTeams.value = filteredTeams.value.filter((teamObj) => {
        const teamCreatedAtYear = new Date(
          teamObj.team.createdAt
        ).getFullYear();
        return teamCreatedAtYear === currentYear;
      });

      console.log(filteredTeams.value);
    })
    .catch((error) => {
      // Handle error jika terjadi
      console.error("Error fetching teams:", error);
    });
};

const createTeam = async () => {
  const now = new Date();
  const teamData = {
    teamName: teamName.value,
    userId: userData.value.id,
    description: description.value.trim(),
    createdAt: now.toISOString(),
  };

  try {
    const response = await axios.post("/team/create", teamData);
    console.log(response.data);
    alert("Team : " + teamName.value + " Created");
    teamName.value = "";
    description.value = "";
  } catch (error) {
    console.log("error " + error);
    alert(error.response.data);
  }
};

const registerTeam = async () => {
  try {
    const RegisData = {
      memberName: memberName.value,
      memberPosition: memberPosition.value,
      event: {
        eventId: selectedEvent.value,
      },
      team: {
        teamId: selectedTeam.value,
      },
    };
    const regist = await axios.post("/member/create", RegisData);
    console.log(regist.data);
    memberName.value = "";
    memberPosition.value = "";
    alert("Data Saved");
  } catch (error) {
    console.error("Registeam" + error);
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
              <div class="flex gap-2">
                <!-- Modal toggle -->
                <button
                  data-modal-target="create-team-modal"
                  data-modal-toggle="create-team-modal"
                  class="block text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
                  type="button"
                >
                  Create Team
                </button>
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
                              v-model="teamName"
                              @input="
                                teamName = $event.target.value.toUpperCase()
                              "
                              type="text"
                              name="name-event"
                              id="name-event"
                              class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                              placeholder="Team Name"
                              required
                            />
                          </div>
                          <div class="col-span-2">
                            <label
                              for="name-event"
                              class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                              >Description
                            </label>
                            <textarea
                              v-model="description"
                              type="text"
                              name="name-event"
                              id="name-event"
                              class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                              placeholder="Desctiption"
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
                <!-- Modal Add Team Member -->
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
                          Add Team & Member
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
                          <div class="col-span-2">
                            <label
                              for="name-member"
                              class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                              >Member Name
                            </label>
                            <input
                              v-model="memberName"
                              type="text"
                              @input="
                                memberName = $event.target.value.toUpperCase()
                              "
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
