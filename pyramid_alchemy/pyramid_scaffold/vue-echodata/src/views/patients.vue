<template>
  <div>
    <b-container>
      <b-row>
        <b-col md="3">
          <b-form-input v-model="family" placeholder="Фамилия"></b-form-input>
        </b-col>
        <b-col md="4">
          <b-form-input v-model="tags" placeholder="Теги"></b-form-input>
        </b-col>
        <b-col md="1">
          <b-button v-on:click="fetchData(1)">Поиск</b-button>
        </b-col>
        <b-col>
          <b-button v-on:click="addPatient">Добавить пациента</b-button>
        </b-col>
      </b-row>
      <b-row>
        <b-col>
          <b-overlay :show="loading" rounded="sm">
            <b-table
              hover
              id="patients-table"
              :items="items"
              :fields="fields"
              selectable
              @row-selected="(item, index, event) => clickList(item, index, event)"
            ></b-table>
            <b-pagination
              @input="fetchData(currentPage)"
              v-model="currentPage"
              :total-rows="rows"
              :per-page="perPage"
              aria-controls="patients-table"
            ></b-pagination>
          </b-overlay>
        </b-col>
      </b-row>
    </b-container>
  </div>
</template>

<script>
import { PatientsService } from "@/common/api.service";

export default {
  name: "patients",
  components: {},
  created: function() {
    this.fetchData(1);
  },
  methods: {
    clickList(item) {
      this.$router.push({ path: "patient", query: { id: item[0].id } });
    },
    addPatient: function() {
      this.$router.push("addPatient");
    },
    fetchData(page) {
      this.loading = true;
      PatientsService.get(
        page ? page : 1,
        this.family ? this.family : "",
        this.tags ? this.tags : ""
      ).then(data => {
        this.items = data.data.items;
        this.rows = data.data.totalItems;
        this.perPage = data.data.per_page;
        this.loading = false;
      });
    }
  },
  data() {
    return {
      family: null,
      tags: null,
      loading: false,
      rows: null,
      perPage: null,
      currentPage: 1,
      fields: [
        { key: "family", label: "Фамилия" },
        { key: "name", label: "Имя" },
        { key: "thirdName", label: "Отчество" },
        { key: "birthdate", label: "Дата рождения" },
        { key: "tags", label: "Теги" }
      ],
      items: null
    };
  }
};
</script>
