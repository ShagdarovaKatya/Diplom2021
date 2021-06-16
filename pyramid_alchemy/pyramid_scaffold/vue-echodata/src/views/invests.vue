<template>
  <div>
    <b-overlay :show="loading" rounded="sm">
      <b-table
        id="invests-table"
        hover
        :items="items"
        :fields="fields"
        selectable
        select-mode="single"
        @row-selected="(item, index, event) => clickList(item, index, event)"
      ></b-table>
      <b-pagination
        @input="fetchExaminationsData(currentPage)"
        v-model="currentPage"
        :total-rows="rows"
        :per-page="perPage"
        aria-controls="invests-table"
      ></b-pagination>
    </b-overlay>
    <router-view></router-view>
    <hr />
    <b-row v-show="false">
      <b-col>
        <p>Исследование не выбрано</p>
      </b-col>
    </b-row>
    <b-row v-show="{investInfoVisible}">
      <b-col>
        <ValidationObserver v-slot="{ handleSubmit }">
          <b-form @submit.prevent="handleSubmit(onSubmit)">
            <b-row class="mb-2">
              <b-col md="12">
                <validation-provider :rules="{ required: true }" v-slot="{ errors }">
                  <b-form-input v-model="editedInvest.name" placeholder="Название"></b-form-input>
                  <span class="validationError">{{ errors[0] }}</span>
                </validation-provider>
              </b-col>
            </b-row>
            <b-row class="mb-2">
              <b-col md="12" class="mb-2">
                <label for="examinationDate-datepicker">Дата исследования:</label>
                <validation-provider :rules="{ required: true }" v-slot="{ errors }">
                  <b-form-datepicker
                    locale="ru"
                    id="examinationDate-datepicker"
                    v-model="editedInvest.examinationDate"
                    class="mb-2"
                  ></b-form-datepicker>
                  <span class="validationError">{{ errors[0] }}</span>
                </validation-provider>
              </b-col>
            </b-row>
            <b-row class="mb-2">
              <b-col md="12" class="mb-2">
                <b-form-textarea
                  id="textarea"
                  v-model="editedInvest.contents"
                  placeholder="Шаблон"
                  rows="8"
                  max-rows="10"
                ></b-form-textarea>
              </b-col>
            </b-row>
            <b-row class="mb-2">
              <b-col md="12">
                <label>Врач: &nbsp;</label>
                <b-form-select v-model="editedInvest.physicianId" :options="doctors"></b-form-select>
              </b-col>
            </b-row>
            <b-row class="mb-2">
              <b-col md="3">
                <b-button type="submit">Сохранить изменения</b-button>
              </b-col>
              <b-col md="2">
                <b-button v-on:click="onDeleteInvest">Удалить</b-button>
              </b-col>
              <b-col md="1">
                <b-button v-on:click="onPrintInvest">Распечатать</b-button>
              </b-col>
            </b-row>
          </b-form>
        </ValidationObserver>
      </b-col>
    </b-row>
  </div>
</template>

<script>
import { ValidationProvider, extend, ValidationObserver } from "vee-validate";
import { required } from "vee-validate/dist/rules";
import { API_URL } from "@/common/config";
import { InvestsService } from "@/common/api.service";

extend("required", {
  ...required,
  message: "Обязательное поле"
});

export default {
  name: "invests",
  components: {
    ValidationProvider,
    ValidationObserver
  },
  created: function() {
    this.fetchExaminationsData(1);
    this.fetchDoctorsData();
  },
  methods: {
    onPrintInvest() {
      window.location =
        API_URL + "printExamination?examinationId=" + this.editedInvest.id;
    },
    onSubmit() {
      InvestsService.post(this.$data.editedInvest).then(data => {
        this.fetchExaminationsData(this.currentPage);
        console.log(data);
      });
    },
    onDeleteInvest() {
      InvestsService.delete(this.editedInvest.id).then(data => {
        this.fetchExaminationsData(this.currentPage);
        console.log(data);
      });
    },
    clickList(item, index, event) {
      console.log(item + index + event);
      this.editedInvest.id = item[0].id;
      this.editedInvest.name = item[0].name;
      this.editedInvest.contents = item[0].contents;
      this.editedInvest.examinationDate = item[0].examinationDate;
      this.editedInvest.physicianId = item[0].physicianId;
    },
    fetchExaminationsData(page) {
      this.loading = true;
      InvestsService.getInvests(page ? page : 1).then(data => {
        this.itemst = data.data.items;
        this.rows = data.data.totalItems;
        this.perPage = data.data.per_page;
        this.loading = false.data;
      });
    },
    fetchDoctorsData() {
      InvestsService.getDoctors().then(data => {
        data.data.physicians.forEach(physician => {
          physician.text =
            physician.family +
            " " +
            physician.name.substring(0, 1).toUpperCase() +
            ". " +
            physician.thirdName.substring(0, 1).toUpperCase() +
            ".";
          physician.value = physician.id;

          this.doctors.push(physician);
        });
      });
    }
  },
  computed: {
    items() {
      var list = [];
      this.itemst.forEach(row => {
        if (row.physician) {
          row.physician.fio =
            row.physician.family +
            " " +
            row.physician.name.substring(0, 1).toUpperCase() +
            ". " +
            row.physician.thirdName.substring(0, 1).toUpperCase() +
            ".";
        }
        list.push(row);
      });

      return list;
    },
    isInvestNotSelected() {
      return !this.investInfoVisible;
    }
  },
  data() {
    return {
      loading: false,
      rows: 0,
      perPage: null,
      currentPage: 1,
      investInfoVisible: false,
      editedInvest: {
        id: null,
        name: null,
        examinationDate: null,
        contents: null,
        physicianId: null
      },
      doctors: [{ value: null, text: "Выберите врача" }],
      fields: [
        { key: "patient.family", label: "Фамилия" },
        { key: "patient.name", label: "Имя" },
        { key: "patient.thirdName", label: "Отчество" },
        { key: "name", label: "Тип исследования" },
        { key: "examinationDate", label: "Дата" },
        { key: "physician.fio", label: "Врач" }
      ],
      itemst: null
    };
  }
};
</script>
