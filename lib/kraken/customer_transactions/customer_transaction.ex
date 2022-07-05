defmodule Kraken.CustomerTransactions.CustomerTransaction do
  @moduledoc false

  use Ecto.Schema

  schema "customer_transactions" do
    field(:txid, :string)
    field(:amount, :float)
    field(:customer_id, :integer)

    timestamps()
  end
end
