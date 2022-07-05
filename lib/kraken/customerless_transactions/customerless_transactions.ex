defmodule Kraken.CustomerlessTransactions.CustomerlessTransaction do
  @moduledoc false

  use Ecto.Schema

  schema "customerless_transactions" do
    field(:txid, :string)
    field(:amount, :float)

    timestamps()
  end
end
