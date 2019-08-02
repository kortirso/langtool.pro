use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :langtool_pro, LangtoolProWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :langtool_pro, LangtoolPro.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "kortirso",
  password: "",
  database: "langtool_pro_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
