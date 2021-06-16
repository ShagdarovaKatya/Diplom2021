<template>
  <nav class="navbar navbar-light">
    <div class="container">
      <router-link class="logo" :to="{ name: 'home' }">Эходата</router-link>
      <b-nav class="navbar-nav" style="display: contents;">
        <b-nav-item>
          <router-link
            class="nav-link"
            active-class="active"
            exact
            :to="{ name: 'patients' }"
          >Пациенты</router-link>
        </b-nav-item>
        <b-nav-item>
          <router-link
            class="nav-link"
            active-class="active"
            exact
            :to="{ name: 'investigations' }"
          >Исследования</router-link>
        </b-nav-item>
        <b-nav-item>
          <router-link
            class="nav-link"
            active-class="active"
            exact
            :to="{ name: 'templates' }"
          >Шаблоны</router-link>
        </b-nav-item>
        <b-nav-item>
          <router-link class="nav-link" active-class="active" exact :to="{ name: 'doctors' }">Врачи</router-link>
        </b-nav-item>
        <b-nav-item>
          <router-link
            class="nav-link"
            active-class="active"
            exact
            :to="{ name: 'prescribe' }"
          >Назначения</router-link>
        </b-nav-item>
        <b-nav-item>
          <router-link
            class="nav-link"
            active-class="active"
            exact
            :to="{ name: 'settings' }"
          >Настройки: название и структура клиники</router-link>
        </b-nav-item>
      </b-nav>
    </div>
  </nav>
</template>

<script>
export default {
  name: "Header"
};
</script>
