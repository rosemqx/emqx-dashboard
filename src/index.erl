-module(index).
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/n2o.hrl").
-include_lib("kvs/include/kvs.hrl").

-export([event/1]).

% pi
event(init) ->
    n2o:reg(n2o:sid()),
    io:format("init"),
    nitro:update(sail, #button{id=sail, body= <<"hello, sailor!">>, postback=sail});

event(sail) -> 
    io:format("sail~n"),
    nitro:update(sail, #button{id=sail, body= <<"done!">>, postback=sail});
event(E)    -> io:format("not handled event ~p.~n", [E]).
