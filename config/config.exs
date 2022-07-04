import Config

config :kraken, Kraken.Repo,
  database: "kraken_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :kraken,
  ecto_repos: [Kraken.Repo]
