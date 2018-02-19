defmodule Monetized.Currency do
  @currencies [
    %{name: "Argentinian Peso", symbol: "A$", key: "ARS", type: "Fiat"},
    %{name: "Canadian Dollar", symbol: "C$", key: "CAD", type: "Fiat"},
    %{name: "Euro", symbol: "€", key: "EUR", type: "Fiat"},
    %{name: "Pound Sterling", symbol: "£", key: "GBP", type: "Fiat"},
    %{name: "Hong Kong Dollar", symbol: "HK$", key: "HKD", type: "Fiat"},
    %{name: "Philippine Peso", symbol: "₱", key: "PHP", type: "Fiat"},
    %{name: "Thai Baht", symbol: "฿", key: "THB", type: "Fiat"},
    %{name: "US Dollar", symbol: "$", key: "USD", type: "Fiat"},
    %{name: "Bitcoin", symbol: "₿", key: "BTC", type: "Crypto"},
    %{name: "Ethereum", symbol: "Ξ", key: "ETH", type: "Crypto"},
    %{name: "Litecoin", symbol: "Ł", key: "LTC", type: "Crypto"}
  ]

  @currency_map Enum.reduce(@currencies, %{}, fn currency, acc ->
                  Map.put(acc, currency.key, currency)
                end)

  @moduledoc """

  Defines available currencies and functions to handle them.

  """

  @doc """

  Attempts to parse the currency from the given string
  based on both the currency key and the symbol.

  ## Examples

      iex> Monetized.Currency.parse("EUR 200.00")
      %{name: "Euro", symbol: "€", key: "EUR", type: "Fiat"}

      iex> Monetized.Currency.parse("£ 200.00")
      %{name: "Pound Sterling", symbol: "£", key: "GBP", type: "Fiat"}

      iex> Monetized.Currency.parse("200.00 USD")
      %{name: "US Dollar", symbol: "$", key: "USD", type: "Fiat"}

      iex> Monetized.Currency.parse("200.00 THB")
      %{name: "Thai Baht", symbol: "฿", key: "THB", type: "Fiat"}

      iex> Monetized.Currency.parse("200.00 PHP")
      %{key: "PHP", name: "Philippine Peso", symbol: "₱", type: "Fiat"}

      iex> Monetized.Currency.parse("₿ 200.00")
      %{key: "BTC", name: "Bitcoin", symbol: "₿", type: "Crypto"}

      iex> Monetized.Currency.parse("200.00 BTC")
      %{key: "BTC", name: "Bitcoin", symbol: "₿", type: "Crypto"}

  """

  def parse(str) do
    parse_by_symbol(str) || parse_by_key(str)
  end

  @doc """

  Attempts to parse the currency from the given string
  based on the currency key.

  ## Examples

      iex> Monetized.Currency.parse_by_key("EUR 200.00")
      %{name: "Euro", symbol: "€", key: "EUR", type: "Fiat"}

      iex> Monetized.Currency.parse_by_key("200.00 USD")
      %{name: "US Dollar", symbol: "$", key: "USD", type: "Fiat"}

      iex> Monetized.Currency.parse_by_key("200.00 GBP")
      %{name: "Pound Sterling", symbol: "£", key: "GBP", type: "Fiat"}

      iex> Monetized.Currency.parse_by_key("200.00 THB")
      %{name: "Thai Baht", symbol: "฿", key: "THB", type: "Fiat"}

      iex> Monetized.Currency.parse_by_key("200.00 PHP")
      %{key: "PHP", name: "Philippine Peso", symbol: "₱", type: "Fiat"}

      iex> Monetized.Currency.parse_by_key("200.00 ARS")
      %{key: "ARS", name: "Argentinian Peso", symbol: "A$", type: "Fiat"}

      iex> Monetized.Currency.parse_by_key("200.00 BTC")
      %{key: "BTC", name: "Bitcoin", symbol: "₿", type: "Crypto"}

  """

  def parse_by_key(str) do
    piped = Enum.join(keys(), "|")

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
      %{name: "Euro", symbol: "€", key: "EUR", type: "Fiat"}

      iex> Monetized.Currency.parse_by_symbol("$200.00")
      %{name: "US Dollar", symbol: "$", key: "USD", type: "Fiat"}

      iex> Monetized.Currency.parse_by_symbol("£200.00")
      %{name: "Pound Sterling", symbol: "£", key: "GBP", type: "Fiat"}

      iex> Monetized.Currency.parse_by_symbol("฿200.00")
      %{name: "Thai Baht", symbol: "฿", key: "THB", type: "Fiat"}

      iex> Monetized.Currency.parse_by_symbol("₱200.00")
      %{key: "PHP", name: "Philippine Peso", symbol: "₱", type: "Fiat"}

      iex> Monetized.Currency.parse_by_symbol("₿200.00")
      %{key: "BTC", name: "Bitcoin", symbol: "₿", type: "Crypto"}

  """

  @currencies
  |> Enum.map(&Map.to_list/1)
  |> Enum.each(fn currency ->
    def parse_by_symbol(unquote(Keyword.get(currency, :symbol)) <> _rest),
      do: Enum.into(unquote(currency), %{})
  end)

  def parse_by_symbol(_), do: nil

  @doc """

  Retrieves the currency struct for the given key.

  ## Examples

      iex> Monetized.Currency.get("EUR")
      %{name: "Euro", symbol: "€", key: "EUR", type: "Fiat"}

      iex> Monetized.Currency.get("THB")
      %{name: "Thai Baht", symbol: "฿", key: "THB", type: "Fiat"}

      iex> Monetized.Currency.get("PHP")
      %{key: "PHP", name: "Philippine Peso", symbol: "₱", type: "Fiat"}

      iex> Monetized.Currency.get("BTC")
      %{key: "BTC", name: "Bitcoin", symbol: "₿", type: "Crypto"}

  """

  @spec get(String.t()) :: struct

  def get(key), do: all()[key]

  @doc """

  Retrieves a struct holding all the currency options.

  """

  @spec all() :: %{bitstring() => %{name: bitstring(), symbol: bitstring(), key: bitstring()}}

  def all, do: @currency_map

  @doc """

  Retrieves a list of currency options keys

  """

  @spec keys :: list

  def keys, do: Map.keys(all())
end
