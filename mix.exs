defmodule Kraken.MixProject do
  use Mix.Project

  def project do
    [
      app: :kraken,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Kraken.Application, []}
    ]
  end

  defp aliases do
    [
      # Ensures database is reset before tests are run
      "ecto.reset": ["ecto.drop", "ecto.create", "ecto.migrate"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.2"},
      {:jason, "~> 1.3"},
      {:postgrex, "~> 0.15"}
    ]
  end
end
