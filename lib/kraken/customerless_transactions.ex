defmodule Kraken.CustomerlessTransactions do
  import Ecto.Query

  alias Kraken.Repo
  alias Kraken.CustomerlessTransactions.CustomerlessTransaction

  def maybe_create(params) do
    if !exists?(params) do
      Repo.insert(%CustomerlessTransaction{
        blockhash: params.blockhash,
        blockindex: params.blockindex,
        txid: params.txid,
        vout: params.vout,
        amount: params.amount
      })
    end
  end

  def exists?(params) do
    from(ct in CustomerlessTransaction,
      where:
        ct.blockhash == ^params.blockhash and ct.blockindex == ^params.blockindex and
          ct.txid == ^params.txid and ct.vout == ^params.vout and ct.amount == ^params.amount
    )
    |> Repo.exists?()
  end

  def get_all() do
    Repo.all(CustomerlessTransaction)
  end
end
