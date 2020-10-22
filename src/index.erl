-module(index).
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/n2o.hrl").
-include_lib("kvs/include/kvs.hrl").

-export([event/1]).

% pi
event(init) ->
    n2o:reg(n2o:sid()),
    
    nitro:update(sail, #panel{body=[
        #input{id=in1},
        #button{id=sail, body= <<"hello, sailor!">>, source=[in1], postback= sail}
    ]});

event(sail) -> 
    nitro:update(sail, #button{id=sail, body= <<"done!">>, postback=sail});
event(E)    -> io:format("not handled event ~p.~n", [E]).
