<template>
  <div>
    <b-container>
      <b-row class="mb-2">
        <b-col>
          <component :is="dynamicComponent" />
        </b-col>
        <b-col>
          <div style="position:fixed">
            <h2>Разделы:</h2>
            <component :is="dynamicNavigation" />
          </div>
        </b-col>
      </b-row>
    </b-container>
    <router-view></router-view>
  </div>
</template>

<script>
import { ValidationProvider, extend, ValidationObserver } from "vee-validate";
import { required } from "vee-validate/dist/rules";
import { API_URL } from "@/common/config";
import { FillInvestTemplateService } from "@/common/api.service";

extend("required", {
  ...required,
  message: "Обязательное поле"
});

export default {
  name: "fillInvestTemplate",
  components: {
    ValidationProvider,
    ValidationObserver
  },
  computed: {
    dynamicComponent: function() {
      return {
        template: `<div>${this.hashTags(
          this.content,
          this.patientId,
          this.physician,
          this.examinationDate,
          this.name
        )}</div>`,
        methods: {
          someAction() {
            console.log("Action!");
          }
        }
      };
    },
    dynamicNavigation: function() {
      return {
        template: `<div>${this.renderNavigation(this.content)}</div>`,
        methods: {
          someAction() {
            console.log("Action!");
          }
        }
      };
    }
  },
  created: function() {
    this.patientId = this.$route.query.patientId;
    this.physician = this.$route.query.physician;
    this.examinationDate = this.$route.query.examinationDate;
    this.fetchData();
  },
  methods: {
    renderNavigation: function(content) {
      var f = content.split("\n");

      var location = function(a, b) {
        return "#" + a + '">' + b + "</a><br>";
      };

      var result = "";
      var i = 1;

      f.forEach(line => {
        if (line != "" && line.substring(0, 1) == "{") {
          result += '<a href="' + location(i, line.substring(1)) + "\n";
          i++;
        }
      });

      return result;
    },
    hashTags: function(value, patientId, physician, examinationDate, name) {
      var f = value.split("\n");
      var formstring = "<p>";
      var form = function(a) {
        return (
          '<form name="form" action="' +
          API_URL +
          'processExaminationTemplate" target="_top" method="post">\n' +
          a +
          '\n<br><input type="reset" value="Очистить форму" />\n<input type="submit" value="Отправить данные"/>\n</form>'
        );
      };

      var hidden = function(a, b) {
        return '<input type="hidden" name="' + a + '" value="' + b + '">';
      };

      var theinput = function(a, b, c, d, e) {
        return (
          '<br><label><input type="' +
          a +
          '" name="' +
          b +
          '" value="' +
          c +
          '" id="' +
          d +
          '">&nbsp;' +
          e +
          "</label>"
        );
      };

      var radioinput = function(a, b, c, d) {
        return (
          '<br><label><input type="radio" name="' +
          a +
          '" value="' +
          b +
          '" ondblclick="uncheckRadio(document.form.' +
          c +
          ');">&nbsp;' +
          d +
          "</label>"
        );
      };
      var optioninput = function(a, b) {
        return '<option value="' + a + '">' + b + "</option>";
      };
      var selectinput = function(a, b, c) {
        return (
          '<select name="' +
          a +
          '">\n<option value="' +
          b +
          '">' +
          c +
          "</option>"
        );
      };
      var textinput = function(a, b) {
        return '<input type="text" name="' + a + '" value="" size=' + b + ">";
      };
      var textarea = function(a, b, c) {
        return (
          '<textarea name="' +
          a +
          '" rows=' +
          b +
          ' style="width:100%%">' +
          c +
          "</textarea>"
        );
      };

      var i = 0;
      var last = "b";
      var k = 0;
      var titles = 1;

      f.forEach(line => {
        if (line == "") {
          line = "\n";
        }
        i++;
        k++;
        if (last == "\\" && line.substring(0, 1) != "\\") {
          formstring += "</select>" + "\n";
        }
        var string = "";
        if (line.substring(0, 1) == "[" || line.substring(0, 1) == "]") {
          string = hidden("item" + i, line.substring(0, 1));
        } else if (line.substring(0, 1) == ">" || line.substring(0, 1) == "<") {
          string = "<br>" + hidden("item" + i, line) + line.substring(1);
        } else if (line.substring(0, 1) == "=") {
          string = hidden("item" + i, line) + line.substring(1);
        } else if (line.substring(0, 1) == "+") {
          string = theinput(
            "checkbox",
            "item" + i,
            line,
            "check" + k,
            line.substring(1)
          );
        } else if (line.substring(0, 1) == "-") {
          if (last == "-") {
            i--;
          }
          string = radioinput("item" + i, line, "item" + i, line.substring(1));
        } else if (line.substring(0, 1) == "#") {
          string = textinput("item" + i, line.length);
        } else if (line.substring(0, 1) == "$") {
          string = textarea(
            "item" + i,
            line.substring(0, 1),
            line
              .substring(2)
              .strip()
              .replace("\\", "\n")
          );
        } else if (line.substring(0, 1) == "\\" && last != "\\") {
          string = selectinput("item" + i, line, line.substring(1));
        } else if (line.substring(0, 1) == "\\" && last == "\\") {
          string = optioninput(line, line.substring(1));
          i--;
        } else if (line.substring(0, 1) == "{") {
          string =
            '<h1><a name = "' + titles + '">' + line.substring(1) + "</a></h1>";
          titles = titles + 1;
        } else if (line.substring(0, 1) == "p") {
          string = hidden("item" + i, "p" * line.length);
        } else if (
          line.substring(0, 1) == "\r" ||
          line.substring(0, 1) == "\n" ||
          line.substring(0, 1) == " "
        ) {
          string = "<br>" + hidden("item" + i, "p");
        } else {
          i = i - 1;
          return;
        }
        last = line.substring(0, 1);
        formstring += string + "\n";
      });

      formstring += hidden("items_number", i) + "\n";
      formstring += hidden("patient_id", patientId) + "\n";
      formstring += hidden("physician", physician) + "\n";
      formstring += hidden("name", name) + "\n";
      formstring += hidden("examdate", examinationDate) + "\n";

      return form(formstring);
    },
    fetchData() {
      this.loading = true;
      FillInvestTemplateService.get(this.$route.query.id).then(data => {
        this.id = data.data.id;
        this.name = data.data.name;
        this.content = data.data.content;
        this.html = data.data.html;
        this.comments = data.data.comments;
      });
    },
    goToTemplatesList: function() {
      this.$router.push("templates");
    },
    onSubmit() {
      FillInvestTemplateService.post(this.$data).then(data => {
        console.log(data);
      });
    }
  },
  data() {
    return {
      patientId: null,
      physician: null,
      name: null,
      examinationDate: null,
      itemsNumber: null,
      content: "",
      html: null,
      comments: null
    };
  }
};
</script>
