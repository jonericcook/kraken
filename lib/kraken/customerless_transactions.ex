defmodule Kraken.CustomerlessTransactions do
  # import Ecto.Query

  alias Kraken.Repo
  alias Kraken.CustomerlessTransactions.CustomerlessTransaction

  def create(customerless_transactions) do
    Repo.insert_all(CustomerlessTransaction, customerless_transactions)
  end

  def get_all() do
    Repo.all(CustomerlessTransaction)
  end
end
