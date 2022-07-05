defmodule Kraken.CustomerlessTransactions do
  import Ecto.Query

  alias Kraken.Repo
  alias Kraken.CustomerlessTransactions.CustomerlessTransaction

  def create(txid, amount) do
    Repo.insert!(%CustomerlessTransaction{txid: txid, amount: amount})
  end

  def get_all() do
    Repo.all(CustomerlessTransaction)
  end
end
