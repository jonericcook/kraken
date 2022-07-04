defmodule Kraken.Customers.Customer do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "customers" do
    field(:name, :string)
    field(:address, :string)
    has_many(:customer_transactions, Kraken.CustomerTransactions.CustomerTransaction)

    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:name, :address])
    |> validate_required([:name, :address])
  end
end
