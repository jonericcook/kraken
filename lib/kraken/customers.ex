defmodule Kraken.Customers do
  alias Kraken.Customers.Customer
  alias Kraken.Repo

  def create(name, address) do
    Repo.insert!(%Customer{name: name, address: address})
  end

  def get_by_address(address) do
    Repo.get_by(Customer, address: address)
  end
end
