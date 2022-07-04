defmodule Kraken.Customers do
  # import Ecto.Query
  alias Kraken.Customers.Customer
  alias Kraken.Repo

  def create_customer(attrs) do
    %Customer{}
    |> Customer.changeset(attrs)
    |> Repo.insert()
  end

  def get_by_address(address) do
    Repo.get_by(Customer, address: address)
  end
end
