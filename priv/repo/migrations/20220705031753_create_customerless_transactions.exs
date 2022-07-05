defmodule Kraken.Repo.Migrations.CreateCustomerlessTransactions do
  use Ecto.Migration

  # https://bitcoin.stackexchange.com/questions/75300/what-would-happened-if-two-transactions-have-the-same-hash
  def change do
    create table(:customerless_transactions) do
      add :blockhash, :string
      add :blockindex, :integer
      add :txid, :string
      add :vout, :integer
      add :amount, :float
    end
  end
end
