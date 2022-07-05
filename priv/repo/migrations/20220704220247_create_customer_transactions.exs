defmodule Kraken.Repo.Migrations.CreateCustomerTransactions do
  use Ecto.Migration

  def change do
    create table(:customer_transactions) do
      add :txid, :string
      add :amount, :float
      add :customer_id, references(:customers)
      timestamps()
    end
  end
end
