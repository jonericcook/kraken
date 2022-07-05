defmodule Kraken.Repo.Migrations.CreateCustomerTransactions do
  use Ecto.Migration

  # https://bitcoin.stackexchange.com/questions/75300/what-would-happened-if-two-transactions-have-the-same-hash
  def change do
    create table(:customer_transactions) do
      add :blockhash, :string
      add :blockindex, :integer
      add :txid, :string
      add :vout, :integer
      add :amount, :float
      add :customer_id, references(:customers)
    end
  end
end
