-module(index).
-compile(export_all).
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/n2o.hrl").
-include_lib("kvs/include/kvs.hrl").

-export([event/1]).

% pi
event(init) ->
    n2o:reg(n2o:sid()),
    nitro:update(nav, nav());

event(E) ->
    case lists:keyfind(E, 1, path()) of
        {Pb,Path} ->
            nitro:wire(#jq{target={ps, {qs, ".left-bar .active"}, "classList"}, method=["toggle"], args=["'active'"]}),
            nitro:wire(#jq{target={ps, Pb, "classList"}, method=["toggle"], args=["'active'"]}),
            nitro:wire(#jq{target={ps, app, "__vue__.$router"}, method=["push"], args=[nitro:f("{path: '~s'}", [Path])]});
        false ->
            nitro:wire(#jq{target={ps, app, "__vue__.$router"}, method=["push"], args=["{path:'/'}"]})
    end.

switch() -> 
    Base = nitro:f("sessionStorage.setItem('base', JSON.stringify({host: '~s', proto: '~s', mgmt_port: ~p, ws_port: ~p}));", [
        inet:ntoa(application:get_env(n2o, mqtt_host, {172,16,117,4})),
        application:get_env(n2o, mqtt_mgmt_proto, "http"),
        application:get_env(n2o, mqtt_mgmt_port, 8080),
        application:get_env(n2o, mqtt_ws_port, 8083)]),

    nitro:wire(Base).

nav() -> #nav{id=nav, class= <<"left-bar">>, body=[
    #panel{class= <<"bar-title">>, body=[
        #image{class=logo, src="/app/mq.svg"},
        #h3{body= <<"Панель керування"/utf8>>}
    ]},
    #link{id=overview,      body= <<"Огляд"/utf8>>,     postback=overview},
    #link{id=clients,       body= <<"Клієнти"/utf8>>,   postback=clients},
    #link{id=topics,        body= <<"Теми"/utf8>>,      postback=topics},
    #link{id=subscriptions, body= <<"Підписки"/utf8>>,  postback=subscriptions},
    #link{id=listeners,     body= <<"Cлухачі"/utf8>>,   postback=listeners},
    #link{id=websocket,     body= <<"Websocket"/utf8>>, postback=websocket},
    #link{id=http,          body= <<"HTTP APi"/utf8>>,  postback=http},
    #link{id=settings,      body= <<"Налаштування"/utf8>>, postback=settings},
    #link{id=users,         body= <<"Користувачі"/utf8>>, postback=users},

    #panel{class= <<"bar-footer">>, body=[
        #span{body=n2o:user()},
        #link{body= <<"вихід"/utf8>>}
    ]}
]}.

path() -> [
    {overview,"/"}, {clients,"/clients"}, {topics,"/topics"},
    {subscriptions,"/subscriptions"}, {listeners,"/listeners"},
    {websocket,"/websocket"}, {http,"/http_api"},
    {settings,"/settings"}, {users,"/users"} ].

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
