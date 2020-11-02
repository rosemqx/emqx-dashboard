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

-export([start/2 ,stop/1, init/1]).

% app/sup
init(_Args) ->
    % Admin = #{id => emqx_dashboard_admin,
    %         start => {emqx_dashboard_admin, start_link, []},
    %         restart => permanent,
    %         shutdown => 5000,
    %         type => worker,
    %         modules => [emqx_dashboard_admin]},

    Dispatch = cowboy_router:compile([{'_', [
        { "/n2o/[...]",     cowboy_static,  { dir, "deps/n2o/priv", mime() }},
        { "/nitro/[...]",   cowboy_static,  { dir, "deps/nitro/priv/js", mime() }},
        { "/app/[...]",     cowboy_static,  { dir, "priv/static", mime() }}
        ]% ++ minirest:handlers([{"/api/v4/[...]", minirest, http_handlers()}])
    }]),

    Opts = #{
        connection_type => worker,
        handshake_timeout => 10000,
        max_connections => 1000,
        num_acceptors => 100,
        shutdown => 5000,
        socket_opts => [{port, application:get_env(n2o, port, 18083)}]
    },
    Spec = ranch:child_spec('http:board', ranch_tcp, Opts, cowboy_clear, #{env => #{dispatch => Dispatch}}),

    {ok, { {one_for_one, 10, 100}, [Spec] }}.

start(_StartType, _StartArgs) ->
    kvs:join(),
    n2o:start_mqtt(),
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

stop(_State) ->
    ranch:stop_listener('http:board').

mime()   -> [ { mimetypes, cow_mimetypes, all } ].
