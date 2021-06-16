<template>
  <div>
    <b-container>
      <b-row class="mb-2">
        <b-col>
          <h2 for="example-datepicker">Введите данные нового исследования:</h2>
        </b-col>
      </b-row>
      <ValidationObserver v-slot="{ handleSubmit }">
        <b-form @submit.prevent="handleSubmit">
          <b-row class="mb-2">
            <b-col>
              <validation-provider :rules="{ required: true }" v-slot="{ errors }">
                <label for="example-datepicker">Выберите вид исследования:</label>
                <br />
                <b-form-select v-model="investType" :options="typeOfInvest"></b-form-select>
                <span class="validationError">{{ errors[0] }}</span>
              </validation-provider>
            </b-col>
          </b-row>
          <b-row class="mb-2">
            <b-col md="4" class="mb-2">
              <label for="example-datepicker">Выберите дату исследования:</label>
              <validation-provider :rules="{ required: true }" v-slot="{ errors }">
                <b-form-datepicker
                  locale="ru"
                  id="example-datepicker"
                  v-model="investDate"
                  class="mb-2"
                ></b-form-datepicker>
                <span class="validationError">{{ errors[0] }}</span>
              </validation-provider>
            </b-col>
          </b-row>
          <b-row class="mb-2">
            <b-col>
              <label for="example-datepicker">Врач:</label>
              <br />
              <validation-provider :rules="{ required: true }" v-slot="{ errors }">
                <b-form-select v-model="doctor" :options="doctors"></b-form-select>
                <span class="validationError">{{ errors[0] }}</span>
              </validation-provider>
            </b-col>
          </b-row>
          <b-row class="mb-2">
            <b-col md="3">
              <b-button v-on:click="goToFillInvestTemplate">Добавить исследование</b-button>
            </b-col>
            <b-col md="3">
              <b-button type="reset">Очистить форму</b-button>
            </b-col>
            <b-col>
              <b-button v-on:click="goToPatientPage">Назад</b-button>
            </b-col>
          </b-row>
        </b-form>
      </ValidationObserver>
    </b-container>
    <router-view></router-view>
  </div>
</template>

<script>
import { ValidationProvider, extend, ValidationObserver } from "vee-validate";
import { required } from "vee-validate/dist/rules";
import { AddInvestService } from "@/common/api.service";

extend("required", {
  ...required,
  message: "Обязательное поле"
});

export default {
  name: "addInvest",
  components: {
    ValidationProvider,
    ValidationObserver
  },
  methods: {
    goToFillInvestTemplate: function() {
      this.$router.push({
        path: "fillInvestTemplate",
        query: {
          id: this.investType,
          patientId: this.patientId,
          physician: this.doctor,
          examinationDate: this.investDate
        }
      });
    },
    goToPatientPage: function() {
      this.$router.push({ path: "patient", query: { id: this.patientId } });
    },
    fetchData() {
      this.loading = true;
      AddInvestService.getDoctors().then(data => {
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
  created: function() {
    this.patientId = this.$route.query.patientId;
    this.fetchData();
  },
  data() {
    return {
      patientId: null,
      investDate: null,
      investType: null,
      doctor: null,
      doctors: [{ value: null, text: "Выберите врача" }],
      typeOfInvest: [
        { value: null, text: "Выберите вид исследования" },
        { value: 4, text: "эхокардиография" },
        { value: 7, text: "выписка" },
        { value: 8, text: "чреспищеводная эхокардиография" },
        { value: 9, text: "электрическая кардиоверсия" },
        { value: 11, text: "стресс-эхокардиография" },
        { value: 12, text: "нормальная стресс-эхо" },
        { value: 13, text: "плевральная пункция" },
        { value: 14, text: "госпитализация" },
        { value: 16, text: "катетеризация центральной вены" },
        { value: 17, text: "NONAME" }
      ]
    };
  }
};
</script>
