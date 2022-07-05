defmodule Kraken.CustomerTransactions do
  import Ecto.Query

  alias Kraken.Repo
  alias Kraken.CustomerTransactions.CustomerTransaction

  def create(customer_transactions) do
    Repo.insert_all(CustomerTransaction, customer_transactions)
  end

  def get_all_by_customer_id(customer_id) do
    from(ct in CustomerTransaction, where: ct.customer_id == ^customer_id)
    |> Repo.all()
  end
end
