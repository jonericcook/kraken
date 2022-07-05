defmodule Kraken.Customers.Customer do
  @moduledoc false

  use Ecto.Schema

  schema "customers" do
    field(:name, :string)
    field(:address, :string)
    has_many(:customer_transactions, Kraken.CustomerTransactions.CustomerTransaction)
  end
end
