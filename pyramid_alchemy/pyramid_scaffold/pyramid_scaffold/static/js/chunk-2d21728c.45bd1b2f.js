(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-2d21728c"],{c614:function(t,e,n){"use strict";n.r(e);var a=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"container page"},[n("b-container",[n("b-row",[n("b-col",{attrs:{md:"1"}},[n("a",[t._v("Палаты:")])]),n("b-col",{attrs:{md:"9"}},[n("b-button-group",[t._l(t.items,(function(e){return n("b-button",{key:e.room.id,on:{click:function(n){return t.fetchData(1,e.room.id)}}},[t._v(t._s(e.room.name))])})),n("b-button",{on:{click:function(e){return t.fetchData(1)}}},[t._v("Все палаты")])],2)],1),n("b-col",{attrs:{md:"2"}},[n("b-button",{on:{click:t.onPrint}},[t._v("Распечатать")])],1)],1)],1),n("br"),n("b-table",{attrs:{id:"in-patients-table",items:t.items,fields:t.fields},scopedSlots:t._u([{key:"cell(orders)",fn:function(e){return[n("h5",{staticClass:"mb-1"},[t._v(t._s(e.item.patient.family+" "+e.item.patient.name+" "+e.item.patient.thirdName))]),n("a",[t._v(t._s(e.item.department.name+" "+e.item.room.name))]),n("b-form-textarea",{attrs:{id:"textarea",placeholder:"Назначения...",rows:"3","max-rows":"6"},model:{value:e.item.orders,callback:function(n){t.$set(e.item,"orders",n)},expression:"row.item.orders"}})]}},{key:"cell(problems)",fn:function(e){return[n("br"),n("br"),n("b-form-textarea",{attrs:{id:"textarea",placeholder:"План обследования, проблемы...",rows:"3","max-rows":"6"},model:{value:e.item.problems,callback:function(n){t.$set(e.item,"problems",n)},expression:"row.item.problems"}})]}},{key:"cell(action)",fn:function(e){return[n("br"),n("br"),n("br"),n("b-button",{on:{click:function(n){return t.saveInPatient(e)}}},[t._v("Сохранить")])]}}])}),n("b-pagination",{attrs:{"total-rows":t.rows,"per-page":t.perPage,"aria-controls":"in-patients-table"},on:{input:function(e){return t.fetchData(t.currentPage)}},model:{value:t.currentPage,callback:function(e){t.currentPage=e},expression:"currentPage"}}),n("router-view")],1)},r=[],o=n("5ce5"),i=n("a49b"),c={name:"doctors",components:{},created:function(){this.fetchData(1)},methods:{saveInPatient:function(t){var e=this;o["k"].updateInPatient(t.item).then((function(t){e.fetchData(e.currentPage),console.log(t)}))},onPrint:function(){window.location=i["a"]+"printOrders"},fetchData:function(t,e){var n=this;this.loading=!0,o["k"].getInPatients(t||1,e||"").then((function(t){n.items=t.data.items,n.rows=t.data.totalItems,n.perPage=t.data.per_page,n.loading=!1}))}},data:function(){return{perPage:2,currentPage:1,rows:null,fields:[{key:"orders",label:""},{key:"problems",label:""},{key:"action",label:""}],items:null}}},s=c,l=n("2877"),u=Object(l["a"])(s,a,r,!1,null,null,null);e["default"]=u.exports}}]);
//# sourceMappingURL=chunk-2d21728c.45bd1b2f.js.map