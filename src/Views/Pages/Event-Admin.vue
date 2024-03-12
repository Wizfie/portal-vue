<template>
  <div>
    <SiddebarWithNavbar></SiddebarWithNavbar>
    <div class="w-full p-4 sm:ml-64 dark:bg-gray-700 dark:text-white">
      <div
        class="p-4 border-2 border-gray-200 border-opacity-100 rounded-lg dark:border-gray-700 mt-14"
      >
        <div>
          <caption
            class="flex justify-start p-2 text-center text-3xl fw-bolder"
          >
            <h1>Registrations List</h1>
          </caption>
          <div
            class="relative overflow-x-auto shadow-md sm:rounded-lg dark:bg-gray-800"
          >
            <table
              class="w-full text-sm text-left rtl:text-right text-gray-500 dark:text-white bg-slate-400 border-b-4 border border-gray-200 rounded-lg"
            >
              <thead
                class="text-xs text-gray-700 uppercase text-center bg-gray-400 dark:bg-gray-700 dark:text-gray-400"
              >
                <tr>
                  <th scope="col" class="px-6 py-3">No</th>
                  <th scope="col" class="px-6 py-3">Team</th>
                  <th scope="col" class="px-6 py-3">Event Name</th>
                  <th scope="col" class="px-6 py-3">File Name</th>
                  <th scope="col" class="px-6 py-3">Uploaded At</th>
                  <th scope="col" class="px-6 py-3">Status</th>
                  <th scope="col" class="px-6 py-3">Action</th>
                </tr>
              </thead>
              <tbody>
                <template
                  v-for="(registration, registrationIndex) in registrations"
                >
                  <template v-if="registration.uploadFiles.length > 0">
                    <tr
                      v-for="(file, index) in registration.uploadFiles"
                      :key="file.filesId"
                      class="bg-white border-2 dark:bg-gray-800 dark:border-gray-700"
                    >
                      <template v-if="index === 0">
                        <th
                          :rowspan="registration.uploadFiles.length"
                          scope="row"
                          class="px-6 py-4 font-medium border-2 text-center text-gray-900 whitespace-nowrap dark:text-white hover:bg-gray-200 dark:hover:bg-gray-600"
                        >
                          {{ registrationIndex + 1 }}
                        </th>
                        <th
                          :rowspan="registration.uploadFiles.length"
                          scope="row"
                          class="px-6 py-4 font-medium border-8 text-center text-gray-900 whitespace-nowrap dark:text-white hover:bg-gray-200 dark:hover:bg-gray-600"
                        >
                          {{ registration.team.teamName }}
                        </th>
                        <td
                          :rowspan="registration.uploadFiles.length"
                          class="px-6 py-4 text-center border-2 bg-stone-800 hover:bg-gray-200 dark:hover:bg-gray-600"
                        >
                          {{ registration.event.eventName }}
                        </td>
                      </template>
                      <td
                        class="px-6 py-4 hover:bg-gray-200 dark:hover:bg-gray-600"
                      >
                        <a
                          :href="file.filePath"
                          :download="file.fileName"
                          class="font-medium text-blue-600 dark:text-blue-500 hover:underline hover:bg-gray-200 dark:hover:bg-gray-600"
                        >
                          {{ file.fileName }}
                        </a>
                      </td>
                      <td
                        class="px-6 py-4 border-2 text-center hover:bg-gray-200 dark:hover:bg-gray-600"
                        v-html="formatUploadedDate(file.uploadedAt)"
                      ></td>
                      <td
                        class="px-6 py-4 border-2 text-center hover:bg-gray-200 dark:hover:bg-gray-600"
                      >
                        {{ file.approvalStatus }}
                      </td>
                      <td
                        class="w-full px-6 py-6 flex gap-2 justify-center text-center hover:bg-gray-200 dark:hover:bg-gray-600"
                      >
                        <button
                          @click="
                            approveFile(
                              registration.registrationId,
                              file.filesId
                            )
                          "
                          class="font-medium p-2 text-white rounded-md bg-blue-600 dark:text-blue-500"
                        >
                          Approve
                        </button>
                        <button
                          @click="
                            approveFile(
                              registration.registrationId,
                              file.filesId
                            )
                          "
                          class="font-medium p-2 bg-red-500 rounded-md text-white dark:text-blue-500"
                        >
                          Reject
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

<script setup>
import { onMounted, ref } from "vue";
import SiddebarWithNavbar from "../../components/SidebarWithNavbar.vue";
import { useStore } from "vuex";
import axios from "axios";

const store = useStore();
const userData = ref("");
const registrations = ref([]);
const isDarkMode = ref(false);

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

const toggleDarkMode = () => {
  isDarkMode.value = !isDarkMode.value;
};
</script>

<style>
/* Style tambahan untuk mode gelap */
.dark {
  background-color: #1f2937;
}
</style>
