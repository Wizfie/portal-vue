<template>
  <div>
    <SidebarWithNavbar></SidebarWithNavbar>
    <div class="p-4 sm:ml-64">
      <div
        class="p-4 border-2 border-gray-200 border-opacity-100 rounded-lg dark:border-gray-700 mt-14"
      >
        <h1 class="font-semibold">Dashboard</h1>
      </div>
      <template v-for="(event, index) in qccEvents" :key="index">
        <div
          class="p-4 border-2 border-gray-200 border-opacity-100 rounded-lg dark:border-gray-700 mt-5"
        >
          <h2 class="text-xl font-semibold mb-4">
            {{ event.event.eventName }}
          </h2>
          <ol class="items-center sm:flex flex-wrap">
            <li
              v-for="(step, stepIndex) in event.steps"
              :key="stepIndex"
              class="relative mb-6 sm:mb-0"
            >
              <div class="md:flex md:items-center md:flex-col">
                <div
                  class="z-10 flex mt-1 items-center justify-center w-6 h-6 bg-blue-100 rounded-full ring-0 ring-white dark:bg-blue-900 sm:ring-8 dark:ring-gray-900 shrink-0"
                  :class="getStepClass(step)"
                >
                  <svg
                    class="w-2.5 h-2.5 text-blue-800 dark:text-blue-300"
                    :class="getStepClass(step)"
                    aria-hidden="true"
                    xmlns="http://www.w3.org/2000/svg"
                    fill="currentColor"
                    viewBox="0 0 20 20"
                  >
                    <path
                      d="M20 4a2 2 0 0 0-2-2h-2V1a1 1 0 0 0-2 0v1h-3V1a1 1 0 0 0-2 0v1H6V1a1 1 0 0 0-2 0v1H2a2 2 0 0 0-2 2v2h20V4ZM0 18a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V8H0v10Zm5-8h10a1 1 0 0 1 0 2H5a1 1 0 0 1 0-2Z"
                    />
                  </svg>
                </div>
                <div
                  class="mt-2 md:flex md:flex-col w-full bg-gray-200 h-0.5 dark:bg-gray-700"
                ></div>
              </div>
              <div class="mt-3 sm:pe-8">
                <h2 class="font-semibold mb-4" :class="getStepClass(step)">
                  {{ step.stepName }}
                </h2>
                <time
                  class="block mb-2 text-sm font-normal leading-none text-gray-500 dark:text-gray-500"
                  :class="getStepClass(step)"
                  >{{ reverseDateFormat(step.startDate) }} -
                  {{ reverseDateFormat(step.endDate) }}</time
                >
                <p
                  class="text-base font-normal text-gray-500 dark:text-gray-500 description"
                  :class="getStepClass(step)"
                >
                  {{ step.description }}
                </p>
              </div>
            </li>
          </ol>
        </div>
      </template>
      <template v-for="(event, index) in ssEvents" :key="index">
        <div
          class="p-4 border-2 border-gray-200 border-opacity-100 rounded-lg dark:border-gray-700 mt-5"
        >
          <h2 class="text-xl font-semibold mb-4">
            {{ event.event.eventName }}
          </h2>
          <ol class="items-center sm:flex">
            <li
              v-for="(step, stepIndex) in event.steps"
              :key="stepIndex"
              class="relative mb-6 sm:mb-0"
            >
              <div class="md:flex md:flex-col items-center">
                <div
                  class="z-10 flex items-center justify-center w-6 h-6 bg-blue-100 rounded-full ring-0 ring-white dark:bg-blue-900 sm:ring-8 dark:ring-gray-900 shrink-0"
                  :class="getStepClass(step)"
                >
                  <svg
                    class="w-2.5 h-2.5 text-blue-800 dark:text-blue-300"
                    :class="getStepClass(step)"
                    aria-hidden="true"
                    xmlns="http://www.w3.org/2000/svg"
                    fill="currentColor"
                    viewBox="0 0 20 20"
                  >
                    <path
                      d="M20 4a2 2 0 0 0-2-2h-2V1a1 1 0 0 0-2 0v1h-3V1a1 1 0 0 0-2 0v1H6V1a1 1 0 0 0-2 0v1H2a2 2 0 0 0-2 2v2h20V4ZM0 18a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V8H0v10Zm5-8h10a1 1 0 0 1 0 2H5a1 1 0 0 1 0-2Z"
                    />
                  </svg>
                </div>
                <div
                  class="mt-2 md:flex md:flex-col w-full bg-gray-200 h-0.5 dark:bg-gray-700"
                ></div>
              </div>
              <div class="mt-3 sm:pe-8">
                <h2 class="font-semibold mb-4" :class="getStepClass(step)">
                  {{ step.stepName }}
                </h2>

                <time
                  class="block mb-2 text-sm font-normal leading-none text-gray-500 dark:text-gray-500"
                  >{{ reverseDateFormat(step.startDate) }} -
                  {{ reverseDateFormat(step.endDate) }}</time
                >
                <p
                  class="text-base font-normal text-gray-500 dark:text-gray-500 break-words text-wrap"
                >
                  {{ step.description }}
                </p>
              </div>
            </li>
          </ol>
        </div>
      </template>
    </div>
  </div>
</template>

<script setup>
import axios from "axios";
import { onMounted, ref } from "vue";
import SidebarWithNavbar from "../../components/SidebarWithNavbar.vue";

let qccEvents = ref([]);
let ssEvents = ref([]);

const currentTime = new Date();
console.log(currentTime);
const year = currentTime.getFullYear();
// console.log(year);

onMounted(() => {
  getEvent();
});

const getEvent = async () => {
  const response = await axios.get("/event/get-event");
  qccEvents.value = response.data.filter((item) => {
    const eventName = item.event.eventName.toLowerCase();
    const eventYear = new Date(item.event.eventYear).getFullYear();
    return eventYear === year && eventName.includes("qcc");
  });
  ssEvents.value = response.data.filter((item) => {
    const eventName = item.event.eventName.toLowerCase();
    const eventYear = new Date(item.event.eventYear).getFullYear();
    return eventYear === year && eventName.includes("ss");
  });
  console.log(qccEvents.value);
  console.log(ssEvents.value);
};

const isWithinDateRange = (startDate, endDate) => {
  const currentDate = new Date();
  const start = new Date(startDate);
  const end = new Date(endDate);

  // Mengubah zona waktu menjadi UTC untuk memastikan perbandingan yang konsisten
  currentDate.setUTCHours(0, 0, 0, 0);
  start.setUTCHours(0, 0, 0, 0);
  end.setUTCHours(0, 0, 0, 0);

  // Periksa jika tanggal saat ini di antara tanggal awal dan akhir
  return currentDate >= start && currentDate <= end;
};

const getStepClass = (step) => {
  return {
    "font-semibold": true,
    "text-blue-500": isWithinDateRange(step.startDate, step.endDate),
    "text-gray-500": !isWithinDateRange(step.startDate, step.endDate),
    "text-2xl": isWithinDateRange(step.startDate, step.endDate),
  };
};

const reverseDateFormat = (dateString) => {
  const dateParts = dateString.split("-");
  return `${dateParts[2]}/${dateParts[1]}/${dateParts[0]}`;
};
</script>

<style></style>
