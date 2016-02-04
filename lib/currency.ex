defmodule Monetized.Currency do

  @moduledoc """

  Defines available currencies and functions to handle them.

  """

  @doc """

  Attempts to parse the currency from the given string
  based on both the currency key and the symbol.

  ## Examples

      iex> Monetized.Currency.parse("EUR 200.00")
      %{name: "Euro", symbol: "€", key: "EUR"}

      iex> Monetized.Currency.parse("£ 200.00")
      %{name: "Pound Sterling", symbol: "£", key: "GBP"}

      iex> Monetized.Currency.parse("200.00 $")
      %{name: "US Dollar", symbol: "$", key: "USD"}

  """

  def parse(str) do
    parse_by_symbol(str) || parse_by_key(str)
  end

  @doc """

  Attempts to parse the currency from the given string
  based on the currency key.

  ## Examples

      iex> Monetized.Currency.parse_by_key("EUR 200.00")
      %{name: "Euro", symbol: "€", key: "EUR"}

      iex> Monetized.Currency.parse_by_key("200.00 USD")
      %{name: "US Dollar", symbol: "$", key: "USD"}

      iex> Monetized.Currency.parse_by_key("200.00 GBP")
      %{name: "Pound Sterling", symbol: "£", key: "GBP"}

  """

  def parse_by_key(str) do
    piped = Enum.join(keys, "|")
    case Regex.scan(~r/#{piped}/, str) do
      [[a]] ->
        get(a)
      _ ->
        nil
    end
  end

  @doc """

  Attempts to guess the currency from the given string
  based on the currency symbol.

  ## Examples

      iex> Monetized.Currency.parse_by_symbol("€ 200.00")
      %{name: "Euro", symbol: "€", key: "EUR"}

      iex> Monetized.Currency.parse_by_symbol("200.00 $")
      %{name: "US Dollar", symbol: "$", key: "USD"}

      iex> Monetized.Currency.parse_by_symbol("£200.00")
      %{name: "Pound Sterling", symbol: "£", key: "GBP"}

  """

  def parse_by_symbol(str) do
    x = Enum.map(all, fn {k, v} -> {v.symbol, k} end) |> Enum.into(%{})
    case Regex.run(~r/\p{Sc}/u, str) do
      [s] ->
        get(x[s])
      _ ->
        nil
    end
  end

  @doc """

  Retrieves the currency struct for the given key.

  ## Examples

      iex> Monetized.Currency.get("EUR")
      %{name: "Euro", symbol: "€", key: "EUR"}

  """

  @spec get(String.t) :: struct

  def get(key), do: all[key]

  @doc """

  Retrieves a struct holding all the currency options.

  """

  @spec all :: struct

  def all do
    %{
      "EUR" => %{name: "Euro", symbol: "€", key: "EUR"},
      "GBP" => %{name: "Pound Sterling", symbol: "£", key: "GBP"},
      "USD" => %{name: "US Dollar", symbol: "$", key: "USD"}
    }
  end

  @doc """

  Retrieves a list of currency options keys

  """

  @spec keys :: list

  def keys, do: Map.keys(all)

end
