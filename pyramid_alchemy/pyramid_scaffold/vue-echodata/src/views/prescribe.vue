<template>
  <div class="container page">
    <b-container>
      <b-row>
        <b-col md="1">
          <a>Палаты:</a>
        </b-col>
        <b-col md="9">
          <b-button-group>
            <b-button
              v-for="item in items"
              :key="item.room.id"
              v-on:click="fetchData(1, item.room.id)"
            >{{ item.room.name }}</b-button>
            <b-button v-on:click="fetchData(1)">Все палаты</b-button>
          </b-button-group>
        </b-col>
        <b-col md="2">
          <b-button v-on:click="onPrint">Распечатать</b-button>
        </b-col>
      </b-row>
    </b-container>
    <br />

    <b-table id="in-patients-table" :items="items" :fields="fields">
      <template #cell(orders)="row">
        <h5
          class="mb-1"
        >{{ row.item.patient.family + " " + row.item.patient.name + " " + row.item.patient.thirdName }}</h5>
        <a>{{ row.item.department.name + " " + row.item.room.name}}</a>
        <b-form-textarea
          id="textarea"
          v-model="row.item.orders"
          placeholder="Назначения..."
          rows="3"
          max-rows="6"
        ></b-form-textarea>
      </template>
      <template #cell(problems)="row">
        <br />
        <br />
        <b-form-textarea
          id="textarea"
          v-model="row.item.problems"
          placeholder="План обследования, проблемы..."
          rows="3"
          max-rows="6"
        ></b-form-textarea>
      </template>
      <template #cell(action)="row">
        <br />
        <br />
        <br />
        <b-button v-on:click="saveInPatient(row)">Сохранить</b-button>
      </template>
    </b-table>
    <b-pagination
      @input="fetchData(currentPage)"
      v-model="currentPage"
      :total-rows="rows"
      :per-page="perPage"
      aria-controls="in-patients-table"
    ></b-pagination>
    <router-view></router-view>
  </div>
</template>

<script>
import { PrescribeService } from "@/common/api.service";
import { API_URL } from "@/common/config";

export default {
  name: "doctors",
  components: {},
  created: function() {
    this.fetchData(1);
  },
  methods: {
    saveInPatient(item) {
      PrescribeService.updateInPatient(item.item).then(data => {
        this.fetchData(this.currentPage);
        console.log(data);
      });
    },
    onPrint: function() {
      window.location = API_URL + "printOrders";
    },
    fetchData(page, room) {
      this.loading = true;
      PrescribeService.getInPatients(page ? page : 1, room ? room : "").then(
        data => {
          this.items = data.data.items;
          this.rows = data.data.totalItems;
          this.perPage = data.data.per_page;
          this.loading = false;
        }
      );
    }
  },
  data() {
    return {
      perPage: 2,
      currentPage: 1,
      rows: null,
      fields: [
        { key: "orders", label: "" },
        { key: "problems", label: "" },
        { key: "action", label: "" }
      ],
      items: null
    };
  }
};
</script>
