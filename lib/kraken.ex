defmodule Kraken do
  @moduledoc false

  alias Kraken.Customers
  alias Kraken.Customers.Customer
  alias Kraken.CustomerTransactions
  alias Kraken.CustomerTransactions.CustomerTransaction
  alias Kraken.CustomerlessTransactions
  alias Kraken.CustomerlessTransactions.CustomerlessTransaction

  @transaction_files ["transactions-1.json", "transactions-2.json"]

  @valid_deposit_confirmations 6

  def go do
    for file_name <- @transaction_files do
      with {:ok, json} <- read_json_file(file_name),
           :ok <- process_transactions(json) do
        # gather data
        # print results
      end
    end
  end

  defp process_transactions(transactions) do
    Enum.each(transactions, fn t ->
      process_transaction(t)
    end)
  end

  defp process_transaction(%{
         "address" => address,
         "category" => "receive",
         "amount" => amount,
         "confirmations" => confirmations,
         "txid" => txid
       })
       when confirmations >= @valid_deposit_confirmations do
    address
    |> Customers.get_by_address()
    |> record_transaction(txid, amount)
  end

  defp process_transaction(_), do: :ok

  defp record_transaction(nil, txid, amount) do
    with %CustomerlessTransaction{} <- CustomerlessTransactions.create(txid, amount) do
      :ok
    end
  end

  defp record_transaction(%Customer{id: customer_id}, txid, amount) do
    with %CustomerTransaction{} <- CustomerTransactions.create(txid, amount, customer_id) do
      :ok
    end
  end

  defp read_json_file(filename) do
    with {:ok, body} <- File.read(filename), {:ok, json} <- Jason.decode(body), do: {:ok, json}
  end
end

# one = read_json_file(Enum.at(@transaction_files, 0))
# two = read_json_file(Enum.at(@transaction_files, 1))
# all_txs = one["transactions"] ++ two["transactions"]

# Enum.each(all_txs, fn %{"amount" => amount} ->
#   IO.inspect(amount)
# end)
# IO.inspect(Enum.count(all_txs), label: "al txs")

# Enum.each(all_txs, fn %{"address" => address, "category" => category} ->
#   if category == "send" do
#     IO.inspect(Customers.get_by_address(address), label: "SEND")
#   end

#   if category == "generate" do
#     IO.inspect(Customers.get_by_address(address), label: "GENERATE")
#   end

#   if category == "immature" do
#     IO.inspect(Customers.get_by_address(address), label: "IMMATURE")
#   end

#   if category == "orphan" do
#     IO.inspect(Customers.get_by_address(address), label: "ORPHAN")
#   end
# end)
# all_txids =
#   Enum.reduce(all_txs, [], fn x, acc ->
#     acc ++ [x["txid"]]
#   end)

# IO.inspect(Enum.count(all_txids), label: "all tx ids count")
# IO.inspect(Enum.dedup(all_txids) |> Enum.count(), label: "dedup tx ids")
