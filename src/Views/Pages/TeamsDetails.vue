<script setup>
import { onMounted, ref } from "vue";
import SiddebarWithNavbar from "../../components/SidebarWithNavbar.vue";
import { useStore } from "vuex";
import { useRoute } from "vue-router";
import axios from "axios";

const route = useRoute();
const store = useStore();
const userData = ref("");
const teams = ref([]);
const teamId = ref(null);

onMounted(() => {
  userData.value = store.getters.getUserData;
  console.log(userData.value);
  teamId.value = route.params.teamId;
  console.log(teamId.value);

  getTeam();
});

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
                    <li class="py-3 sm:py-4">
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
                        <div class="flex-1 min-w-0 ms-4">
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
                          class="inline-flex items-center text-base font-semibold text-gray-900 dark:text-white"
                        >
                          <button class="text-blue-600 hover:underline">
                            Edit
                          </button>
                        </div>
                      </div>
                    </li>
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
