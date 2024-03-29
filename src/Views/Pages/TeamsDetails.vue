<script setup>
import { onMounted, ref } from "vue";
import SiddebarWithNavbar from "../../components/SidebarWithNavbar.vue";
import { useStore } from "vuex";
import { useRoute } from "vue-router";
import axios from "axios";
import { initFlowbite } from "flowbite";

const route = useRoute();
const store = useStore();
const userData = ref("");
const teams = ref([]);
const teamId = ref(null);
const selectedMember = ref({});
const showUpdateModal = ref(false); // Add reactive variable for modal visibility

onMounted(() => {
  userData.value = store.getters.getUserData;
  console.log(userData.value);
  teamId.value = route.params.teamId;
  initFlowbite();
  console.log(teamId.value);
  getTeam();
});

const toggleUpdateModal = (member) => {
  console.log("Toggling modal"); // Debug statement
  selectedMember.value = member; // Set selected member
  showUpdateModal.value = !showUpdateModal.value; // Toggle modal visibility
};

const closeUpdateModal = () => {
  showUpdateModal.value = false;
  getTeam();
};

const getTeam = async () => {
  try {
    const response = await axios.get("/team/with-member");
    teams.value = response.data.filter((item) => {
      return item.userId == userData.value.id && item.teamId == teamId.value;
    });
    console.log(teams.value);
  } catch (error) {
    console.error("Get TEAM : " + error);
  }
};

const editMember = async () => {
  if (confirm("Update member ?")) {
    try {
      const member = {
        memberName: selectedMember.value.memberName,
        memberPosition: selectedMember.value.memberPosition,
      };

      const response = await axios.put(
        `member/${selectedMember.value.teamMemberId}`,
        member
      );
      console.log(response.data);
      alert(response.data.message);
    } catch (ex) {
      console.error("Error EDIT : " + ex);
    }
  }
};
const deleteMember = async (memberId) => {
  if (confirm("Delete Member ?")) {
    try {
      const response = await axios.delete(`/member/${memberId}`);
      console.log(response.data);
      getTeam();
      alert(response.data);
    } catch (ex) {
      console.error("Error DELETE :" + ex);
    }
  }
};
</script>

<template>
  <div>
    <SiddebarWithNavbar></SiddebarWithNavbar>
    <section id="header" class="p-4 sm:ml-64">
      <header
        class="p-4 border-2 border-gray-200 border-opacity-100 rounded-lg dark:border-gray-700 mt-14"
      >
        <h1>Team Details</h1>
      </header>
      <main>
        <section
          id="card-member"
          class="p-4 border-2 border-gray-200 border-opacity-100 rounded-lg dark:border-gray-700 mt-4"
        >
          <!-- Iterasi setiap tim -->
          <div
            class="md:flex md:flex-col"
            v-for="(team, index) in teams"
            :key="index"
          >
            <div
              v-for="(event, eventIndex) in team.teamEvent"
              :key="eventIndex"
              class="w-full max-w-xl p-4 mb-4 me-3 bg-white border border-gray-200 rounded-lg shadow sm:p-8 dark:bg-gray-800 dark:border-gray-700"
            >
              <!-- Informasi pada card sesuai dengan data -->
              <div class="flex items-center justify-between mb-4">
                <h5
                  class="text-xl font-bold leading-none text-gray-900 dark:text-white"
                >
                  {{ team.teamName }}
                </h5>
                <p
                  class="text-sm font-medium text-blue-600 hover:underline dark:text-blue-500"
                >
                  {{ event.eventName }}
                </p>
              </div>
              <div class="flow-root">
                <ul
                  role="list"
                  class="divide-y divide-gray-200 dark:divide-gray-700"
                >
                  <template
                    v-for="(member, index) in event.members"
                    :key="index"
                  >
                    <li class="py-1 sm:py-2">
                      <div class="flex items-center">
                        <div class="flex-shrink-0">
                          <!-- Ikona SVG -->
                          <svg
                            class="w-6 h-6 text-gray-800 dark:text-white"
                            aria-hidden="true"
                            xmlns="http://www.w3.org/2000/svg"
                            width="24"
                            height="24"
                            fill="currentColor"
                            viewBox="0 0 24 24"
                          >
                            <path
                              fill-rule="evenodd"
                              d="M12 20a7.966 7.966 0 0 1-5.002-1.756l.002.001v-.683c0-1.794 1.492-3.25 3.333-3.25h3.334c1.84 0 3.333 1.456 3.333 3.25v.683A7.966 7.966 0 0 1 12 20ZM2 12C2 6.477 6.477 2 12 2s10 4.477 10 10c0 5.5-4.44 9.963-9.932 10h-.138C6.438 21.962 2 17.5 2 12Zm10-5c-1.84 0-3.333 1.455-3.333 3.25S10.159 13.5 12 13.5c1.84 0 3.333-1.455 3.333-3.25S13.841 7 12 7Z"
                              clip-rule="evenodd"
                            />
                          </svg>
                        </div>
                        <div class="flex-1 min-w-5 ms-4">
                          <p
                            class="text-sm font-medium text-gray-900 truncate dark:text-white"
                          >
                            <!-- Informasi member -->
                            {{ member.memberName }}
                          </p>
                          <p
                            class="text-sm text-gray-500 truncate dark:text-gray-400"
                          >
                            <!-- Informasi posisi member -->
                            {{ member.memberPosition }}
                          </p>
                        </div>
                        <div
                          class="flex flex-col mt-2 mb-2 items-center gap-1 text-base font-semibold text-gray-900 dark:text-white"
                        >
                          <!-- Modal toggle -->
                          <button
                            data-modal-target="update-modal"
                            data-modal-toggle="update-modal"
                            class="block w-full text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
                            type="button"
                            @click="toggleUpdateModal(member)"
                          >
                            Edit
                          </button>
                          <button
                            @click="deleteMember(member.teamMemberId)"
                            class="block w-full text-white bg-red-700 hover:bg-red-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
                          >
                            Delete
                          </button>
                        </div>
                      </div>
                    </li>
                    <div
                      v-if="showUpdateModal"
                      id="update-modal"
                      data-modal-backdrop="static"
                      tabindex="-1"
                      aria-hidden="true"
                      class="fixed inset-0 z-50 flex items-center justify-center overflow-y-auto overflow-x-hidden"
                    >
                      <!-- Modal content -->
                      <div class="relative p-4 w-full max-w-md max-h-full">
                        <div
                          class="relative bg-white rounded-lg shadow dark:bg-gray-700"
                        >
                          <!-- Modal header -->
                          <div
                            class="flex items-center justify-between p-4 md:p-5 border-b rounded-t dark:border-gray-600"
                          >
                            <h3
                              class="text-xl font-semibold text-gray-900 dark:text-white"
                            >
                              Edit Data Member
                            </h3>
                            <button
                              type="button"
                              @click="closeUpdateModal()"
                              class="end-2.5 text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
                              data-modal-hide="update-modal"
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
                          <div class="p-4 md:p-5">
                            <form
                              @submit.prevent="editMember"
                              class="space-y-4"
                            >
                              <div v-if="selectedMember">
                                <label
                                  for="name"
                                  class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                                >
                                  Name</label
                                >
                                <input
                                  v-model="selectedMember.memberName"
                                  @input="
                                    selectedMember.memberName =
                                      $event.target.value.toUpperCase()
                                  "
                                  type="text"
                                  name="name"
                                  id="name"
                                  class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
                                  required
                                />
                              </div>
                              <div>
                                <label
                                  for="position"
                                  class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                                  >Position
                                </label>
                                <input
                                  v-model="selectedMember.memberPosition"
                                  @input="
                                    selectedMember.memberPosition =
                                      $event.target.value.toUpperCase()
                                  "
                                  type="text"
                                  name="position"
                                  id="position"
                                  class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
                                  required
                                />
                              </div>
                              <button
                                type="submit"
                                class="w-full text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
                              >
                                Update
                              </button>
                            </form>
                          </div>
                        </div>
                      </div>
                    </div>
                  </template>
                </ul>
              </div>
            </div>
          </div>
        </section>
      </main>
    </section>
  </div>
</template>

<style></style>
