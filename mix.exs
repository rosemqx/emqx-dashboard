defmodule Board.MixProject do
 use Mix.Project

 def project do
    [
      app: :emqx_dashboard,
      version: "0.1.0",
      description: "ERP.UNO MQ Dashboard",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      erlc_paths: ["src"],
      elixirc_options: [warnings_as_errors: true],
      deps: deps()
    ]
 end

 def application do
    [
      mod: {Board.App, []},
      extra_applications: [:logger],
      applications: [
        :jsone,
        :kvs,
        :syn,
        :ranch,
        :cowlib,
        :cowboy,
        :n2o,
        :nitro,
        :mnesia,
        :emqtt
      ]
    ]
 end

 def deps do
  [
    {:n2o,        github: "synrc/n2o",    ref: "master", override: true},
    {:nitro,      github: "synrc/nitro",  ref: "master", override: true},
    {:kvs,        github: "synrc/kvs",    ref: "master", override: true},
    {:emqtt,      github: "xio/emqtt",    ref: "master", override: true},
    {:frontend,   github: "erpuno/frontend", ref: "master", compile: false, app: false},
    {:jsone,      "~> 1.5.5", override: true},
    {:syn,        "~> 2.1.1", override: true},
    {:cowlib,     "~> 2.9.1", override: true},
    {:cowboy,     "~> 2.8.0", override: true},
    {:ranch,      "~> 1.7.1", override: true}
  ]
 end
end
