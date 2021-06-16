<template>
  <div>
    <b-button v-on:click="addTemplate">Добавить форму</b-button>
    <b-overlay :show="loading" rounded="sm">
      <b-table id="templates-table" :items="items" :fields="fields">
        <template #cell(edit)="row">
          <b-button v-on:click="editTemplate(row)" variant="primary">Редактировать</b-button>
        </template>
        <template #cell(delete)="row">
          <b-button v-on:click="deleteTemplate(row)" variant="danger">Удалить</b-button>
        </template>
      </b-table>
      <b-pagination
        @input="fetchData(currentPage)"
        v-model="currentPage"
        :total-rows="rows"
        :per-page="perPage"
        aria-controls="templates-table"
      ></b-pagination>
    </b-overlay>
    <router-view></router-view>
  </div>
</template>

<script>
import { TemplatesService } from "@/common/api.service";

export default {
  name: "templates",
  components: {},
  created: function() {
    this.fetchData(1);
  },
  methods: {
    editTemplate(row) {
      this.$router.push({ path: "editTemplate", query: { id: row.item.id } });
    },
    deleteTemplate(row) {
      TemplatesService.deleteTemplate(row.item.id).then(data => {
        this.fetchData(this.currentPage);
        console.log(data);
      });
    },
    addTemplate: function() {
      this.$router.push("addTemplate");
    },
    fetchData(page) {
      this.loading = true;
      TemplatesService.get(page ? page : 1).then(data => {
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
      rows: null,
      perPage: null,
      currentPage: 1,
      fields: [
        { key: "name", label: "Название" },
        { key: "comments", label: "Комментарий" },
        { key: "edit", label: "" },
        { key: "delete", label: "" }
      ],
      items: null
    };
  }
};
</script>
