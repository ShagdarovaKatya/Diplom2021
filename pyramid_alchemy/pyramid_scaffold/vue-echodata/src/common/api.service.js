import Vue from "vue";
import axios from "axios";
import VueAxios from "vue-axios";
import { API_URL } from "@/common/config";

const ApiService = {
  init() {
    Vue.use(VueAxios, axios);
    Vue.axios.defaults.baseURL = API_URL;
  },

  query(resource, params) {
    return Vue.axios.get(resource, params).catch(error => {
      throw new Error(`[RWV] ApiService ${error}`);
    });
  },

  get(resource, slug) {
    return Vue.axios.get(`${resource}` + (slug ? slug : "")).catch(error => {
      throw new Error(`[RWV] ApiService ${error}`);
    });
  },

  post(resource, params) {
    return Vue.axios.post(`${resource}`, params);
  },

  update(resource, slug, params) {
    return Vue.axios.put(`${resource}/${slug}`, params);
  },

  put(resource, params) {
    return Vue.axios.put(`${resource}`, params);
  },

  delete(resource) {
    return Vue.axios.delete(resource).catch(error => {
      throw new Error(`[Echodata] ApiService ${error}`);
    });
  }
};

export default ApiService;


export const AddInvestService = {
  getDoctors() {
    return ApiService.get("allPhysicians");
  }
};

export const AddPatientService = {
  post(payload) {
    return ApiService.post(`addPatient`, payload);
  }
};

export const AddTemplateService = {
  post(payload) {
    return ApiService.post(`addTemplate`, payload);
  }
};

export const DoctorsService = {
  get(page) {
    return ApiService.get(`physicians?page=${page}`);
  },

  addDoctor(payload) {
    return ApiService.post(`addDoctor`, payload);
  },

  delete(id) {
    return ApiService.get(`deleteDoctor?id=${id}`);
  }
};

export const EditPatientService = {
  get(id) {
    return ApiService.get(`patient?id=${id}`);
  },

  post(payload) {
    return ApiService.post(`editPatient`, payload);
  }
};

export const EditTemplateService = {
  get(id) {
    return ApiService.get(`template?id=${id}`);
  },

  post(payload) {
    return ApiService.post(`editTemplate`, payload);
  },

  delete(id) {
    return ApiService.get(`deleteTemplate?id=${id}`);
  }
};

export const FillInvestTemplateService = {
  get(id) {
    return ApiService.get(`template?id=${id}`);
  },

  post(payload) {
    return ApiService.post(`addTemplate`, payload);
  }
};

export const InvestsService = {
  getInvests(page) {
    return ApiService.get("examinations?page=", page);
  },

  getDoctors() {
    return ApiService.get("allPhysicians");
  },

  post(payload) {
    return ApiService.post(`updateInvest`, payload);
  },

  delete(slug) {
    return ApiService.get(`deleteExamination?id=${slug}`);
  }
};

export const PatientService = {
  getInvests(page, patientId) {
    return ApiService.get(`examinations?page=${page}&patientId=${patientId}`);
  },

  getDepartments() {
    return ApiService.get("departments");
  },

  getInPatient(patientId) {
    return ApiService.get(`inPatient?id=${patientId}`);
  },

  getDoctors() {
    return ApiService.get(`allPhysicians`);
  },

  addEmptyInvest(patientId) {
    return ApiService.get(`addEmptyInvest?patientId=${patientId}`);
  },

  updateInvest(payload) {
    return ApiService.post(`updateInvest`, payload);
  },

  addInPatient(payload) {
    return ApiService.post(`addInPatient`, payload);
  },

  setInPatientDischarged(payload) {
    return ApiService.post(`editInPatient`, payload);
  },

  delete(id) {
    return ApiService.get(`deletePatient?id=${id}`);
  },

  deleteExamination(id) {
    return ApiService.get(`deleteExamination?id=${id}`);
  }
};

export const PatientsService = {
  get(page, family, tags) {
    return ApiService.get(`patients?page=${page}&family=${family}&tags=${tags}`);
  }
};

export const PrescribeService = {
  getInPatients(page, room) {
    return ApiService.get(`inPatients?page=${page}&roomId=${room}`);
  },

  updateInPatient(payload) {
    return ApiService.post(`editInPatient`, payload);
  }
};

export const SettingsService = {
  getSettings() {
    return ApiService.get("getSettings");
  },

  getDepartments() {
    return ApiService.get("departments");
  },

  updateSetting(payload) {
    return ApiService.post(`updateSetting`, payload);
  },

  updateDepartmentsAndRooms(payload) {
    return ApiService.post(`updateDepartmentsAndRooms`, payload);
  }
};

export const TemplatesService = {
  get(page) {
    return ApiService.get(`templates?page=${page}`);
  },

  deleteTemplate(id) {
    return ApiService.get(`deleteTemplate?id=${id}`);
  }
};