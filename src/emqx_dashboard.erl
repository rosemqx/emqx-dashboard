%%--------------------------------------------------------------------
%% Copyright (c) 2020 EMQ Technologies Co., Ltd. All Rights Reserved.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%--------------------------------------------------------------------

-module(emqx_dashboard).
-behaviour(application).
-behaviour(supervisor).

-include_lib("emqx/include/emqx.hrl").
-include_lib("emqx/include/logger.hrl").

-import(proplists, [get_value/3]).

-export([ start/2
        , stop/1
        , init/1
        ]).

init(_Args) ->
    Spec = #{id => emqx_dashboard_admin,
            start => {emqx_dashboard_admin, start_link, []},
            restart => permanent,
            shutdown => 5000,
            type => worker,
            modules => [emqx_dashboard_admin]},
    {ok, { {one_for_all, 10, 100}, [Spec] } }.

start(_StartType, _StartArgs) ->
    ok = ekka_mnesia:start(),
    lists:foreach(fun(Listener) -> start_listener(Listener) end, listeners()),
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

stop(_State) ->
    ekka_mnesia:stop(),
    lists:foreach(fun(Listener) -> stop_listener(Listener) end, listeners()).

%%--------------------------------------------------------------------
%% Start/Stop listeners.
%%--------------------------------------------------------------------

%% Start HTTP Listener
start_listener({Proto, Port, Options}) when Proto == http ->
    Dispatch = [{"/", cowboy_static, {file, "priv/www/index.html", []}},
                {"/static/[...]", cowboy_static, {dir, "priv/www/static", [{mimetypes, cow_mimetypes, all}]}},
                {"/api/v4/[...]", minirest, http_handlers()}],
    minirest:start_http(listener_name(Proto), ranch_opts(Port, Options), Dispatch);

start_listener({Proto, Port, Options}) when Proto == https ->
    Dispatch = [{"/", cowboy_static, {priv_file, emqx_dashboard, "www/index.html"}},
                {"/static/[...]", cowboy_static, {priv_dir, emqx_dashboard, "www/static"}},
                {"/api/v4/[...]", minirest, http_handlers()}],
    minirest:start_https(listener_name(Proto), ranch_opts(Port, Options), Dispatch).

ranch_opts(Port, Options0) ->
    NumAcceptors = get_value(num_acceptors, Options0, 4),
    MaxConnections = get_value(max_connections, Options0, 512),
    Options = lists:foldl(fun({K, _V}, Acc) when K =:= max_connections orelse K =:= num_acceptors ->
                              Acc;
                             ({inet6, true}, Acc) -> [inet6 | Acc];
                             ({inet6, false}, Acc) -> Acc;
                             ({ipv6_v6only, true}, Acc) -> [{ipv6_v6only, true} | Acc];
                             ({ipv6_v6only, false}, Acc) -> Acc;
                             ({K, V}, Acc)->
                              [{K, V} | Acc]
                          end, [], Options0),
    #{num_acceptors => NumAcceptors,
      max_connections => MaxConnections,
      socket_opts => [{port, Port} | Options]}.

stop_listener({Proto, _Port, _}) ->
    minirest:stop_http(listener_name(Proto)).

listeners() ->
    application:get_env(?MODULE, listeners, []).

listener_name(Proto) ->
    list_to_atom(atom_to_list(Proto) ++ ":dashboard").

%%--------------------------------------------------------------------
%% HTTP Handlers and Dispatcher
%%--------------------------------------------------------------------

http_handlers() ->
    Plugins = lists:map(fun(Plugin) -> Plugin#plugin.name end, emqx_plugins:list()),
    Cfg = #{apps => Plugins, modules => [], filter => fun filter/1, except => undefined},
    Hnd = minirest_handler:init(Cfg),
    [{"/api/v4/", Hnd,[{authorization, fun is_authorized/1}]}].

%%--------------------------------------------------------------------
%% Basic Authorization
%%--------------------------------------------------------------------

is_authorized(Req) ->
    is_authorized(binary_to_list(cowboy_req:path(Req)), Req).

is_authorized("/api/v4/auth", _Req) ->
    true;
is_authorized(_Path, Req) ->
    case cowboy_req:parse_header(<<"authorization">>, Req) of
        {basic, Username, Password} ->
            case emqx_dashboard_admin:check(iolist_to_binary(Username),
                                            iolist_to_binary(Password)) of
                ok -> true;
                {error, Reason} ->
                    ?LOG(error, "[Dashboard] Authorization Failure: username=~s, reason=~p",
                                [Username, Reason]),
                    false
            end;
         _  -> false
    end.
