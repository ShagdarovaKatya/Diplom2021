<template>
  <div>
    <b-container>
      <b-row class="mb-2">
        <b-col>
          <h2 for="example-datepicker">Редактирование пациента:</h2>
        </b-col>
      </b-row>
      <ValidationObserver v-slot="{ handleSubmit }">
        <b-form @submit.prevent="handleSubmit(onSubmit)">
          <b-row class="mb-2">
            <b-col md="4">
              <validation-provider :rules="{ required: true }" v-slot="{ errors }">
                <b-form-input v-model="family" placeholder="Фамилия"></b-form-input>
                <span class="validationError">{{ errors[0] }}</span>
              </validation-provider>
            </b-col>
          </b-row>
          <b-row class="mb-2">
            <b-col md="4" class="mb-2">
              <validation-provider :rules="{ required: true }" v-slot="{ errors }">
                <b-form-input v-model="name" placeholder="Имя"></b-form-input>
                <span class="validationError">{{ errors[0] }}</span>
              </validation-provider>
            </b-col>
          </b-row>
          <b-row class="mb-2">
            <b-col md="4" class="mb-2">
              <b-form-input v-model="thirdName" placeholder="Отчество"></b-form-input>
            </b-col>
          </b-row>
          <b-row class="mb-2">
            <b-col md="4" class="mb-2">
              <b-form-group label="Пол:" v-slot="{ ariaDescribedby }">
                <b-form-radio-group
                  id="radio-group-2"
                  v-model="gender"
                  :aria-describedby="ariaDescribedby"
                  name="radio-sub-component"
                >
                  <b-form-radio value="MALE">Мужской</b-form-radio>
                  <b-form-radio value="FEMALE">Женский</b-form-radio>
                </b-form-radio-group>
              </b-form-group>
            </b-col>
          </b-row>
          <b-row class="mb-2">
            <b-col md="4" class="mb-2">
              <label for="example-datepicker">Дата рождения:</label>
              <validation-provider :rules="{ required: true }" v-slot="{ errors }">
                <b-form-datepicker
                  locale="ru"
                  id="example-datepicker"
                  v-model="birthdate"
                  class="mb-2"
                ></b-form-datepicker>
                <span class="validationError">{{ errors[0] }}</span>
              </validation-provider>
            </b-col>
          </b-row>
          <b-row class="mb-2">
            <b-col md="4">
              <b-form-textarea
                id="textarea"
                v-model="address"
                placeholder="Адрес"
                rows="3"
                max-rows="6"
              ></b-form-textarea>
            </b-col>
          </b-row>
          <b-row class="mb-2">
            <b-col md="4">
              <b-form-input v-model="phone" placeholder="Телефон"></b-form-input>
            </b-col>
          </b-row>
          <b-row class="mb-2">
            <b-col md="4">
              <b-form-textarea
                id="textarea"
                v-model="diagnosos"
                placeholder="Диагноз"
                rows="3"
                max-rows="6"
              ></b-form-textarea>
            </b-col>
          </b-row>
          <b-row class="mb-2">
            <b-col md="4">
              <b-form-textarea
                id="textarea"
                v-model="comments"
                placeholder="Комментарии"
                rows="3"
                max-rows="6"
              ></b-form-textarea>
            </b-col>
          </b-row>
          <b-row class="mb-2">
            <b-col md="4">
              <b-form-textarea
                id="textarea"
                v-model="tags"
                placeholder="Теги"
                rows="3"
                max-rows="6"
              ></b-form-textarea>
            </b-col>
          </b-row>
          <b-row class="mb-2">
            <b-col md="3">
              <b-button type="submit">Сохранить изменения</b-button>
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
import { EditPatientService } from "@/common/api.service";

extend("required", {
  ...required,
  message: "Обязательное поле"
});

export default {
  name: "editPatient",
  components: {
    ValidationProvider,
    ValidationObserver
  },
  created: function() {
    this.fetchData();
  },
  methods: {
    goToPatientPage: function() {
      this.$router.push({ path: "patient", query: { id: this.id } });
    },
    fetchData() {
      this.loading = true;
      EditPatientService.get(this.$route.query.id).then(data => {
        this.id = data.data.id;
        this.gender = data.data.gender;
        this.family = data.data.family;
        this.name = data.data.name;
        this.thirdName = data.data.thirdName;
        this.birthdate = data.data.birthdate;
        this.address = data.data.address;
        this.phone = data.data.phone;
        this.diagnosos = data.data.diagnosos;
        this.comments = data.data.comments;
        this.tags = data.data.tags;
      });
    },
    onSubmit() {
      EditPatientService.post(this.$data).then(data => {
        this.$router.push({ path: "patient", query: { id: this.id } });
        console.log(data);
      });
    }
  },
  data() {
    return {
      id: null,
      gender: "MALE",
      family: null,
      name: null,
      thirdName: null,
      birthdate: null,
      address: null,
      phone: null,
      diagnosos: null,
      comments: null,
      tags: null
    };
  }
};
</script>
