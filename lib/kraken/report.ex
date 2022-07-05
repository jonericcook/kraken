defmodule Kraken.Report do
  import Ecto.Query

  alias Kraken.Repo
  alias Kraken.Customers.Customer
  alias Kraken.CustomerTransactions.CustomerTransaction
  alias Kraken.CustomerlessTransactions.CustomerlessTransaction

  def customer_transactions() do
    from(ct in CustomerTransaction,
      join: c in Customer,
      on: c.id == ct.customer_id,
      group_by: [c.name, :customer_id],
      select: %{sum: sum(ct.amount), count: count(), name: c.name}
    )
    |> Repo.all()
  end

  def customerless_transactions() do
    from(ct in CustomerlessTransaction,
      select: %{sum: sum(ct.amount), count: count()}
    )
    |> Repo.one()
  end

  def max_and_min_deposit() do
    {max_customer_transactions_deposit, min_customer_transactions_deposit} =
      from(ct in CustomerTransaction,
        select: {max(ct.amount), min(ct.amount)}
      )
      |> Repo.one()

    {max_customerless_transactions_deposit, min_customerless_transactions_deposit} =
      from(ct in CustomerlessTransaction,
        select: {max(ct.amount), min(ct.amount)}
      )
      |> Repo.one()

    max =
      if max_customer_transactions_deposit >= max_customerless_transactions_deposit do
        max_customer_transactions_deposit
      else
        max_customerless_transactions_deposit
      end

    min =
      if min_customer_transactions_deposit <= min_customerless_transactions_deposit do
        min_customer_transactions_deposit
      else
        min_customerless_transactions_deposit
      end

    {max, min}
  end
end
