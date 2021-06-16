<template>
  <div>
    <b-input-group prepend="ФИО" class="mt-3">
      <b-form-input v-model="doctorName"></b-form-input>
      <b-input-group-append>
        <b-button v-on:click="addDoctor">Добавить врача</b-button>
      </b-input-group-append>
    </b-input-group>
    <b-overlay :show="loading" rounded="sm">
      <b-table id="doctors-table" :items="items" :fields="fields">
        <template #cell(action)="row">
          <b-button v-on:click="deleteDoctor(row)" variant="danger">Удалить</b-button>
        </template>
      </b-table>
      <b-pagination
        @input="fetchData(currentPage)"
        @row-clicked="deleteDoctor"
        v-model="currentPage"
        :total-rows="rows"
        :per-page="perPage"
        aria-controls="doctors-table"
      ></b-pagination>
    </b-overlay>
    <router-view></router-view>
  </div>
</template>

<script>
import { DoctorsService } from "@/common/api.service";

export default {
  name: "doctors",
  created: function() {
    this.fetchData(1);
  },
  methods: {
    deleteDoctor(row) {
      DoctorsService.delete(row.item.id).then(data => {
        this.fetchData(this.currentPage);
        console.log(data);
      });
    },
    addDoctor: function() {
      var doctorName = this.doctorName.split(" ");
      var data = {
        name: doctorName[1],
        family: doctorName[0],
        thirdName: doctorName[2]
      };
      DoctorsService.addDoctor(data).then(data => {
        this.fetchData(this.currentPage);
        console.log(data);
      });
    },
    fetchData(page) {
      this.loading = true;
      DoctorsService.get(page ? page : 1).then(data => {
        this.items = data.data.items;
        this.rows = data.data.totalItems;
        this.perPage = data.data.per_page;
        this.loading = false;
      });
    }
  },
  data() {
    return {
      loading: false,
      rows: 0,
      perPage: 20,
      currentPage: 1,
      doctorName: null,
      fields: [
        { key: "family", label: "Фамилия" },
        { key: "name", label: "Имя" },
        { key: "thirdName", label: "Отчество" },
        { key: "action", label: "" }
      ],
      items: null
    };
  }
};
</script>
