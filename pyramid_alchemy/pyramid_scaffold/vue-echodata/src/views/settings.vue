<template>
  <div>
    <h2>Настройки:</h2>
    <b-row>
      <b-col>
        <h4>Название ЛПУ:</h4>
        <b-form-input v-model="clinicNameSetting.value" placeholder="Заголовок (название)"></b-form-input>
      </b-col>
    </b-row>
    <br />
    <b-row>
      <b-col>
        <h4>Адрес ЛПУ:</h4>
        <b-form-textarea
          id="textarea"
          v-model="clinicAddressSetting.value"
          placeholder="Подзаголовок (адрес)"
          rows="3"
          max-rows="6"
        ></b-form-textarea>
      </b-col>
    </b-row>
    <br />
    <b-row>
      <b-col>
        <h4>Структура стационара:</h4>
        <b-tree-view
          ref="foo"
          toggle
          :data="treeData"
          :contextMenuItems="contextMenuItems"
          @contextMenuItemSelect="onTreeContextMenu"
          @nodeSelect="onTreeNodeSelected"
        ></b-tree-view>
      </b-col>
    </b-row>
    <br />
    <b-row>
      <b-col>
        <b-button v-on:click="saveSettings">Сохранить</b-button>
      </b-col>
    </b-row>
    <router-view></router-view>
  </div>
</template>

<script>
import { bTreeView } from "bootstrap-vue-treeview";
import { SettingsService } from "@/common/api.service";

export default {
  name: "settings",
  components: {
    bTreeView
  },
  methods: {
    getMaxDepartmentId() {
      var id = 0;
      this.treeData[0].children.forEach(department => {
        if (department.id > id) {
          id = department.id;
        }
      });
      id++;
      return id;
    },
    getMaxRoomId() {
      var id = 0;
      this.treeData[0].children.forEach(department => {
        if (department.children) {
          department.children.forEach(room => {
            if (room.id > id) {
              id = room.id;
            }
          });
        }
      });
      id++;
      return id;
    },
    onTreeContextMenu(item, node) {
      if (item.code === "ADD_NODE") {
        if (node.data.type == "department") {
          var roomName = prompt("Введите название комнаты");
          if (roomName == null) return;
          node.appendChild({
            id: this.getMaxRoomId(),
            name: roomName,
            type: "room"
          });
        } else if (node.data.type == "root") {
          var departName = prompt("Введите название отделения");
          if (departName == null) return;
          node.appendChild({
            id: this.getMaxDepartmentId(),
            name: departName,
            type: "department"
          });
        }
      }
    },
    fetchData() {
      this.loading = true;
      SettingsService.getSettings().then(data => {
        this.clinicNameSetting = data.data.clinicNameSetting;
        this.clinicAddressSetting = data.data.clinicAddressSetting;
      });

      SettingsService.getDepartments().then(data => {
        this.treeData = [
          {
            name: "Отделения:",
            type: "root"
          }
        ];
        this.treeData[0].children = [];

        var departments = data.data.departments;
        departments.forEach(department => {
          department.type = "department";
          department.rooms.forEach(room => {
            room.type = "room";
          });
          department.children = department.rooms;
          this.treeData[0].children.push(department);
        });
      });
    },
    saveSettings() {
      SettingsService.updateSetting(this.$data.clinicNameSetting).then(data => {
        console.log(data);
      });

      SettingsService.updateSetting(this.$data.clinicAddressSetting).then(data => {
        console.log(data);
      });

      SettingsService.updateDepartmentsAndRooms(this.$data.treeData[0].children).then(data => {
        console.log(data);
      });
    }
  },
  created: function() {
    this.fetchData();
    this.$refs.foo.toggle();
  },
  data() {
    return {
      clinicNameSetting: null,
      clinicAddressSetting: null,
      clinicNameSettingValue: null,
      clinicAddressSettingValue: null,
      contextMenuItems: [
        { code: "ADD_NODE", label: "Добавить" },
        { code: "RENAME_NODE", label: "Переименовать" },
        { code: "DELETE_NODE", label: "Удалить" }
      ],
      treeData: [
        {
          name: "Отделения:",
          type: "root",
          children: []
        }
      ]
    };
  }
};
</script>
