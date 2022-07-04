defmodule Kraken.CustomerTransactions.CustomerTransaction do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "customer_transactions" do
    field(:transaction_hash, :string)
    field(:amount, :float)
    belongs_to(:customers, Kraken.Customers.Customer)

    timestamps()
  end

  @doc false
  def changeset(customer_transaction, attrs) do
    customer_transaction
    |> cast(attrs, [:transaction_hash, :amount, :customer_id])
    |> validate_required([:transaction_hash, :amount, :customer_id])
  end
end
