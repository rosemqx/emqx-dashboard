webpackJsonp([12],{SFPK:function(t,e){},VKKr:function(t,e,s){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var o=s("mvHQ"),a=s.n(o),i=s("zL8q"),n=s("VOAv"),l={name:"settings-view",components:{"el-radio":i.Radio,"el-radio-group":i.RadioGroup,"el-button":i.Button,"el-form":i.Form,"el-form-item":i.FormItem,"el-row":i.Row,"el-col":i.Col,"el-card":i.Card},data:function(){return{options:{themes:"",language:""},defaultConfig:"",defaultThemes:"",defaultLanguage:""}},computed:{notChanged:function(){return this.defaultConfig===a()(this.options)}},methods:{
    init:function(){
        var t="light-themes";
        this.options.themes=t,
        this.defaultThemes=t,
        this.options.language=window.localStorage.getItem("language")||"en",this.options.language="zh"===this.options.language?"zh":"en",this.defaultLanguage=this.options.language,this.defaultConfig=a()(this.options)},themesToggle:function(){Object(n.b)(this.options.themes)},applySetting:function(){this.$message.success(this.$t("settings.success")),this.themesToggle(),this.defaultThemes=this.options.themes,window.localStorage.setItem("language",this.options.language),window.localStorage.setItem("themes",this.options.themes),this.defaultLanguage!==this.options.language&&setTimeout(function(){location.reload()},600),this.defaultConfig=a()(this.options)}},created:function(){this.init()},beforeRouteLeave:function(t,e,s){this.defaultThemes!==this.options.themes&&Object(n.b)(this.defaultThemes),s()}},r={render:function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("div",{staticClass:"settings-view"},[s("div",{staticClass:"page-title"},[t._v(t._s(t.$t("leftbar.settings")))]),t._v(" "),s("el-card",{staticClass:"el-card--self"},[s("el-row",{attrs:{gutter:20}},[s("el-form",{ref:"options",attrs:{model:t.options,"label-width":"100px","label-position":"top"}},[s("el-col",{attrs:{span:12}},[
    s("el-form-item",{attrs:{label:t.$t("settings.themes")}},[
        s("el-radio-group",{on:{change:t.themesToggle},
        model:{
            value:t.options.themes,
            callback:function(e){t.$set(t.options,"themes",e)},
            expression:"options.themes"}
        },[
            s("el-radio",{attrs:{label:"light-themes"}},[t._v("Light")])
        ],1)
    ],1)
],1),t._v(" "),s("el-col",{attrs:{span:12}},[s("el-form-item",{attrs:{label:t.$t("settings.language")}},[s("el-radio-group",{model:{value:t.options.language,callback:function(e){t.$set(t.options,"language",e)},expression:"options.language"}},[s("el-radio",{attrs:{label:"en"}},[t._v("EN")]),t._v(" "),s("el-radio",{attrs:{label:"zh"}},[t._v("中文")])],1)],1)],1),t._v(" "),s("el-col",{staticClass:"operation-area",attrs:{span:24}},[s("el-form-item",[s("el-button",{staticClass:"confirm-btn",attrs:{type:"success",disabled:t.notChanged},on:{click:t.applySetting}},[t._v("\n              "+t._s(t.$t("settings.apply"))+"\n            ")])],1)],1)],1)],1)],1)],1)},staticRenderFns:[]};var g=s("VU/8")(l,r,!1,function(t){s("SFPK")},null,null);e.default=g.exports}});