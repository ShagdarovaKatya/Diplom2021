(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-b5f6ae7a"],{"02bd":function(t,e,r){"use strict";r.r(e);var a=function(){var t=this,e=t.$createElement,r=t._self._c||e;return r("div",[r("b-container",[r("b-row",{staticClass:"mb-2"},[r("b-col",[r("h2",{attrs:{for:"example-datepicker"}},[t._v("Форма выписка:")])])],1),r("ValidationObserver",{scopedSlots:t._u([{key:"default",fn:function(e){var a=e.handleSubmit;return[r("b-form",{on:{submit:function(e){return e.preventDefault(),a(t.onSubmit)}}},[r("b-row",{staticClass:"mb-2"},[r("b-col",{attrs:{md:"4"}},[r("validation-provider",{attrs:{rules:{required:!0}},scopedSlots:t._u([{key:"default",fn:function(e){var a=e.errors;return[r("b-form-input",{attrs:{placeholder:"Название"},model:{value:t.name,callback:function(e){t.name=e},expression:"name"}}),r("span",{staticClass:"validationError"},[t._v(t._s(a[0]))])]}}],null,!0)})],1)],1),r("b-row",{staticClass:"mb-2"},[r("b-col",{staticClass:"mb-2",attrs:{md:"4"}},[r("validation-provider",{attrs:{rules:{required:!0}},scopedSlots:t._u([{key:"default",fn:function(e){var a=e.errors;return[r("b-form-textarea",{attrs:{id:"textarea",placeholder:"Шаблон",rows:"3","max-rows":"6"},model:{value:t.content,callback:function(e){t.content=e},expression:"content"}}),r("span",{staticClass:"validationError"},[t._v(t._s(a[0]))])]}}],null,!0)})],1)],1),r("b-row",{staticClass:"mb-2"},[r("b-col",{staticClass:"mb-2",attrs:{md:"4"}},[r("b-form-textarea",{attrs:{id:"textarea",placeholder:"HTML",rows:"3","max-rows":"6"},model:{value:t.html,callback:function(e){t.html=e},expression:"html"}})],1)],1),r("b-row",{staticClass:"mb-2"},[r("b-col",{attrs:{md:"4"}},[r("b-form-textarea",{attrs:{id:"textarea",placeholder:"Комментарий",rows:"3","max-rows":"6"},model:{value:t.comments,callback:function(e){t.comments=e},expression:"comments"}})],1)],1),r("b-row",{staticClass:"mb-2"},[r("b-col",{attrs:{md:"3"}},[r("b-button",{attrs:{type:"submit"}},[t._v("Сохранить изменения")])],1),r("b-col",{attrs:{md:"3"}},[r("b-button",{on:{click:t.deleteTemplate}},[t._v("Удалить форму")])],1),r("b-col",[r("b-button",{on:{click:t.goToTemplatesList}},[t._v("Назад к списку шаблонов")])],1)],1)],1)]}}])})],1),r("router-view")],1)},n=[],o=(r("8e6e"),r("ac6a"),r("456d"),r("7f7f"),r("bd86")),s=r("7bb1"),c=r("4c93"),l=r("5ce5");function i(t,e){var r=Object.keys(t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(t);e&&(a=a.filter((function(e){return Object.getOwnPropertyDescriptor(t,e).enumerable}))),r.push.apply(r,a)}return r}function u(t){for(var e=1;e<arguments.length;e++){var r=null!=arguments[e]?arguments[e]:{};e%2?i(Object(r),!0).forEach((function(e){Object(o["a"])(t,e,r[e])})):Object.getOwnPropertyDescriptors?Object.defineProperties(t,Object.getOwnPropertyDescriptors(r)):i(Object(r)).forEach((function(e){Object.defineProperty(t,e,Object.getOwnPropertyDescriptor(r,e))}))}return t}Object(s["c"])("required",u(u({},c["a"]),{},{message:"Обязательное поле"}));var m={name:"editTemplate",components:{ValidationProvider:s["b"],ValidationObserver:s["a"]},created:function(){this.fetchData()},methods:{deleteTemplate:function(){var t=this;l["f"].delete(this.$route.query.id).then((function(e){t.$router.push("templates"),console.log(e)}))},fetchData:function(){var t=this;this.loading=!0,l["f"].get(this.$route.query.id).then((function(e){t.id=e.data.id,t.name=e.data.name,t.content=e.data.content,t.html=e.data.html,t.comments=e.data.comments}))},goToTemplatesList:function(){this.$router.push("templates")},onSubmit:function(){var t=this;l["f"].post(this.$data).then((function(e){t.$router.push("templates"),console.log(e)}))}},data:function(){return{id:null,name:null,content:null,html:null,comments:null}}},b=m,d=r("2877"),f=Object(d["a"])(b,a,n,!1,null,null,null);e["default"]=f.exports},"7f7f":function(t,e,r){var a=r("86cc").f,n=Function.prototype,o=/^\s*function ([^ (]*)/,s="name";s in n||r("9e1e")&&a(n,s,{configurable:!0,get:function(){try{return(""+this).match(o)[1]}catch(t){return""}}})}}]);
//# sourceMappingURL=chunk-b5f6ae7a.ec92f454.js.map