(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-536b8699"],{"02f4":function(t,e,n){var r=n("4588"),i=n("be13");t.exports=function(t){return function(e,n){var a,o,c=String(i(e)),u=r(n),s=c.length;return u<0||u>=s?t?"":void 0:(a=c.charCodeAt(u),a<55296||a>56319||u+1===s||(o=c.charCodeAt(u+1))<56320||o>57343?t?c.charAt(u):a:t?c.slice(u,u+2):o-56320+(a-55296<<10)+65536)}}},"0390":function(t,e,n){"use strict";var r=n("02f4")(!0);t.exports=function(t,e,n){return e+(n?r(t,e).length:1)}},"0bfb":function(t,e,n){"use strict";var r=n("cb7c");t.exports=function(){var t=r(this),e="";return t.global&&(e+="g"),t.ignoreCase&&(e+="i"),t.multiline&&(e+="m"),t.unicode&&(e+="u"),t.sticky&&(e+="y"),e}},"214f":function(t,e,n){"use strict";n("b0c5");var r=n("2aba"),i=n("32e9"),a=n("79e5"),o=n("be13"),c=n("2b4c"),u=n("520a"),s=c("species"),l=!a((function(){var t=/./;return t.exec=function(){var t=[];return t.groups={a:"7"},t},"7"!=="".replace(t,"$<a>")})),f=function(){var t=/(?:)/,e=t.exec;t.exec=function(){return e.apply(this,arguments)};var n="ab".split(t);return 2===n.length&&"a"===n[0]&&"b"===n[1]}();t.exports=function(t,e,n){var p=c(t),h=!a((function(){var e={};return e[p]=function(){return 7},7!=""[t](e)})),b=h?!a((function(){var e=!1,n=/a/;return n.exec=function(){return e=!0,null},"split"===t&&(n.constructor={},n.constructor[s]=function(){return n}),n[p](""),!e})):void 0;if(!h||!b||"replace"===t&&!l||"split"===t&&!f){var g=/./[p],d=n(o,p,""[t],(function(t,e,n,r,i){return e.exec===u?h&&!i?{done:!0,value:g.call(e,n,r)}:{done:!0,value:t.call(n,e,r)}:{done:!1}})),v=d[0],m=d[1];r(String.prototype,t,v),i(RegExp.prototype,p,2==e?function(t,e){return m.call(t,this,e)}:function(t){return m.call(t,this)})}}},"28a5":function(t,e,n){"use strict";var r=n("aae3"),i=n("cb7c"),a=n("ebd6"),o=n("0390"),c=n("9def"),u=n("5f1b"),s=n("520a"),l=n("79e5"),f=Math.min,p=[].push,h="split",b="length",g="lastIndex",d=4294967295,v=!l((function(){RegExp(d,"y")}));n("214f")("split",2,(function(t,e,n,l){var m;return m="c"=="abbc"[h](/(b)*/)[1]||4!="test"[h](/(?:)/,-1)[b]||2!="ab"[h](/(?:ab)*/)[b]||4!="."[h](/(.?)(.?)/)[b]||"."[h](/()()/)[b]>1||""[h](/.?/)[b]?function(t,e){var i=String(this);if(void 0===t&&0===e)return[];if(!r(t))return n.call(i,t,e);var a,o,c,u=[],l=(t.ignoreCase?"i":"")+(t.multiline?"m":"")+(t.unicode?"u":"")+(t.sticky?"y":""),f=0,h=void 0===e?d:e>>>0,v=new RegExp(t.source,l+"g");while(a=s.call(v,i)){if(o=v[g],o>f&&(u.push(i.slice(f,a.index)),a[b]>1&&a.index<i[b]&&p.apply(u,a.slice(1)),c=a[0][b],f=o,u[b]>=h))break;v[g]===a.index&&v[g]++}return f===i[b]?!c&&v.test("")||u.push(""):u.push(i.slice(f)),u[b]>h?u.slice(0,h):u}:"0"[h](void 0,0)[b]?function(t,e){return void 0===t&&0===e?[]:n.call(this,t,e)}:n,[function(n,r){var i=t(this),a=void 0==n?void 0:n[e];return void 0!==a?a.call(n,i,r):m.call(String(i),n,r)},function(t,e){var r=l(m,t,this,e,m!==n);if(r.done)return r.value;var s=i(t),p=String(this),h=a(s,RegExp),b=s.unicode,g=(s.ignoreCase?"i":"")+(s.multiline?"m":"")+(s.unicode?"u":"")+(v?"y":"g"),x=new h(v?s:"^(?:"+s.source+")",g),y=void 0===e?d:e>>>0;if(0===y)return[];if(0===p.length)return null===u(x,p)?[p]:[];var w=0,O=0,E=[];while(O<p.length){x.lastIndex=v?O:0;var S,j=u(x,v?p:p.slice(O));if(null===j||(S=f(c(x.lastIndex+(v?0:O)),p.length))===w)O=o(p,O,b);else{if(E.push(p.slice(w,O)),E.length===y)return E;for(var $=1;$<=j.length-1;$++)if(E.push(j[$]),E.length===y)return E;O=w=S}}return E.push(p.slice(w)),E}]}))},"520a":function(t,e,n){"use strict";var r=n("0bfb"),i=RegExp.prototype.exec,a=String.prototype.replace,o=i,c="lastIndex",u=function(){var t=/a/,e=/b*/g;return i.call(t,"a"),i.call(e,"a"),0!==t[c]||0!==e[c]}(),s=void 0!==/()??/.exec("")[1],l=u||s;l&&(o=function(t){var e,n,o,l,f=this;return s&&(n=new RegExp("^"+f.source+"$(?!\\s)",r.call(f))),u&&(e=f[c]),o=i.call(f,t),u&&o&&(f[c]=f.global?o.index+o[0].length:e),s&&o&&o.length>1&&a.call(o[0],n,(function(){for(l=1;l<arguments.length-2;l++)void 0===arguments[l]&&(o[l]=void 0)})),o}),t.exports=o},"5f1b":function(t,e,n){"use strict";var r=n("23c6"),i=RegExp.prototype.exec;t.exports=function(t,e){var n=t.exec;if("function"===typeof n){var a=n.call(t,e);if("object"!==typeof a)throw new TypeError("RegExp exec method returned something other than an Object or null");return a}if("RegExp"!==r(t))throw new TypeError("RegExp#exec called on incompatible receiver");return i.call(t,e)}},"7f7f":function(t,e,n){var r=n("86cc").f,i=Function.prototype,a=/^\s*function ([^ (]*)/,o="name";o in i||n("9e1e")&&r(i,o,{configurable:!0,get:function(){try{return(""+this).match(a)[1]}catch(t){return""}}})},a481:function(t,e,n){"use strict";var r=n("cb7c"),i=n("4bf8"),a=n("9def"),o=n("4588"),c=n("0390"),u=n("5f1b"),s=Math.max,l=Math.min,f=Math.floor,p=/\$([$&`']|\d\d?|<[^>]*>)/g,h=/\$([$&`']|\d\d?)/g,b=function(t){return void 0===t?t:String(t)};n("214f")("replace",2,(function(t,e,n,g){return[function(r,i){var a=t(this),o=void 0==r?void 0:r[e];return void 0!==o?o.call(r,a,i):n.call(String(a),r,i)},function(t,e){var i=g(n,t,this,e);if(i.done)return i.value;var f=r(t),p=String(this),h="function"===typeof e;h||(e=String(e));var v=f.global;if(v){var m=f.unicode;f.lastIndex=0}var x=[];while(1){var y=u(f,p);if(null===y)break;if(x.push(y),!v)break;var w=String(y[0]);""===w&&(f.lastIndex=c(p,a(f.lastIndex),m))}for(var O="",E=0,S=0;S<x.length;S++){y=x[S];for(var j=String(y[0]),$=s(l(o(y.index),p.length),0),k=[],R=1;R<y.length;R++)k.push(b(y[R]));var I=y.groups;if(h){var A=[j].concat(k,$,p);void 0!==I&&A.push(I);var D=String(e.apply(void 0,A))}else D=d(j,p,$,k,I,e);$>=E&&(O+=p.slice(E,$)+D,E=$+j.length)}return O+p.slice(E)}];function d(t,e,r,a,o,c){var u=r+t.length,s=a.length,l=h;return void 0!==o&&(o=i(o),l=p),n.call(c,l,(function(n,i){var c;switch(i.charAt(0)){case"$":return"$";case"&":return t;case"`":return e.slice(0,r);case"'":return e.slice(u);case"<":c=o[i.slice(1,-1)];break;default:var l=+i;if(0===l)return n;if(l>s){var p=f(l/10);return 0===p?n:p<=s?void 0===a[p-1]?i.charAt(1):a[p-1]+i.charAt(1):n}c=a[l-1]}return void 0===c?"":c}))}}))},aae3:function(t,e,n){var r=n("d3f4"),i=n("2d95"),a=n("2b4c")("match");t.exports=function(t){var e;return r(t)&&(void 0!==(e=t[a])?!!e:"RegExp"==i(t))}},b0c5:function(t,e,n){"use strict";var r=n("520a");n("5ca1")({target:"RegExp",proto:!0,forced:r!==/./.exec},{exec:r})},b1bd:function(t,e,n){"use strict";n.r(e);var r=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",[n("b-container",[n("b-row",{staticClass:"mb-2"},[n("b-col",[n(t.dynamicComponent,{tag:"component"})],1),n("b-col",[n("div",{staticStyle:{position:"fixed"}},[n("h2",[t._v("Разделы:")]),n(t.dynamicNavigation,{tag:"component"})],1)])],1)],1),n("router-view")],1)},i=[],a=(n("8e6e"),n("456d"),n("a481"),n("ac6a"),n("28a5"),n("7f7f"),n("bd86")),o=n("7bb1"),c=n("4c93"),u=n("a49b"),s=n("5ce5");function l(t,e){var n=Object.keys(t);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(t);e&&(r=r.filter((function(e){return Object.getOwnPropertyDescriptor(t,e).enumerable}))),n.push.apply(n,r)}return n}function f(t){for(var e=1;e<arguments.length;e++){var n=null!=arguments[e]?arguments[e]:{};e%2?l(Object(n),!0).forEach((function(e){Object(a["a"])(t,e,n[e])})):Object.getOwnPropertyDescriptors?Object.defineProperties(t,Object.getOwnPropertyDescriptors(n)):l(Object(n)).forEach((function(e){Object.defineProperty(t,e,Object.getOwnPropertyDescriptor(n,e))}))}return t}Object(o["c"])("required",f(f({},c["a"]),{},{message:"Обязательное поле"}));var p={name:"fillInvestTemplate",components:{ValidationProvider:o["b"],ValidationObserver:o["a"]},computed:{dynamicComponent:function(){return{template:"<div>".concat(this.hashTags(this.content,this.patientId,this.physician,this.examinationDate,this.name),"</div>"),methods:{someAction:function(){console.log("Action!")}}}},dynamicNavigation:function(){return{template:"<div>".concat(this.renderNavigation(this.content),"</div>"),methods:{someAction:function(){console.log("Action!")}}}}},created:function(){this.patientId=this.$route.query.patientId,this.physician=this.$route.query.physician,this.examinationDate=this.$route.query.examinationDate,this.fetchData()},methods:{renderNavigation:function(t){var e=t.split("\n"),n=function(t,e){return"#"+t+'">'+e+"</a><br>"},r="",i=1;return e.forEach((function(t){""!=t&&"{"==t.substring(0,1)&&(r+='<a href="'+n(i,t.substring(1))+"\n",i++)})),r},hashTags:function(t,e,n,r,i){var a=t.split("\n"),o="<p>",c=function(t){return'<form name="form" action="'+u["a"]+'processExaminationTemplate" target="_top" method="post">\n'+t+'\n<br><input type="reset" value="Очистить форму" />\n<input type="submit" value="Отправить данные"/>\n</form>'},s=function(t,e){return'<input type="hidden" name="'+t+'" value="'+e+'">'},l=function(t,e,n,r,i){return'<br><label><input type="'+t+'" name="'+e+'" value="'+n+'" id="'+r+'">&nbsp;'+i+"</label>"},f=function(t,e,n,r){return'<br><label><input type="radio" name="'+t+'" value="'+e+'" ondblclick="uncheckRadio(document.form.'+n+');">&nbsp;'+r+"</label>"},p=function(t,e){return'<option value="'+t+'">'+e+"</option>"},h=function(t,e,n){return'<select name="'+t+'">\n<option value="'+e+'">'+n+"</option>"},b=function(t,e){return'<input type="text" name="'+t+'" value="" size='+e+">"},g=function(t,e,n){return'<textarea name="'+t+'" rows='+e+' style="width:100%%">'+n+"</textarea>"},d=0,v="b",m=0,x=1;return a.forEach((function(t){""==t&&(t="\n"),d++,m++,"\\"==v&&"\\"!=t.substring(0,1)&&(o+="</select>\n");var e="";if("["==t.substring(0,1)||"]"==t.substring(0,1))e=s("item"+d,t.substring(0,1));else if(">"==t.substring(0,1)||"<"==t.substring(0,1))e="<br>"+s("item"+d,t)+t.substring(1);else if("="==t.substring(0,1))e=s("item"+d,t)+t.substring(1);else if("+"==t.substring(0,1))e=l("checkbox","item"+d,t,"check"+m,t.substring(1));else if("-"==t.substring(0,1))"-"==v&&d--,e=f("item"+d,t,"item"+d,t.substring(1));else if("#"==t.substring(0,1))e=b("item"+d,t.length);else if("$"==t.substring(0,1))e=g("item"+d,t.substring(0,1),t.substring(2).strip().replace("\\","\n"));else if("\\"==t.substring(0,1)&&"\\"!=v)e=h("item"+d,t,t.substring(1));else if("\\"==t.substring(0,1)&&"\\"==v)e=p(t,t.substring(1)),d--;else if("{"==t.substring(0,1))e='<h1><a name = "'+x+'">'+t.substring(1)+"</a></h1>",x+=1;else if("p"==t.substring(0,1))e=s("item"+d,"p"*t.length);else{if("\r"!=t.substring(0,1)&&"\n"!=t.substring(0,1)&&" "!=t.substring(0,1))return void(d-=1);e="<br>"+s("item"+d,"p")}v=t.substring(0,1),o+=e+"\n"})),o+=s("items_number",d)+"\n",o+=s("patient_id",e)+"\n",o+=s("physician",n)+"\n",o+=s("name",i)+"\n",o+=s("examdate",r)+"\n",c(o)},fetchData:function(){var t=this;this.loading=!0,s["g"].get(this.$route.query.id).then((function(e){t.id=e.data.id,t.name=e.data.name,t.content=e.data.content,t.html=e.data.html,t.comments=e.data.comments}))},goToTemplatesList:function(){this.$router.push("templates")},onSubmit:function(){s["g"].post(this.$data).then((function(t){console.log(t)}))}},data:function(){return{patientId:null,physician:null,name:null,examinationDate:null,itemsNumber:null,content:"",html:null,comments:null}}},h=p,b=n("2877"),g=Object(b["a"])(h,r,i,!1,null,null,null);e["default"]=g.exports}}]);
//# sourceMappingURL=chunk-536b8699.98e25e54.js.map