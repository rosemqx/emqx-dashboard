defmodule Board.App do
    use Application
    use Supervisor
    require KVS
    require Logger

    def mime(), do: [{:mimetypes, :cow_mimetypes, :all}]
    def points(), do: :cowboy_router.compile([
      {:_,
       [
         {'/',            :cowboy_static, {:file,"priv/static/index.html", mime()}},
         {'/ws/[...]',    :n2o_cowboy, []},
         {'/n2o/[...]',   :cowboy_static, {:dir, "deps/n2o/priv", mime()}},
         {'/nitro/[...]', :cowboy_static, {:dir, "deps/nitro/priv/js", mime()}},
         {'/[...]',       :cowboy_static, {:dir, "priv/static", mime()}}
       ]}
    ])

    def env(),  do: %{env: %{dispatch: points()}}
    def opts(), do: %{connection_type: :worker,
                     handshake_timeout: 10000,
                     max_connections: 1000,
                     num_acceptors: 100,
                     shutdown: 5000,
                     socket: :undefined,
                     socket_opts: [
                      {:port, :application.get_env(:n2o, :port, 18083)}
                    ]}
    def spec(), do: :ranch.child_spec(:hoho, :ranch_tcp, opts(), :cowboy_clear, env())

    @impl true
    def init([]) do
      Supervisor.init([spec()], strategy: :one_for_one)
    end

    @impl true
    def start(_,arg) do
      :kvs.join()
      Logger.info("start ws")
      :n2o.start_ws()
      Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
    end

    @impl true
    def stop(_) do
      :kvs.leave()
      :ranch.stop_listener(:hoho)
    end
end
