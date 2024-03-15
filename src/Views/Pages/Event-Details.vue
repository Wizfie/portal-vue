<script setup>
import { onMounted, ref } from "vue";
import SiddebarWithNavbar from "../../components/SidebarWithNavbar.vue";
import { useStore } from "vuex";
import { useRoute } from "vue-router";
import axios from "axios";

const store = useStore();
const userData = ref("");
const registrationId = ref(null);
const route = useRoute();
const registeredData = ref([]);
const uploading = ref({});
const fileInput = ref(null);
const fileInputKey = ref(0);
const selectedFiles = ref({});
const isLoading = ref(false);

onMounted(() => {
  userData.value = store.getters.getUserData;
  registrationId.value = route.params.registrationId;
  getRegisteredById();
});

const uploadFiles = async (stage) => {
  if (confirm("Pastikan File yang di pilih sudah")) {
    uploading.value[stage.stageId] = true;
    const formDataArray = [];

    selectedFiles.value[stage.stageId].forEach((file) => {
      const formData = new FormData();
      formData.append("file", file);
      formData.append(
        "eventName",
        registeredData.value?.event?.eventName || ""
      );
      formData.append("teamName", registeredData.value?.team?.teamName || "");
      formData.append("eventStages", stage?.stageId || "");
      formData.append(
        "registration",
        registeredData.value?.registrationId || ""
      );
      formDataArray.push(formData);
    });

    Promise.all(
      formDataArray.map((formData) => {
        return axios.post("/file/upload", formData);
      })
    )
      .then((responses) => {
        uploading.value[stage.stageId] = false;
        resetFileInput();
        getRegisteredById();
        alert("Upload berhasil");
      })
      .catch((ex) => {
        console.error(ex);
        uploading.value[stage.stageId] = false;
        getRegisteredById();
        resetFileInput();
        alert("Gagal upload file: " + ex);
      });
  }
};

const downloadFile = (fileName) => {
  isLoading.value = true;
  axios({
    url: `/file/${fileName}`,
    method: "GET",
    responseType: "blob",
  })
    .then((response) => {
      isLoading.value = false;

      const url = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement("a");
      link.href = url;
      link.setAttribute("download", fileName);
      document.body.appendChild(link);
      link.click();
    })
    .catch((error) => {
      isLoading.value = false;
      console.error("Error downloading file:", error);
    });
};

const resetFileInput = () => {
  fileInputKey.value += 1;
  selectedFiles.value = {};
};

const removeSelectedFile = (stageId, index) => {
  selectedFiles.value[stageId].splice(index, 1);
  fileInputKey.value += 1;
};

const getRegisteredById = async () => {
  try {
    const result = await axios.get(`/registration/${registrationId.value}`);
    registeredData.value = result.data;
  } catch (error) {
    console.error("Failed to get RegisteredById: " + error);
  }
};

const isUploaded = (stageId) => {
  const filesUploaded = registeredData.value.uploadFiles.filter(
    (file) =>
      file.registrationId === registeredData.value.registrationId &&
      file.stageId === stageId
  );

  return filesUploaded.length > 0;
};

const getFileIndex = (stageId, fileName) => {
  let index = 1;
  const filesForStage = registeredData.value.uploadFiles.filter(
    (file) =>
      file.registrationId === registeredData.value.registrationId &&
      file.stageId === stageId
  );

  for (const file of filesForStage) {
    if (file.fileName === fileName) {
      return index;
    }
    index++;
  }

  return "";
};

const handleFileChange = (event, stage) => {
  const files = event.target.files;
  selectedFiles.value[stage.stageId] = selectedFiles.value[stage.stageId] || [];
  selectedFiles.value[stage.stageId].push(...Array.from(files));
};
</script>

<!-- Main -->
<template>
  <div>
    <SiddebarWithNavbar></SiddebarWithNavbar>
    <div class="p-4 sm:ml-64">
      <div
        class="p-4 border-2 border-gray-200 border-opacity-100 rounded-lg dark:border-gray-700 mt-14"
      >
        <h1 class="text-xl">Details</h1>
      </div>

      <!-- Card Team -->
      <div
        class="w-full max-w-md p-4 mt-4 bg-white border border-gray-200 rounded-lg shadow sm:p-8 dark:bg-gray-800 dark:border-gray-700"
      >
        <div class="flex items-center justify-between mb-4">
          <h5
            class="text-xl font-bold leading-none text-gray-900 dark:text-white"
          >
            {{
              registeredData.team ? registeredData.team.teamName : "Team Name "
            }}
          </h5>
          <span class="text-sm font-medium text-blue-600 dark:text-blue-500">
            {{
              registeredData.event
                ? registeredData.event.eventName
                : "Event Name "
            }}
          </span>
        </div>
        <div class="flow-root">
          <ul
            v-if="
              registeredData &&
              registeredData.team &&
              registeredData.team.teamMember
            "
            role="list"
            class="divide-y divide-gray-200 dark:divide-gray-700"
          >
            <li
              v-for="(team, index) in registeredData.team.teamMember"
              :key="index"
              class="py-3 sm:py-4"
            >
              <div class="flex items-center">
                <div class="flex-shrink-0"></div>
                <div class="flex-1 min-w-0 ms-4">
                  <p
                    class="text-sm font-medium text-gray-900 truncate dark:text-white"
                  >
                    {{ team.memberName }}
                  </p>
                  <!-- <p class="text-sm text-gray-500 truncate dark:text-gray-400"></p> -->
                </div>
                <div
                  class="inline-flex items-center text-base font-semibold text-gray-900 dark:text-white"
                >
                  {{ team.memberPosition }}
                </div>
              </div>
            </li>
          </ul>
        </div>
      </div>
      <!-- Button Group -->

      <div class="inline-flex rounded-md shadow-sm mt-3" role="group">
        <button
          type="button"
          class="px-4 py-2 text-sm font-medium text-gray-900 bg-transparent border border-gray-900 rounded-s-lg hover:bg-gray-900 hover:text-white focus:z-10 focus:ring-2 focus:ring-gray-500 focus:bg-gray-900 focus:text-white dark:border-white dark:text-white dark:hover:text-white dark:hover:bg-gray-700 dark:focus:bg-gray-700"
        >
          Upload
        </button>
        <button
          type="button"
          class="px-4 py-2 text-sm font-medium text-gray-900 bg-transparent border border-gray-900 rounded-e-lg hover:bg-gray-900 hover:text-white focus:z-10 focus:ring-2 focus:ring-gray-500 focus:bg-gray-900 focus:text-white dark:border-white dark:text-white dark:hover:text-white dark:hover:bg-gray-700 dark:focus:bg-gray-700"
        >
          Downloads
        </button>
      </div>

      <!-- Form Upload -->
      <div
        class="p-4 border-2 border-gray-200 border-opacity-100 rounded-lg dark:border-gray-700 mt-5"
      >
        <ol
          class="relative border-s border-gray-200 dark:border-gray-700 ms-2 p-4"
          v-if="
            registeredData &&
            registeredData.event &&
            registeredData.event.stages &&
            registeredData.uploadFiles
          "
        >
          <li
            v-for="(stage, index) in registeredData.event.stages"
            :key="index"
            class="mb-10 ms-6"
          >
            <span
              class="absolute flex items-center justify-center w-6 h-6 bg-blue-100 rounded-full -start-3 ring-8 ring-white dark:ring-gray-900 dark:bg-blue-900"
            >
              <svg
                class="w-2.5 h-2.5 text-blue-800 dark:text-blue-300"
                aria-hidden="true"
                xmlns="http://www.w3.org/2000/svg"
                fill="currentColor"
                viewBox="0 0 20 20"
              >
                <path
                  d="M20 4a2 2 0 0 0-2-2h-2V1a1 1 0 0 0-2 0v1h-3V1a1 1 0 0 0-2 0v1H6V1a1 1 0 0 0-2 0v1H2a2 2 0 0 0-2 2v2h20V4ZM0 18a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V8H0v10Zm5-8h10a1 1 0 0 1 0 2H5a1 1 0 0 1 0-2Z"
                />
              </svg>
            </span>
            <h3
              class="flex items-center mb-1 text-lg font-semibold text-gray-900 dark:text-white"
            >
              {{ stage.stageName }}
            </h3>
            <p
              class="mb-4 text-base font-normal text-gray-500 dark:text-gray-400"
            >
              {{ stage.description }}
            </p>

            <!-- List Uploaded Files -->
            <div
              v-if="isLoading"
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
                <span>Downloading...</span>
              </div>
            </div>
            <div v-if="registeredData.uploadFiles.length > 0">
              <p
                class="mt-2 mb-4 text-sm font-medium text-gray-900 dark:text-white"
              >
                Uploaded Files:
              </p>
              <ul class="mb-4">
                <li
                  v-for="(uploadedFile, index) in registeredData.uploadFiles"
                  :key="index"
                  class="mb-2"
                >
                  <span v-if="uploadedFile.stageId === stage.stageId">
                    <div class="flex border-2 border-dashed rounded p-2 w-fit">
                      <button
                        @click="downloadFile(uploadedFile.fileName)"
                        class="md:text-wrap"
                      >
                        {{
                          getFileIndex(stage.stageId, uploadedFile.fileName)
                        }}.
                        {{ uploadedFile.fileName }}
                      </button>
                      <svg
                        class="w-5 h-5 ms-2 me-2 text-gray-800 dark:text-white"
                        aria-hidden="true"
                        xmlns="http://www.w3.org/2000/svg"
                        width="24"
                        height="24"
                        fill="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          fill-rule="evenodd"
                          d="M9 2.221V7H4.221a2 2 0 0 1 .365-.5L8.5 2.586A2 2 0 0 1 9 2.22ZM11 2v5a2 2 0 0 1-2 2H4v11a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V4a2 2 0 0 0-2-2h-7ZM8 16a1 1 0 0 1 1-1h6a1 1 0 1 1 0 2H9a1 1 0 0 1-1-1Zm1-5a1 1 0 1 0 0 2h6a1 1 0 1 0 0-2H9Z"
                          clip-rule="evenodd"
                        />
                      </svg>
                      <small>Status :</small>

                      <span
                        v-if="uploadedFile.approvalStatus === 'APPROVE'"
                        class="mb-4 text-green-500 ms-3"
                        >Approved</span
                      >
                      <span
                        v-else
                        class="bg-yellow-300 text-black ms-3 border rounded-md p-1"
                        >Waiting</span
                      >
                    </div>
                  </span>
                </li>
              </ul>
            </div>
            <div v-if="!isUploaded(stage.stageId)">
              <label
                class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                for="file_input"
                >Upload file</label
              >

              <input
                v-if="!isUploaded(stage.stageId)"
                :id="'file_input_' + stage.stageId"
                :key="fileInputKey"
                class="block w-full mb-2 text-sm text-gray-900 border border-gray-300 rounded-lg cursor-pointer bg-gray-50 dark:text-gray-400 focus:outline-none dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400"
                type="file"
                ref="fileInput"
                multiple
                @change="handleFileChange($event, stage)"
              />
            </div>

            <div
              v-if="
                selectedFiles[stage.stageId] &&
                selectedFiles[stage.stageId].length > 0
              "
            >
              <p
                class="mt-2 mb-4 text-sm font-medium text-gray-900 dark:text-white"
              >
                Selected Files:
              </p>
              <ul class="mb-4">
                <li
                  v-for="(file, index) in selectedFiles[stage.stageId]"
                  :key="index"
                >
                  {{ file.name }}
                  <button
                    @click="removeSelectedFile(stage.stageId, index)"
                    class="text-red-500 ml-2"
                  >
                    Remove
                  </button>
                </li>
              </ul>
            </div>

            <!-- Animasi loading saat proses upload -->
            <transition name="fade">
              <div
                v-if="uploading[stage.stageId]"
                class="text-green-500 dark:text-green-500 mb-2"
              >
                Uploading...
              </div>
            </transition>

            <button
              v-if="
                selectedFiles[stage.stageId] &&
                selectedFiles[stage.stageId].length > 0
              "
              @click="uploadFiles(stage)"
              class="px-4 py-2 text-sm font-medium text-white bg-blue-600 border border-transparent rounded-md cursor-pointer hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
            >
              Upload
            </button>
          </li>
        </ol>
      </div>
    </div>
  </div>
</template>

<style></style>
