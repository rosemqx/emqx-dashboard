-module(index).
-compile(export_all).
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/n2o.hrl").
-include_lib("kvs/include/kvs.hrl").

-export([event/1]).

% pi
event(init) ->
    n2o:reg(n2o:sid()),
    nitro:insert_top(app, nav());
event(E) ->
    case lists:keyfind(E, 1, path()) of
        {Pb,Path} ->
            nitro:wire(#jq{target={qs, <<".left-bar .active">>}, property=<<"classList">>, method=["toggle"], args=["'active'"]}),
            nitro:wire(#jq{target=Pb, property="classList", method=["toggle"], args=["'active'"]}),
            nitro:wire(nitro:f("qi('app').__vue__.$router.push({path: '~s'});", [Path]));
        false ->
            nitro:wire("qi('app').__vue__.$router.push({path: '/'});")
    end.

nav() -> #nav{class= <<"left-bar">>, body=[
    #panel{class= <<"bar-title">>, body=[
        #image{class=logo, src="/app/mq.svg"},
        #h3{body= <<"Панель керування"/utf8>>}
    ]},
    #link{id=overview, body= <<"Огляд"/utf8>>, postback=overview},
    #link{id=clients, body= <<"Клієнти"/utf8>>, postback=clients},
    #link{id=topics,  body= <<"Теми"/utf8>>,    postback=topics},
    #link{id=subscriptions, body= <<"Підписки"/utf8>>,postback=subscriptions},
    #link{id=rules,   body= <<"Правила"/utf8>>, postback=rules},
    #link{id=resources,body= <<"Ресурси"/utf8>>, postback=resources},
    #link{id=analytics,body= <<"Аналітика"/utf8>>,postback=analytics},
    #link{id=metrics, body= <<"Метрики"/utf8>>, postback=metrics},
    #link{id=plugins, body= <<"Плагіни"/utf8>>, postback=plugins},
    #link{id=modules, body= <<"Модулі"/utf8>>, postback=modules},
    #link{id=instruments, body= <<"Інструменти"/utf8>>, postback=instruments},
    #link{id=websocket, body= <<"Websocket"/utf8>>, postback=websocket},
    #link{id=http, body= <<"HTTP APi"/utf8>>, postback=http},
    #link{id=settings, body= <<"Налаштування"/utf8>>, postback=settings},
    #link{id=general, body= <<"Загальне"/utf8>>, postback=general},
    #link{id=applications, body= <<"програми"/utf8>>, postback=applications},
    #link{id=users, body= <<"користувачі"/utf8>>, postback=users},
    #link{id=listeners, body= <<"слухачі"/utf8>>, postback=listeners},
    #link{id=help, body= <<"допомога"/utf8>>, postback=help},

    #panel{class= <<"bar-footer">>, body=[
        #span{body=n2o:user()},
        #link{body=[#image{src= <<"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAABsklEQVRoQ+2ZwVHDMBBF/6oB6IBwCRxNJeCkAdGBXQl0gCggASrB3DC5OBVgrjlkGTOByciJbEcyyIxytbTat/9LlrOEgf9o4PkjAPy1gjsVOH+Qo/UaN0SIAIwcJ1kwIxMC6WusCtvYNYCv5BnPBBzbBjfNZ6AUhAtbiBrAeC4fCbjsM/nv2Aw8vU3Ulc1auwDe+67+VsJFPlGnTgHO5pK3A+YT5fSkch2/lpzrBfTquo4fALr6NyigVSxYKFjI8pj+dQt1VaxpfABoqlDX5+OZvFsJpEWsyjZzvVOgek8wkDHhehGrrAnCS4Aq6eq6zYx0MVXKBOEtwM+Vm6FMlrIG0K8GTZIf8txkqUEAmCw1HADGBwOJvicGAcDACxPkrlPJGuAQT5vm6HuKgfsVIdn3XvAWgPdYRof3EsBkGe8BxnOpTJbxHqDrnvLOQt4DhI/68FHf1aTa+GChYKFgIbd/39cbHDNZEuHIstDtpjOW+VRZ9eD+X4tp06HM+lahui4Lgch5k6/SftOpvCVGBMJJOz+0HMVYMiEThMQ2+WpFp/2vlghOhwUAp+U8INjgFfgEg1piQESWU5UAAAAASUVORK5CYII=">> }]}
    ]}
]}.

path() -> [
    {overview,"/"}, {clients,"/clients"}, {topics,"/topics"},
    {subscriptions,"/subscriptions"}, {rules,"/rules"}, {resources,"/resources"},
    {analytics,"/analytics"}, {metrics,"/topic_metrics"},
    {plugins,"/plugins"}, {modules,"/modules"}, {listeners,"/listeners"},
    {websocket,"/websocket"}, {http,"/http_api"}, {applications,"/applications"},
    {settings,"/settings"}, {users,"/users"},  {help,"/help"}].

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
