<template>
  <div>
    <b-container>
      <b-row class="mb-2">
        <b-col>
          <h2 for="example-datepicker">Введите шаблон:</h2>
        </b-col>
      </b-row>
      <ValidationObserver v-slot="{ handleSubmit }">
        <b-form @submit.prevent="handleSubmit(onSubmit)">
          <b-row class="mb-2">
            <b-col md="4">
              <validation-provider :rules="{ required: true }" v-slot="{ errors }">
                <b-form-input v-model="name" placeholder="Название"></b-form-input>
                <span class="validationError">{{ errors[0] }}</span>
              </validation-provider>
            </b-col>
          </b-row>
          <b-row class="mb-2">
            <b-col md="4" class="mb-2">
              <validation-provider :rules="{ required: true }" v-slot="{ errors }">
                <b-form-textarea
                  id="textarea"
                  v-model="content"
                  placeholder="Шаблон"
                  rows="3"
                  max-rows="6"
                ></b-form-textarea>
                <span class="validationError">{{ errors[0] }}</span>
              </validation-provider>
            </b-col>
          </b-row>
          <b-row class="mb-2">
            <b-col md="4" class="mb-2">
              <b-form-textarea
                id="textarea"
                v-model="html"
                placeholder="HTML"
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
                placeholder="Комментарий"
                rows="3"
                max-rows="6"
              ></b-form-textarea>
            </b-col>
          </b-row>
          <b-row class="mb-2">
            <b-col md="3">
              <b-button type="submit">Добавить шаблон</b-button>
            </b-col>
            <b-col md="3">
              <b-button type="reset">Очистить форму</b-button>
            </b-col>
            <b-col>
              <b-button v-on:click="goToTemplatesList">Назад к списку шаблонов</b-button>
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
import { AddTemplateService } from "@/common/api.service";

extend("required", {
  ...required,
  message: "Обязательное поле"
});

export default {
  name: "addTemplate",
  components: {
    ValidationProvider,
    ValidationObserver
  },
  methods: {
    goToTemplatesList: function() {
      this.$router.push("templates");
    },
    onSubmit() {
      AddTemplateService.post(this.$data).then(data => {
        console.log(data);
        this.$router.push("templates");
      });
    }
  },
  data() {
    return {
      name: null,
      content: null,
      html: null,
      comments: null
    };
  }
};
</script>
