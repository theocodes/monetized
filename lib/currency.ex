defmodule Monetized.Currency do
  @currencies [
    %{key: "ARS", name: "Argentinian Peso", symbol: "A$", type: "Fiat"},
    %{key: "CAD", name: "Canadian Dollar", symbol: "C$", type: "Fiat"},
    %{key: "EUR", name: "Euro", symbol: "€", type: "Fiat"},
    %{key: "GBP", name: "Pound Sterling", symbol: "£", type: "Fiat"},
    %{key: "HKD", name: "Hong Kong Dollar", symbol: "HK$", type: "Fiat"},
    %{key: "PHP", name: "Philippine Peso", symbol: "₱", type: "Fiat"},
    %{key: "THB", name: "Thai Baht", symbol: "฿", type: "Fiat"},
    %{key: "USD", name: "US Dollar", symbol: "$", type: "Fiat"},
    %{key: "BTC", name: "Bitcoin", symbol: "₿", type: "Crypto"},
    %{key: "ETH", name: "Ethereum", symbol: "Ξ", type: "Crypto"},
    %{key: "XRP", name: "Ripple", type: "Crypto"},
    %{key: "BCH", name: "Bitcoin Cash", type: "Crypto"},
    %{key: "LTC", name: "Litecoin", symbol: "Ł", type: "Crypto"},
    %{key: "ADA", name: "Cardano", type: "Crypto"},
    %{key: "NEO", name: "NEO", type: "Crypto"},
    %{key: "XLM", name: "Stellar", type: "Crypto"},
    %{key: "MIOTA", name: "IOTA", type: "Crypto"},
    %{key: "DASH", name: "Dash", type: "Crypto"},
    %{key: "XMR", name: "Monero", type: "Crypto"},
    %{key: "XEM", name: "NEM", type: "Crypto"},
    %{key: "ETC", name: "Ethereum Classic", type: "Crypto"},
    %{key: "LSK", name: "Lisk", type: "Crypto"},
    %{key: "QTUM", name: "Qtum", type: "Crypto"},
    %{key: "BTG", name: "Bitcoin Gold", type: "Crypto"},
    %{key: "ZEC", name: "Zcash", type: "Crypto"},
    %{key: "XVG", name: "Verge", type: "Crypto"},
    %{key: "NANO", name: "Nano", type: "Crypto"},
    %{key: "STEEM", name: "Steem", type: "Crypto"},
    %{key: "BCN", name: "Bytecoin", type: "Crypto"},
    %{key: "STRAT", name: "Stratis", type: "Crypto"},
    %{key: "SC", name: "Siacoin", type: "Crypto"},
    %{key: "WAVES", name: "Waves", type: "Crypto"},
    %{key: "DOGE", name: "Dogecoin", type: "Crypto"},
    %{key: "BTS", name: "BitShares", type: "Crypto"},
    %{key: "ZCL", name: "ZClassic", type: "Crypto"},
    %{key: "DCR", name: "Decred", type: "Crypto"},
    %{key: "HSR", name: "Hshare", type: "Crypto"},
    %{key: "ETN", name: "Electroneum", type: "Crypto"},
    %{key: "KMD", name: "Komodo", type: "Crypto"},
    %{key: "ARDR", name: "Ardor", type: "Crypto"},
    %{key: "ARK", name: "Ark", type: "Crypto"},
    %{key: "DGB", name: "DigiByte", type: "Crypto"},
    %{key: "GBYTE", name: "Byteball Bytes", type: "Crypto"},
    %{key: "SYS", name: "Syscoin", type: "Crypto"},
    %{key: "CNX", name: "Cryptonex", type: "Crypto"},
    %{key: "MONA", name: "MonaCoin", type: "Crypto"},
    %{key: "PIVX", name: "PIVX", type: "Crypto"},
    %{key: "BTX", name: "Bitcore", type: "Crypto"},
    %{key: "GXS", name: "GXShares", type: "Crypto"},
    %{key: "FCT", name: "Factom", type: "Crypto"},
    %{key: "XZC", name: "ZCoin", type: "Crypto"},
    %{key: "NXT", name: "Nxt", type: "Crypto"},
    %{key: "PART", name: "Particl", type: "Crypto"},
    %{key: "NEBL", name: "Neblio", type: "Crypto"},
    %{key: "RDD", name: "ReddCoin", type: "Crypto"},
    %{key: "EMC", name: "Emercoin", type: "Crypto"},
    %{key: "SMART", name: "SmartCash", type: "Crypto"},
    %{key: "VTC", name: "Vertcoin", type: "Crypto"},
    %{key: "GAME", name: "GameCredits", type: "Crypto"},
    %{key: "BLOCK", name: "Blocknet", type: "Crypto"},
    %{key: "XDN", name: "DigitalNote", type: "Crypto"},
    %{key: "XP", name: "Experience Points", type: "Crypto"},
    %{key: "BTCD", name: "BitcoinDark", type: "Crypto"},
    %{key: "ACT", name: "Achain", type: "Crypto"},
    %{key: "NXS", name: "Nexus", type: "Crypto"},
    %{key: "BCO", name: "BridgeCoin", type: "Crypto"},
    %{key: "SKY", name: "Skycoin", type: "Crypto"},
    %{key: "ZEN", name: "ZenCash", type: "Crypto"},
    %{key: "NAV", name: "NAV Coin", type: "Crypto"},
    %{key: "UBQ", name: "Ubiq", type: "Crypto"},
    %{key: "HTML", name: "HTMLCOIN", type: "Crypto"},
    %{key: "PPC", name: "Peercoin", type: "Crypto"},
    %{key: "XBY", name: "XTRABYTES", type: "Crypto"},
    %{key: "XAS", name: "Asch", type: "Crypto"},
    %{key: "EMC2", name: "Einsteinium", type: "Crypto"},
    %{key: "ETP", name: "Metaverse ETP", type: "Crypto"},
    %{key: "VIA", name: "Viacoin", type: "Crypto"},
    %{key: "PAC", name: "PACcoin", type: "Crypto"},
    %{key: "XCP", name: "Counterparty", type: "Crypto"},
    %{key: "PURA", name: "PURA", type: "Crypto"},
    %{key: "BAY", name: "BitBay", type: "Crypto"},
    %{key: "BUEST", name: "Burst", type: "Crypto"},
    %{key: "AEON", name: "Aeon", type: "Crypto"},
    %{key: "MNX", name: "MinexCoin", type: "Crypto"},
    %{key: "ECC", name: "ECC", type: "Crypto"},
    %{key: "NLG", name: "Gulden", type: "Crypto"},
    %{key: "LBC", name: "LBRY Credit", type: "Crypto"},
    %{key: "CRW", name: "Crown", type: "Crypto"},
    %{key: "SLS", name: "SaluS", type: "Crypto"},
    %{key: "CLOAK", name: "CloakCoin", type: "Crypto"},
    %{key: "ION", name: "ION", type: "Crypto"},
    %{key: "RISE", name: "Rise", type: "Crypto"},
    %{key: "THC", name: "HempCoin", type: "Crypto"},
    %{key: "GRS", name: "Groestlcoin", type: "Crypto"},
    %{key: "SBD", name: "Steem Dollars", type: "Crypto"},
    %{key: "FTC", name: "Feathercoin", type: "Crypto"},
    %{key: "COLX", name: "ColossusCoinXT", type: "Crypto"},
    %{key: "ONION", name: "DeepOnion", type: "Crypto"},
    %{key: "DCT", name: "DECENT", type: "Crypto"},
    %{key: "NMC", name: "Namecoin", type: "Crypto"},
    %{key: "DIME", name: "Dimecoin", type: "Crypto"},
    %{key: "LKK", name: "Lykke", type: "Crypto"},
    %{key: "SIB", name: "SIBCoin", type: "Crypto"},
    %{key: "DMD", name: "Diamond", type: "Crypto"},
    %{key: "IOC", name: "I/O Coin", type: "Crypto"},
    %{key: "POT", name: "PotCoin", type: "Crypto"},
    %{key: "XWC", name: "WhiteCoin", type: "Crypto"},
    %{key: "ECA", name: "Electra", type: "Crypto"}
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
  |> Enum.filter(&Map.has_key?(&1, :symbol))
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
