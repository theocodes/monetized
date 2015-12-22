defmodule Monetized.Currency do
  
  @moduledoc """
  
  Defines available currencies and functions to handle them.
  
  """

  @doc """
  
  Attempts to parse the currency from the given string
  based on both the currency key and the symbol.
  
  ## Examples

      iex> Monetized.Currency.parse("EUR 200.00")
      %{name: "Euro", symbol: "€", to_unit: 100, key: "EUR"}

      iex> Monetized.Currency.parse("£ 200.00")
      %{name: "Pound Sterling", symbol: "£", to_unit: 100, key: "GBP"}

      iex> Monetized.Currency.parse("200.00 $")
      %{name: "US Dollar", symbol: "$", to_unit: 100, key: "USD"}

  """

  def parse(str) do
    cond do
      cur = parse_by_symbol(str) ->
        cur
      cur = parse_by_key(str) ->
        cur
      true ->
        nil
    end
  end

  @doc """
  
  Attempts to parse the currency from the given string
  based on the currency key.
  
  ## Examples

      iex> Monetized.Currency.parse_by_key("EUR 200.00")
      %{name: "Euro", symbol: "€", to_unit: 100, key: "EUR"}

      iex> Monetized.Currency.parse_by_key("200.00 USD")
      %{name: "US Dollar", symbol: "$", to_unit: 100, key: "USD"}

      iex> Monetized.Currency.parse_by_key("200.00 GBP")
      %{name: "Pound Sterling", symbol: "£", to_unit: 100, key: "GBP"}

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
      %{name: "Euro", symbol: "€", to_unit: 100, key: "EUR"}

      iex> Monetized.Currency.parse_by_symbol("200.00 $")
      %{name: "US Dollar", symbol: "$", to_unit: 100, key: "USD"}

      iex> Monetized.Currency.parse_by_symbol("£200.00")
      %{name: "Pound Sterling", symbol: "£", to_unit: 100, key: "GBP"}

  """

  def parse_by_symbol(str) do
    x = Enum.map(all, fn {k, v} -> {v.symbol, k} end)
    case Regex.run(~r/\p{Sc}/u, str) do
      [s] ->
        get(x[s])
      _ ->
        nil
    end
  end

  defp keys do
    Map.keys all
  end
  
  def get(key) do
    all[key]
  end
  
  def all do
    %{
      "EUR" => %{name: "Euro", symbol: "€", to_unit: 100, key: "EUR"},
      "GBP" => %{name: "Pound Sterling", symbol: "£", to_unit: 100, key: "GBP"},
      "USD" => %{name: "US Dollar", symbol: "$", to_unit: 100, key: "USD"}
    }
  end
  
end
