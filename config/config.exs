import Config

config :kvs,
  dba: :kvs_mnesia,
  dba_st: :kvs_stream,
  schema: [:kvs, :kvs_stream]

config :n2o,
  app: :emqx_dashboard,
  port: 18083,
  mq: :n2o_syn,
  pickler: :n2o_secret,
  session: :n2o_session,
  tables: [:caching, :cookies, :tcp, :ws, :async],
  protocols: [:nitro_n2o, :n2o_heart],
  mqtt_services: [],
  tcp_services: [],
  routes: Board.Routes

config :logger,
  backends: [:console],
  level: :debug,
  handle_otp_reports: true
