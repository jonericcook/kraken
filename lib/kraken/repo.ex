defmodule Kraken.Repo do
  use Ecto.Repo,
    otp_app: :kraken,
    adapter: Ecto.Adapters.Postgres
end
