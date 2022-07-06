defmodule Kraken.CustomerTransactions do
  import Ecto.Query

  alias Kraken.Repo
  alias Kraken.CustomerTransactions.CustomerTransaction

  def maybe_create(params) do
    if !exists?(params) do
      Repo.insert(%CustomerTransaction{
        blockhash: params.blockhash,
        blockindex: params.blockindex,
        txid: params.txid,
        vout: params.vout,
        amount: params.amount,
        customer_id: params.customer_id
      })
    end
  end

  def exists?(params) do
    from(ct in CustomerTransaction,
      where:
        ct.blockhash == ^params.blockhash and ct.blockindex == ^params.blockindex and
          ct.txid == ^params.txid and ct.vout == ^params.vout and ct.amount == ^params.amount
    )
    |> Repo.exists?()
  end

  def get_all_by_customer_id(customer_id) do
    from(ct in CustomerTransaction, where: ct.customer_id == ^customer_id)
    |> Repo.all()
  end
end
