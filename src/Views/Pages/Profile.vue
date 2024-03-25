<script setup>
import { onMounted, ref } from "vue";
import SiddebarWithNavbar from "../../components/SidebarWithNavbar.vue";
import { useStore } from "vuex";

const store = useStore();
const userData = ref("");

onMounted(() => {
  userData.value = store.getters.getUserData;
  console.log(userData.value);
});
</script>
<template>
  <div>
    <SiddebarWithNavbar></SiddebarWithNavbar>
    <div class="p-4 sm:ml-64">
      <div
        class="p-4 border-2 border-gray-200 border-opacity-100 rounded-lg dark:border-gray-700 mt-14"
      >
        <h1>LALA</h1>
      </div>
    </div>
  </div>
</template>

<style></style>
