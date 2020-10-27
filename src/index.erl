-module(index).
-compile(export_all).
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/n2o.hrl").
-include_lib("kvs/include/kvs.hrl").

-export([event/1]).
-record(i, ?DEFAULT_BASE_TAG(<<"i">>)).

% pi
event(init) ->
    n2o:reg(n2o:sid()),
    nitro:insert_top(app, nav());
event(E)    -> io:format("not handled event ~p.~n", [E]).

nav() -> #nav{class= <<"left-bar">>, body=[
    #panel{class= <<"bar-title">>, body=[
        #image{class=logo, src="/app/mq.svg"},
        #h3{body= <<"Панель керування"/utf8>>}
    ]},
    #list{class= <<"el-menu">>, body=[
        #li{class= <<"el-menu-item">>, body=[
            #i{class= <<"iconfont icon-guanlianshebei">>},
            #panel{class= <<"el-badge menu-dot">>, body= <<"Монітор"/utf8>>}
        ]},
        #li{class= <<"el-menu-item">>, body=[
            #i{class= <<"iconfont">>},
            #panel{class= <<"el-badge menu-dot">>, body= <<"Клієнти"/utf8>>}
        ]}, % /clients
        #li{class= <<"el-menu-item">>, body=[
            #i{class= <<"iconfont icon-zuzhiqunzu">>},
            #panel{class= <<"el-badge menu-dot">>, body= <<"Теми"/utf8>>}
        ]}, % /topics
        #li{class= <<"el-menu-item">>, body=[
            #i{class= <<"iconfont icon-shebeiguanli">>},
            #panel{class= <<"el-badge menu-dot">>, body= <<"Підписки"/utf8>>}
        ]}, % /subscriptions
        #li{class= <<"el-submenu">>, body=[
            #panel{class= <<"el-submenu__title">>, body=[
                #i{class= <<"iconfont icon-guizeyinqing">>},
                #panel{class= <<"el-badge menu-dot">>, body= <<"Правила"/utf8>>}, %
                #i{class= <<"el-submenu__icon-arrow">>}
            ]},
            #list{class= <<"el-menu el-menu--inline">>, body=[
                #li{class= <<"el-menu-item">>,body=[
                    #panel{class= <<"el-badge submenu-dot">>, body= <<"Правила"/utf8>>} % /rules
                ]},
                #li{class= <<"el-menu-item">>,body=[
                    #panel{class= <<"el-badge submenu-dot">>, body= <<"Ресурси"/utf8>>} %/ resources
                ]}
            ]}
        ]},

        #li{class= <<"el-submenu">>, body=[
            #panel{class= <<"el-submenu__title">>, body=[
                #i{class= <<"iconfont icon-shujukanban">>},
                #panel{class= <<"el-badge menu-dot">>, body= <<"Аналітика"/utf8>>}, %
                #i{class= <<"el-submenu__icon-arrow">>}
            ]},
            #list{class= <<"el-menu el-menu--inline">>, body=[
                #li{class= <<"el-menu-item">>,body=[
                    #panel{class= <<"el-badge submenu-dot">>, body= <<"Метрики"/utf8>>} % /topic_metrics
                ]}
            ]}
        ]},

        #li{class= <<"el-menu-item">>, body=[
            #i{class= <<"iconfont icon-kongjian">>},
            #panel{class= <<"el-badge menu-dot">>, body= <<"Плагіни"/utf8>>} %
        ]}, % /plugins 

        #li{class= <<"el-menu-item">>, body=[
            #i{class= <<"iconfont icon-changjingguanli">>},
            #panel{class= <<"el-badge menu-dot">>, body= <<"Модулі"/utf8>>} %
        ]}, % /plugins 


        #li{class= <<"el-submenu">>, body=[
            #panel{class= <<"el-submenu__title">>, body=[
                #i{class= <<"iconfont icon-gongju1">>}, %
                #panel{class= <<"el-badge menu-dot">>, body= <<"Інструменти"/utf8>>}, %
                #i{class= <<"el-submenu__icon-arrow">>}
            ]},
            #list{class= <<"el-menu el-menu--inline">>, body=[
                #li{class= <<"el-menu-item">>,body=[
                    #panel{class= <<"el-badge submenu-dot">>, body= <<"Websocket"/utf8>>} % /websocket
                ]},
                #li{class= <<"el-menu-item">>,body=[
                    #panel{class= <<"el-badge submenu-dot">>, body= <<"HTTP APi"/utf8>>} %/ http_api
                ]}
            ]}
        ]},

        #li{class= <<"el-menu-item">>, body=[
            #i{class= <<"iconfont icon-icon_shezhi">>},
            #panel{class= <<"el-badge menu-dot">>, body= <<"Налаштування"/utf8>>} %
        ]}, % /plugins

        #li{class= <<"el-submenu">>, body=[
            #panel{class= <<"el-submenu__title">>, body=[
                #i{class= <<"iconfont icon-fenzuguanli">>},
                #panel{class= <<"el-badge menu-dot">>, body= <<"Загальне"/utf8>>}, %
                #i{class= <<"el-submenu__icon-arrow">>}
            ]},
            #list{class= <<"el-menu el-menu--inline">>, body=[
                #li{class= <<"el-menu-item">>,body=[
                    #panel{class= <<"el-badge submenu-dot">>, body= <<"програми"/utf8>>} % /applications
                ]},
                #li{class= <<"el-menu-item">>,body=[
                    #panel{class= <<"el-badge submenu-dot">>, body= <<"користувачі"/utf8>>} %/ users
                ]},
                #li{class= <<"el-menu-item">>,body=[
                    #panel{class= <<"el-badge submenu-dot">>, body= <<"слухачі"/utf8>>} %/ listeners
                ]},
                #li{class= <<"el-menu-item">>,body=[
                    #panel{class= <<"el-badge submenu-dot">>, body= <<"допомога"/utf8>>} %/ help
                ]}
            ]}
        ]}
    ]},
    #panel{class= <<"bar-footer">>, body=[
        #span{body=n2o:user()},
        #link{body=[#image{src= <<"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAABsklEQVRoQ+2ZwVHDMBBF/6oB6IBwCRxNJeCkAdGBXQl0gCggASrB3DC5OBVgrjlkGTOByciJbEcyyIxytbTat/9LlrOEgf9o4PkjAPy1gjsVOH+Qo/UaN0SIAIwcJ1kwIxMC6WusCtvYNYCv5BnPBBzbBjfNZ6AUhAtbiBrAeC4fCbjsM/nv2Aw8vU3Ulc1auwDe+67+VsJFPlGnTgHO5pK3A+YT5fSkch2/lpzrBfTquo4fALr6NyigVSxYKFjI8pj+dQt1VaxpfABoqlDX5+OZvFsJpEWsyjZzvVOgek8wkDHhehGrrAnCS4Aq6eq6zYx0MVXKBOEtwM+Vm6FMlrIG0K8GTZIf8txkqUEAmCw1HADGBwOJvicGAcDACxPkrlPJGuAQT5vm6HuKgfsVIdn3XvAWgPdYRof3EsBkGe8BxnOpTJbxHqDrnvLOQt4DhI/68FHf1aTa+GChYKFgIbd/39cbHDNZEuHIstDtpjOW+VRZ9eD+X4tp06HM+lahui4Lgch5k6/SftOpvCVGBMJJOz+0HMVYMiEThMQ2+WpFp/2vlghOhwUAp+U8INjgFfgEg1piQESWU5UAAAAASUVORK5CYII=">> }]}
    ]}
]}.

ws() -> #panel{class=card, body=[
    % on enter
    #h4{body= <<"з'єдняння"/utf8>>},
    #panel{class='card-row', body=[
        #panel{class=line, body=[
            #label{for=host, body= <<"адреса"/utf8>>},
            #input{id=host,  value= <<"localhost">>}
        ]},
        #panel{class=line, body=[
            #label{for=port, body= <<"порт"/utf8>>},
            #input{id=port,  value= <<"8083">>}
        ]},
        #panel{class=line, body=[
            #label{for=path, body= <<"канал"/utf8>>},
            #input{id=path,  value= <<"/mqtt">>}
        ]}
    ]},
    #panel{class='card-row', body=[
        #panel{class=line, body=[
            #label{body= <<"ідентифікатор клієнта"/utf8>>},
            #input{value= <<"">>}
        ]},
        #panel{class=line, body=[
            #label{body= <<"користувач"/utf8>>},
            #input{value= <<"">>}
        ]},
        #panel{class=line, body=[
            #label{body= <<"пароль"/utf8>>},
            #input{value= <<"">>}
        ]}
    ]},
    #br{},
    #panel{class='card-row', body=[
        #panel{class=line, body=[
            #label{body= <<"підтримувати зв'язок"/utf8>>},
            #input{value=60}
        ]}
    ]},
    #panel{class='card-row', body=[
        #panel{body=[
            #checkbox{body= <<"нова сесія"/utf8>>},
            #checkbox{body= <<"SSL">>},
            #label{body= "ws://localhost:8083/mqtt"}
        ]}
        
    ]},
    #br{},
    #panel{class='card-row', body=[
        #panel{class=line, body=[
            #button{body= <<"з'єднати"/utf8>>},
            #button{body= <<"від'єднати"/utf8>>},
            #label{body= <<"статус: "/utf8>>}
        ]}
    ]}
]}.

op() -> #panel{class=card, body=[
    % on enter
    #span{body= <<"підписка"/utf8>>},
    #panel{class='card-row', body=[
        #panel{body= [
            #label{body= <<"топік"/utf8>>},
            #input{value= <<"">>},
            #label{body= <<"QoS">>},
            #select{body=[
                #option{body=0},#option{body=1},#option{body=2}
            ]},
            #button{body= <<"підписатися"/utf8>>}
        ]},
        #panel{body=[
            #span{body= <<"підписки"/utf8>>},
            #panel{body=[
                #span{body= <<"топік"/utf8>>},
                #span{body= <<"QoS">>},
                #span{body= <<"час"/utf8>>},
                #span{body= <<"відписатися"/utf8>>}
            ]}
        ]}
    ]},
    #panel{class='card-row', body=[]},
    #panel{class='card-row', body=[]}
]}.

msg() -> #panel{class=card, body=[
    % on enter
    #span{body= <<"повідомлення"/utf8>>},
    #panel{class='card-row', body=[
        #label{body= <<"топік"/utf8>>},
        #input{value= <<"">>},
        #label{body= <<"повідомлення"/utf8>>},
        #input{value= <<"">>},
        #label{body= <<"QoS">>},
        #select{body=[
                #option{body=0},#option{body=1},#option{body=2}
        ]},
        #checkbox{body= <<"збережене"/utf8>>},
        #button{body= <<"надіслати"/utf8>>}
    ]},
    #panel{class='card-row', body=[
        #panel{body=[
            #span{body= <<"Щойно відправлені повідомлення"/utf8>>},
            #button{},
            #panel{body=[
                #span{body= <<"повідомлення"/utf8>>},
                #span{body= <<"топік"/utf8>>},
                #span{body= <<"QoS">>},
                #span{body= <<"час"/utf8>>}
            ]}
        ]},
        #panel{body=[
            #span{body= <<"отримані повідомлення"/utf8>>},
            #button{},
            #panel{body=[
                #span{body= <<"повідомлення"/utf8>>},
                #span{body= <<"топік"/utf8>>},
                #span{body= <<"QoS">>},
                #span{body= <<"час"/utf8>>}
            ]}
        ]}
    ]}
]}.
