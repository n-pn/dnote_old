use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dnote, DnoteWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :dnote, Dnote.Repo,
  username: "postgres",
  password: "postgres",
  database: "dnote_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Shorten hashing time
config :pbkdf2_elixir, :rounds, 1
