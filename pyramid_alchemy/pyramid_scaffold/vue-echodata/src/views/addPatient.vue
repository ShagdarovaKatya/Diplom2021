<template>
  <div>
    <b-container>
      <b-row class="mb-2">
        <b-col>
          <h2>Введите данные нового пациента:</h2>
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
              <label for="birthdate-datepicker">Дата рождения:</label>
              <validation-provider :rules="{ required: true }" v-slot="{ errors }">
                <b-form-datepicker
                  locale="ru"
                  id="birthdate-datepicker"
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
              <b-button type="submit">Добавить пациента</b-button>
            </b-col>
            <b-col md="3">
              <b-button type="reset">Очистить форму</b-button>
            </b-col>
            <b-col>
              <b-button v-on:click="goToPatientsList">Назад к списку пациентов</b-button>
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
import { AddPatientService } from "@/common/api.service";

extend("required", {
  ...required,
  message: "Обязательное поле"
});

export default {
  name: "addPatient",
  components: {
    ValidationProvider,
    ValidationObserver
  },
  methods: {
    goToPatientsList: function() {
      this.$router.push("patients");
    },
    onSubmit() {
      AddPatientService.post(this.$data).then(data => {
        console.log(data);
        this.$router.push("patients");
      });
    }
  },
  data() {
    return {
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
