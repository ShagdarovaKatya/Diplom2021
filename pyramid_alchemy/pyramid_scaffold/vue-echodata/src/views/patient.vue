<template>
  <div>
    <b-container>
      <b-modal id="roomSelectModal" @ok="onModalOk" title="Выберите комнату">
        <p class="my-4">Выберите отделение и комнату для госпитализации:</p>
        <component :is="dynamicDepartmentList" />
      </b-modal>
      <b-row>
        <b-col>
          <b-row class="mb-2">
            <b-col>
              <h2 for="example-datepicker">Введите шаблон:</h2>
            </b-col>
          </b-row>
          <b-row class="mb-2">
            <b-col>
              <b-button v-on:click="goToPatientEditPage">Изменить данные</b-button>
            </b-col>
            <b-col>
              <b-button v-on:click="goToAddInvest">Добавить исследование</b-button>
            </b-col>
            <b-col>
              <b-button v-on:click="addEmptyInvest">Консультация (чистая)</b-button>
            </b-col>
          </b-row>
          <b-row class="mb-2">
            <b-col>
              <b-button v-on:click="deletePatient">Удалить пациента</b-button>
            </b-col>
            <b-col>
              <b-button
                v-if="this.inPatient.id || (this.inPatient.discharged != null && !this.inPatient.discharged)"
                v-on:click="setInPatientDischarged"
              >Выписать</b-button>
              <b-button v-else v-b-modal.roomSelectModal>Госпитализировать</b-button>
            </b-col>
            <b-col>
              <b-button v-on:click="goToPatientsList">Список пациентов</b-button>
            </b-col>
          </b-row>

          <b-row>
            <b-overlay :show="loading" rounded="sm">
              <b-table
                id="invests-table"
                :items="items"
                :fields="fields"
                selectable
                select-mode="single"
                @row-selected="clickList"
              ></b-table>
              <b-pagination
                @input="fetchData(this.id, currentPage)"
                v-model="currentPage"
                :total-rows="rows"
                :per-page="perPage"
                aria-controls="invests-table"
              ></b-pagination>
            </b-overlay>
          </b-row>
        </b-col>
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
    </b-container>
    <router-view></router-view>
  </div>
</template>

<script>
import { ValidationProvider, extend, ValidationObserver } from "vee-validate";
import { required } from "vee-validate/dist/rules";
import { PatientService } from "@/common/api.service";
import { API_URL } from "@/common/config";

extend("required", {
  ...required,
  message: "Обязательное поле"
});

export default {
  name: "patient",
  components: {
    ValidationProvider,
    ValidationObserver
  },
  created: function() {
    this.id = this.$route.query.id;
    this.fetchData(this.id, 1);
    this.fetchDoctorsData();
  },
  methods: {
    deletePatient() {
      PatientService.delete(this.id).then(data => {
        this.goToPatientsList();
        console.log(data);
      });
    },
    setInPatientDischarged() {
      this.inPatient.discharged = true;
      PatientService.setInPatientDischarged(this.inPatient).then(data => {
        this.fetchData(this.id, this.currentPage);
        console.log(data);
      });
    },
    getDepartmentIdByRoomId(roomId) {
      var result = null;
      this.departments.forEach(department => {
        if (department.rooms.length > 0) {
          department.rooms.forEach(room => {
            if (roomId == room.id) {
              result = department.id;
            }
          });
        }
      });
      return result;
    },
    onModalOk() {
      var rooms = document.getElementsByName("room");
      rooms.forEach(room => {
        if (room.checked) {
          this.modalRoom = room.value;
          this.inPatient.discharged = true;

          PatientService.addInPatient({
            patientId: parseInt(this.id),
            roomId: parseInt(room.value),
            departmentId: this.getDepartmentIdByRoomId(room.value)
          }).then(data => {
            this.fetchData(this.id, this.currentPage);
            console.log(data);
          });
        }
      });
    },
    renderDepartmentList: function(departments) {
      if (departments == null) {
        return "";
      }

      var result = "";
      var i = 1;

      departments.forEach(department => {
        if (department.rooms != null && department.rooms.length > 0) {
          result += "<a>" + department.name + ":</a><br>";
          department.rooms.forEach(room => {
            result +=
              '<input type="radio" v-model="modalRoom" id="room' +
              i +
              '" name="room" value="' +
              room.id +
              '"> <label for="room' +
              i +
              '">' +
              room.name +
              "</label><br>";
          });
          result += "<br>";
        }
      });

      return result;
    },
    fetchData(patientId, page) {
      // this.error = this.post = null;
      this.loading = true;
      PatientService.getInvests(page ? page : 1, patientId).then(data => {
        this.itemst = data.data.items;
        this.rows = data.data.totalItems;
        this.perPage = data.data.per_page;
        this.loading = false.data;
      });
      PatientService.getDepartments().then(data => {
        this.departments = data.data.departments;
      });
      PatientService.getInPatient(patientId).then(data => {
        this.inPatient = data.data;
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
    goToAddInvest() {
      this.$router.push({ path: "AddInvest", query: { patientId: this.id } });
    },
    goToPatientEditPage() {
      this.$router.push({ path: "editPatient", query: { id: this.id } });
    },
    goToPatientsList() {
      this.$router.push("patients");
    },
    addEmptyInvest() {
      PatientService.addEmptyInvest(this.id).then(data => {
        this.fetchData(this.id, this.currentPage);
        console.log(data);
      });
    },
    onPrintInvest() {
      window.location =
        API_URL + "printExamination?examinationId=" + this.editedInvest.id;
    },
    onSubmit() {
      PatientService.updateInvest(this.$data.editedInvest).then(data => {
        this.fetchData(this.id, this.currentPage);
        console.log(data);
      });
    },
    onDeleteInvest() {
      PatientService.deleteExamination(this.editedInvest.id).then(data => {
        this.fetchData(this.id, this.currentPage);
        console.log(data);
      });
    },
    fetchDoctorsData() {
      PatientService.getDoctors().then(data => {
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
    dynamicDepartmentList: function() {
      return {
        template: `<div>${this.renderDepartmentList(this.departments)}</div>`,
        methods: {
          someAction() {
            console.log("Action!");
          }
        }
      };
    },
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
    }
  },
  data() {
    return {
      id: null,
      loading: false,
      rows: 0,
      perPage: 20,
      currentPage: 1,
      departments: null,
      modalRoom: null,
      inPatient: null,
      fields: [
        { key: "name", label: "Исследование" },
        { key: "examinationDate", label: "Дата" },
        { key: "physician.fio", label: "Врач" }
      ],
      editedInvest: {
        id: null,
        name: null,
        examinationDate: null,
        contents: null,
        physicianId: null
      },
      doctors: [{ value: null, text: "Выберите врача" }],
      itemst: null
    };
  }
};
</script>
