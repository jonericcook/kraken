defmodule Kraken.CustomerTransactions.CustomerTransaction do
  @moduledoc false

  use Ecto.Schema

  # https://bitcoin.stackexchange.com/questions/75300/what-would-happened-if-two-transactions-have-the-same-hash

  schema "customer_transactions" do
    field(:blockhash, :string)
    field(:blockindex, :integer)
    field(:txid, :string)
    field(:vout, :integer)
    field(:amount, :float)
    field(:customer_id, :integer)
  end
end
