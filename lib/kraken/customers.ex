defmodule Kraken.Customers do
  import Ecto.Query

  alias Kraken.Customers.Customer
  alias Kraken.Repo

  def create(name, address) do
    Repo.insert!(%Customer{name: name, address: address})
  end

  def get_by_addresses(addresses) do
    from(c in Customer, where: c.address in ^addresses, select: %{id: c.id, address: c.address})
    |> Repo.all()
  end

  def get_customers() do
    from(c in Customer, select: %{id: c.id, name: c.name})
    |> Repo.all()
  end
end
