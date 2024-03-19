<template>
  <div>
    <!-- Spinner isLoading -->
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
        <span>isLoading...</span>
      </div>
    </div>
    <SidebarWithNav></SidebarWithNav>

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
              class="w-full text-sm text-left rtl:text-right text-gray-500 dark:text-gray-400"
            >
              <thead
                class="text-xs text-gray-700 uppercase text-center bg-gray-400 dark:bg-gray-700 dark:text-gray-400"
              >
                <tr>
                  <th scope="col" class="px-6 py-3">No</th>
                  <th scope="col" class="px-6 py-3">Team</th>
                  <th scope="col" class="px-6 py-3">File Name</th>
                  <th scope="col" class="px-6 py-3">Status</th>
                  <th scope="col" class="px-6 py-3">Action</th>
                </tr>
              </thead>
              <tbody>
                <template
                  v-for="(registration, index) in registrations"
                  :key="registration.registrationId"
                >
                  <tr
                    class="bg-white border-2 dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600"
                    v-if="
                      registration.uploadFiles &&
                      registration.uploadFiles.length > 0
                    "
                    v-for="(file, fileIndex) in registration.uploadFiles"
                    :key="file.filesId"
                  >
                    <template v-if="fileIndex === 0">
                      <td
                        :rowspan="registration.uploadFiles.length"
                        class="px-6 py-4 bg-white border-2 hover:bg-gray-50 text-center"
                      >
                        {{ index + 1 }}
                      </td>
                      <td
                        :rowspan="registration.uploadFiles.length"
                        scope="row"
                        class="px-6 py-4 bg-white border-2 hover:bg-gray-50 font-medium text-center text-gray-900 whitespace-nowrap dark:text-white dark:bg-gray-800"
                      >
                        <small>{{ registration.event.eventName }}</small>
                        <br />
                        <br />
                        <span>{{ registration.team.teamName }}</span>
                      </td>
                    </template>
                    <td class="px-6 py-4 bg-white border-2 hover:bg-gray-50">
                      <small class="font-medium">{{
                        getStageName(file.stageId)
                      }}</small>
                      <br />
                      <div></div>

                      <div class="md:flex md:flex-col md:justify-between">
                        <div class="flex">
                          <svg
                            class="w-4 h-4 mt-1.5 me-2 text-gray-800 dark:text-white"
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
                          <button
                            @click="downloadFile(file.fileName)"
                            class="hover:bg-blue-100 mb-2 md:mb-2 rounded border-2 border-dashed p-2"
                          >
                            {{ file.fileName }}
                          </button>
                        </div>
                        <small class="text-sm text-end">
                          <span>Upload Date : </span>
                          <br />
                          {{ formatUploadedDate(file.uploadedAt) }}
                        </small>
                      </div>
                    </td>

                    <td
                      class="px-6 py-4 text-center bg-white border-2 hover:bg-gray-50"
                    >
                      <span
                        v-if="file.approvalStatus === 'APPROVE'"
                        class="mb-4 bg-green-500 text-white font-medium rounded-md p-2 ms-3"
                        >Approved</span
                      >
                      <span
                        v-else-if="file.approvalStatus === `REJECT`"
                        class="bg-red-600 text-white font-medium ms-3 p-2 border rounded-md"
                        >Rejected</span
                      >
                      <span
                        v-else
                        class="bg-yellow-400 text-white font-medium ms-3 border rounded-md p-2"
                        >Waiting</span
                      >
                    </td>
                    <td class="px-6 py-4 bg-white border-2 hover:bg-gray-50">
                      <div class="flex gap-3 justify-center">
                        <button
                          @click="approveFile(file.filesId)"
                          class="p-4 font-medium text-white bg-blue-500 rounded-md"
                        >
                          Approve
                        </button>
                        <button
                          @click="showRejectModal(file.filesId)"
                          class="block text-white bg-red-700 hover:bg-red-800 focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-red-600 dark:hover:bg-red-700 dark:focus:ring-red-800"
                          type="button"
                        >
                          Reject
                        </button>
                      </div>
                    </td>
                  </tr>
                  <div
                    id="reject-modal"
                    data-modal-backdrop="static"
                    tabindex="-1"
                    aria-hidden="true"
                    class="hidden fixed top-0 left-0 z-50 w-full h-full flex items-center justify-center"
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
                            class="text-xl font-semibold text-gray-900 dark:text-white"
                          >
                            Reject Modal
                          </h3>
                          <button
                            @click="hideRejectModal()"
                            type="button"
                            class="end-2.5 text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
                            data-modal-hide="reject-modal"
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
                            @submit.prevent="rejectFile()"
                            class="space-y-4"
                            action="#"
                          >
                            <div>
                              <label
                                for="reason"
                                class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                                >Reason</label
                              >
                              <textarea
                                v-model="rejectReason"
                                type="text"
                                name="reason"
                                id="reason"
                                class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
                                placeholder="Write here ..."
                                required
                              ></textarea>
                            </div>
                            <div>
                              <label
                                class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                                for="file_input"
                                >Upload file</label
                              >
                              <input
                                @change="onReject($event)"
                                class="block w-full text-sm text-gray-900 border border-gray-300 rounded-lg cursor-pointer bg-gray-50 dark:text-gray-400 focus:outline-none dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400"
                                id="file_input"
                                type="file"
                              />
                            </div>
                            <button
                              type="submit"
                              class="w-full text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
                            >
                              Submit
                            </button>
                          </form>
                        </div>
                      </div>
                    </div>
                  </div>
                </template>
                <tr v-if="!registrations.length">
                  <td
                    colspan="6"
                    class="px-6 py-4 bg-white border-2 hover:bg-gray-50"
                  >
                    Belum ada file
                  </td>
                </tr>
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
import SidebarWithNav from "../../components/SidebarWithNavbar.vue";
import { useStore } from "vuex";
import axios from "axios";
import { initFlowbite } from "flowbite";

// Variable
const store = useStore();
const userData = ref("");
const registrations = ref([]);
const isLoading = ref(false);
const rejectFileId = ref(null);
const rejectReason = ref("");
const file = ref(null);

onMounted(() => {
  initFlowbite();
  registrationList();
  userData.value = store.getters.getUserData;
});

// Main Method

const registrationList = () => {
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

const approveFile = (fileId) => {
  const approvalStatus = "APPROVE";
  if (confirm("Approve File ini ?")) {
    axios
      .put(`/file/approve/${fileId}?approvalStatus=${approvalStatus}`)
      .then((response) => {
        console.log(response.data);
        registrationList();

        alert("Approved");
      })
      .catch((error) => {
        console.error("Error approving file:", error);
        alert("Fail Approve");
      });
  }
};

const rejectFile = async () => {
  try {
    const formData = new FormData();
    formData.append("description", rejectReason.value);
    formData.append("file", file.value);

    // Ambil fileId dari ref
    const fileId = rejectFileId.value;

    await axios.put(`/file/reject/${fileId}`, formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });

    alert("Reject File Success");
  } catch (error) {
    alert("Failed to reject file: " + error.response.data);
  } finally {
    registrationList();
    rejectFileId.value = null;
    file.value = null;
    rejectReason.value = "";
    hideRejectModal();
  }
};

// Utils

const showRejectModal = (filesId) => {
  const modal = document.getElementById("reject-modal");
  modal.classList.remove("hidden");

  rejectFileId.value = filesId;
  console.log(rejectFileId.value);
};

// Method untuk menyembunyikan modal reject
const hideRejectModal = () => {
  const modal = document.getElementById("reject-modal");
  modal.classList.add("hidden");
};

const onReject = (event) => {
  file.value = event.target.files[0];
};

const formatUploadedDate = (uploadedAt) => {
  const date = new Date(uploadedAt);
  const formattedDate = `${date.getFullYear()}-${
    date.getMonth() + 1
  }-${date.getDate()}`;
  const formattedTime = `${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}`;
  return `${formattedDate}, \n${formattedTime}`;
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
#reject-modal {
  background-color: rgba(
    0,
    0,
    0,
    0.5
  ); /* Menambahkan lapisan belakang semi-transparan */
}

#reject-modal .modal-content {
  background-color: white;
  border-radius: 8px;
  padding: 20px;
  width: 80%; /* Atur lebar modal sesuai kebutuhan */
  max-width: 500px; /* Atur lebar maksimum modal */
  max-height: 80%; /* Atur tinggi maksimum modal */
}
</style>
