defmodule Kraken.CustomerTransactions do
  import Ecto.Query

  alias Kraken.Repo
  alias Kraken.CustomerTransactions.CustomerTransaction

  def create(txid, amount, customer_id) do
    Repo.insert!(%CustomerTransaction{txid: txid, amount: amount, customer_id: customer_id})
  end

  def get_all_by_customer_id(customer_id) do
    from(ct in CustomerTransaction, where: ct.customer_id == ^customer_id)
    |> Repo.all()
  end
end
