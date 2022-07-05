defmodule Kraken.Repo.Migrations.CreateCustomerlessTransactions do
  use Ecto.Migration

  def change do
    create table(:customerless_transactions) do
      add :txid, :string
      add :amount, :float
      timestamps()
    end
  end
end
