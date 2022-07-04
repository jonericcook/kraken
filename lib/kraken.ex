defmodule Kraken do
  @moduledoc false

  alias Kraken.Customers
  @transaction_files ["transactions-1.json", "transactions-2.json"]
  def go do
    {:ok, one} = get_json(Enum.at(@transaction_files, 0))
    {:ok, two} = get_json(Enum.at(@transaction_files, 1))
    all_txs = one["transactions"] ++ two["transactions"]

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
    all_txids =
      Enum.reduce(all_txs, [], fn x, acc ->
        acc ++ [x["txid"]]
      end)

    IO.inspect(Enum.count(all_txids), label: "all tx ids count")
    IO.inspect(Enum.dedup(all_txids) |> Enum.count(), label: "dedup tx ids")
  end

  def get_json(filename) do
    with {:ok, body} <- File.read(filename), {:ok, json} <- Jason.decode(body), do: {:ok, json}
  end
end
