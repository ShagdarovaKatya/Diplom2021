<template>
  <footer>
    <div class="footer">
      <router-link class="logo" :to="{ name: 'home', params: {} }">Эходата</router-link>
    </div>
  </footer>
</template>

<script>
export default {
  name: "Footer"
};
</script>
