webpackJsonp([20],{
    LbE0:function(t,e,s){
        "use strict";
        Object.defineProperty(e,"__esModule",{value:!0});
        var n={
            name:"help-view",
            components:{},
            data:function(){return{lang:window.localStorage.getItem("language")||"en"}},
            computed:{ },
            methods:{}
        },
        a={ //help view
            render:function(){
                var t=this,e=t.$createElement,s=t._self._c||e;
                return s("div",{staticClass:"help-view"},[
                    s("div",{staticClass:"page-title"},[t._v(t._s(t.$t("leftbar.help")))]),
                    t._v(" "),
                    s("div",{staticClass:"help-item"},[
                        s("h3",[t._v(t._s(t.$t("help.quickStart")))]),
                        t._v(" "),
                        s("p",[t._v(t._s(t.$t("help.emqxDesc")))])
                    ]),
                    t._v(" "),
                    s("el-divider"),
                    t._v(" "),
                    s("div",{staticClass:"help-item"},[
                        s("h3",[t._v(t._s(t.$t("help.emqxEnterprise")))]),
                        t._v(" "),
                        s("p",{domProps:{innerHTML:t._s(t.$t("help.enterpriseDesc"))}}),
                    ]),
                    t._v(" "),
                    s("el-divider"),
                    t._v(" "),
                    s("div",{staticClass:"help-item"},[
                        s("h3",[t._v(t._s(t.$t("help.useDocs")))]),
                        t._v(" "),
                        s("p",[t._v(t._s(t.$t("help.docsDesc")))])
                    ]),
                    t._v(" "),
                    s("el-divider"),
                    t._v(" "),
                    s("div",{staticClass:"help-item"},[
                        s("h3",[
                            t._v("FAQ")]),
                            t._v(" "),
                            s("p",[t._v(t._s(t.$t("help.faqDesc")))]),
                        ]
                    ),
                    t._v(" "),
                    s("el-divider"),
                    t._v(" ")
                ],1)},
                    staticRenderFns:[ 

                    ]
                };
                var i=s("VU/8")(n,a,!1,function(t){s("fYOn")},null,null);e.default=i.exports},fYOn:function(t,e){}});