-module(index).
-compile(export_all).
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/n2o.hrl").
-include_lib("kvs/include/kvs.hrl").

-export([event/1]).

% pi
event(init) ->
    n2o:reg(n2o:sid()),
    nitro:insert_top(app, ws()),
    nitro:update(sail, #panel{body=[
        #input{id=in1},
        #button{id=sail, body= <<"hello, sailor!">>, source=[in1], postback= sail}
    ]});

event(sail) -> 
    nitro:update(sail, #button{id=sail, body= <<"done!">>, postback=sail});
event(E)    -> io:format("not handled event ~p.~n", [E]).

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
