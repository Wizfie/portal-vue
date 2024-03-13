<template>
  <div>
    <!-- Spinner loading -->
    <div
      v-if="loading"
      class="absolute inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50"
    >
      <div role="status">
        <svg
          aria-hidden="true"
          class="inline w-24 h-24 text-gray-200 animate-spin dark:text-gray-600 fill-gray-600 dark:fill-gray-300"
          viewBox="0 0 100 101"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path
            d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z"
            fill="currentColor"
          />
          <path
            d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z"
            fill="currentFill"
          />
        </svg>
        <br />
        <span>Loading...</span>
      </div>
    </div>
    <SiddebarWithNavbar></SiddebarWithNavbar>
    <div class="w-full h-full p-4 sm:ml-64 dark:bg-gray-700 dark:text-white">
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
                  <th scope="col" class="px-6 py-3">File Name</th>
                  <th scope="col" class="px-6 py-3">Uploaded At</th>
                  <th scope="col" class="px-6 py-3">Status</th>
                  <th scope="col" class="px-6 py-3">Action</th>
                </tr>
              </thead>
              <tbody>
                <template v-if="registrations.length > 0">
                  <template
                    v-for="(registration, registrationIndex) in registrations"
                  >
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
                          class="px-6 py-4 font-medium border-2 text-center text-gray-900 whitespace-nowrap dark:text-white hover:bg-gray-200 dark:hover:bg-gray-600"
                        >
                          <small>
                            {{ registration.event.eventName }}
                          </small>
                          <br />
                          <br />
                          {{ registration.team.teamName }}
                        </th>
                      </template>
                      <template
                        v-if="registration.event && registration.event.stages"
                      >
                        <td
                          class="px-6 py-4 hover:bg-gray-200 dark:hover:bg-gray-600"
                        >
                          <small>
                            {{ getStageName(file.stageId) }}
                          </small>
                          <br />
                          <button
                            @click="downloadFile(file.fileName)"
                            class="font-medium text-blue-600 dark:text-blue-500 hover:underline hover:bg-gray-200 dark:hover:bg-gray-600"
                          >
                            {{ file.fileName }}
                          </button>
                        </td>
                      </template>
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
                <div class="p-2">
                  <tr>
                    <td colspan="6"><span>No Data</span></td>
                  </tr>
                </div>
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

// Variable
const store = useStore();
const token = "Bearer " + localStorage.getItem("authToken");
const userData = ref("");
const registrations = ref([]);
const loading = ref(false);

onMounted(() => {
  userData.value = store.getters.getUserData;
  console.log(userData.value);
  getRegitrationList();
});

// Main Method

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

const downloadFile = (fileName) => {
  loading.value = true;
  axios({
    url: `/file/${fileName}`,
    method: "GET",
    responseType: "blob",
  })
    .then((response) => {
      loading.value = false;

      const url = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement("a");
      link.href = url;
      link.setAttribute("download", fileName);
      document.body.appendChild(link);
      link.click();
    })
    .catch((error) => {
      loading.value = false;
      console.error("Error downloading file:", error);
    });
};

// Utils
const formatUploadedDate = (uploadedAt) => {
  const date = new Date(uploadedAt);
  const formattedDate = `${date.getFullYear()}-${
    date.getMonth() + 1
  }-${date.getDate()}`;
  const formattedTime = `${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}`;
  return `${formattedDate} <br>${formattedTime}`;
};
const getStageName = (stageId) => {
  // Cari objek stage yang sesuai dengan stageId
  const stage = registrations.value
    .map((registration) => registration.event.stages)
    .flat()
    .find((stage) => stage.stageId === stageId);

  // Jika stage ditemukan, kembalikan nama stagenya
  // Jika tidak, kembalikan string kosong
  return stage ? stage.stageName : "";
};
</script>

<style>
/* Style tambahan untuk mode gelap */
.dark {
  background-color: #1f2937;
}
</style>
