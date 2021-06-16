<template>
  <div class="home-page">
    <div class="banner">
      <div class="header">
        <h1 class="logo-font">Эходата</h1>
        <p>Идея: Осипов М.А., Охотин А.Н., Самойлов Д.В.</p>
        <p>Программирование: Охотин А. Н.</p>
        <p>Web-based platform-independent opensource network patient database</p>
        <p>Requirements: python, postgresql, javascript, html</p>
      </div>
    </div>
    <div class="containerPage">
      <router-view></router-view>
    </div>
  </div>
</template>

<script>
export default {
  name: "home"
};
</script>
