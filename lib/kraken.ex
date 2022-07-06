defmodule Kraken do
  @moduledoc false

  alias Kraken.Customers
  alias Kraken.Customers.Customer
  alias Kraken.CustomerTransactions
  alias Kraken.CustomerTransactions.CustomerTransaction
  alias Kraken.CustomerlessTransactions
  alias Kraken.CustomerlessTransactions.CustomerlessTransaction
  alias Kraken.Repo
  alias Kraken.Report

  @transaction_files ["transactions-1.json", "transactions-2.json"]

  @valid_deposit_confirmations 6

  def go do
    Repo.delete_all(CustomerTransaction)
    Repo.delete_all(Customer)
    Repo.delete_all(CustomerlessTransaction)

    Customers.create("Wesley Crusher", "mvd6qFeVkqH6MNAS2Y2cLifbdaX5XUkbZJ")
    Customers.create("Leonard McCoy", "mmFFG4jqAtw9MoCC88hw5FNfreQWuEHADp")
    Customers.create("Jonathan Archer", "mzzg8fvHXydKs8j9D2a8t7KpSXpGgAnk4n")
    Customers.create("Jadzia Dax", "2N1SP7r92ZZJvYKG2oNtzPwYnzw62up7mTo")
    Customers.create("Montgomery Scott", "mutrAf4usv3HKNdpLwVD4ow2oLArL6Rez8")
    Customers.create("James T. Kirk", "miTHhiX3iFhVnAEecLjybxvV5g8mKYTtnM")
    Customers.create("Spock", "mvcyJMiAcSXKAEsQxbW9TYZ369rsMG6rVV")

    for file_name <- @transaction_files do
      %{"transactions" => transactions} = read_json_file(file_name)
      valid_transactions = select_valid_receive_transactions(transactions)
      customers = get_customer_ids_from_addresses(valid_transactions)
      customer_address_to_id = gather_customer_addresses(customers)

      %{
        customer_transactions: customer_transactions,
        customerless_transactions: customerless_transactions
      } = format_transactions(valid_transactions, customer_address_to_id)

      CustomerTransactions.create(customer_transactions)

      CustomerlessTransactions.create(customerless_transactions)
    end

    customer_transactions_report = Report.customer_transactions()
    customerless_transactions_report = Report.customerless_transactions()
    {max_deposit, min_deposit} = Report.max_and_min_deposit()

    customer_transactions_report
    |> prep_customer_transactions_for_printing()
    |> print_report(customerless_transactions_report, max_deposit, min_deposit)
  end

  defp prep_customer_transactions_for_printing(customer_transactions_report) do
    Enum.reduce(customer_transactions_report, %{}, fn x, acc ->
      Map.put(acc, x.name, Map.delete(x, :name))
    end)
  end

  defp print_report(
         customer_transactions_report,
         customerless_transactions_report,
         max_deposit,
         min_deposit
       ) do
    IO.puts("\n\n")

    IO.puts(
      "Deposited for Wesley Crusher: count=#{customer_transactions_report["Wesley Crusher"].count} sum=#{Float.round(customer_transactions_report["Wesley Crusher"].sum, 8)}"
    )

    IO.puts(
      "Deposited for Leonard McCoy: count=#{customer_transactions_report["Leonard McCoy"].count} sum=#{Float.round(customer_transactions_report["Leonard McCoy"].sum, 8)}"
    )

    IO.puts(
      "Deposited for Jonathan Archer: count=#{customer_transactions_report["Jonathan Archer"].count} sum=#{Float.round(customer_transactions_report["Jonathan Archer"].sum, 8)}"
    )

    IO.puts(
      "Deposited for Jadzia Dax: count=#{customer_transactions_report["Jadzia Dax"].count} sum=#{Float.round(customer_transactions_report["Jadzia Dax"].sum, 8)}"
    )

    IO.puts(
      "Deposited for Montgomery Scott: count=#{customer_transactions_report["Montgomery Scott"].count} sum=#{Float.round(customer_transactions_report["Montgomery Scott"].sum, 8)}"
    )

    IO.puts(
      "Deposited for James T. Kirk: count=#{customer_transactions_report["James T. Kirk"].count} sum=#{Float.round(customer_transactions_report["James T. Kirk"].sum, 8)}"
    )

    IO.puts(
      "Deposited for Spock: count=#{customer_transactions_report["Spock"].count} sum=#{Float.round(customer_transactions_report["Spock"].sum, 8)}"
    )

    IO.puts(
      "Deposited without reference: count=#{customerless_transactions_report.count} sum=#{Float.round(customerless_transactions_report.sum, 8)}"
    )

    IO.puts("Smallest valid deposit: #{Float.round(min_deposit, 8)}")

    IO.puts("Largest valid deposit: #{Float.round(max_deposit, 8)}")

    IO.puts("\n\n")
  end

  def format_transactions(valid_transactions, customer_address_to_id) do
    addresses = Map.keys(valid_transactions)

    Enum.reduce(
      addresses,
      %{customer_transactions: [], customerless_transactions: []},
      fn a,
         %{
           customer_transactions: customer_transactions,
           customerless_transactions: customerless_transactions
         } ->
        case Map.get(customer_address_to_id, a) do
          nil ->
            %{
              customer_transactions: customer_transactions,
              customerless_transactions:
                customerless_transactions ++ Map.get(valid_transactions, a)
            }

          customer_id ->
            %{
              customer_transactions:
                customer_transactions ++
                  add_customer_id(customer_id, Map.get(valid_transactions, a)),
              customerless_transactions: customerless_transactions
            }
        end
      end
    )
  end

  def select_valid_receive_transactions(transactions) do
    Enum.reduce(transactions, %{}, &select_valid_receive_transaction/2)
  end

  # The returned data will look like
  # %{
  #   "address 1" => [
  #     %{txid: "txid 1 here", amount: "amount 1 here", blockhash: "blockhash here", blockindex: 3, vout: 3},
  #     %{txid: "txid 2 here", amount: "amount 2 here", blockhash: "blockhash here", blockindex: 3, vout: 3}
  #   ],
  #   "address 2" => [
  #     %{txid: "txid 1 here", amount: "amount 1 here", blockhash: "blockhash here", blockindex: 3, vout: 3},
  #   ]
  # }
  defp select_valid_receive_transaction(
         %{
           "address" => address,
           "category" => "receive",
           "amount" => amount,
           "confirmations" => confirmations,
           "blockhash" => blockhash,
           "blockindex" => blockindex,
           "txid" => txid,
           "vout" => vout
         },
         acc
       )
       when confirmations >= @valid_deposit_confirmations do
    address_transactions = Map.get(acc, address, [])

    Map.put(
      acc,
      address,
      address_transactions ++
        [
          %{
            blockhash: blockhash,
            blockindex: blockindex,
            vout: vout,
            txid: txid,
            amount: amount + 0.0
          }
        ]
    )
  end

  defp select_valid_receive_transaction(_, acc), do: acc

  def get_customer_ids_from_addresses(valid_transactions) do
    valid_transactions
    |> Map.keys()
    |> Customers.get_by_addresses()
  end

  def gather_customer_addresses(customers) do
    Enum.reduce(customers, %{}, fn c, acc ->
      Map.put(acc, c.address, c.id)
    end)
  end

  def add_customer_id(customer_id, partial_customer_transactions) do
    Enum.map(partial_customer_transactions, fn ct ->
      Map.put(ct, :customer_id, customer_id)
    end)
  end

  def read_json_file(filename) do
    with {:ok, body} <- File.read(filename), do: Jason.decode!(body)
  end

  def some do
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

# defp process_transactions(transactions) do
#   Enum.each(transactions, fn t ->
#     process_transaction(t)
#   end)
# end

# defp process_transaction(%{
#        "address" => address,
#        "category" => "receive",
#        "amount" => amount,
#        "confirmations" => confirmations,
#        "txid" => txid
#      })
#      when confirmations >= @valid_deposit_confirmations do
#   address
#   |> Customers.get_by_address()
#   |> record_transaction(txid, amount)
# end

# defp process_transaction(_), do: :ok

# defp record_transaction(nil, txid, amount) do
#   with %CustomerlessTransaction{} <- CustomerlessTransactions.create(txid, amount) do
#     :ok
#   end
# end

# defp record_transaction(%Customer{id: customer_id}, txid, amount) do
#   with %CustomerTransaction{} <- CustomerTransactions.create(txid, amount, customer_id) do
#     :ok
#   end
# end
