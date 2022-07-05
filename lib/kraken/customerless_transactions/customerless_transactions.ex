defmodule Kraken.CustomerlessTransactions.CustomerlessTransaction do
  @moduledoc false

  use Ecto.Schema

  # https://bitcoin.stackexchange.com/questions/75300/what-would-happened-if-two-transactions-have-the-same-hash

  schema "customerless_transactions" do
    field(:blockhash, :string)
    field(:blockindex, :integer)
    field(:txid, :string)
    field(:vout, :integer)
    field(:amount, :float)
  end
end
