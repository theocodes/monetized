defmodule Monetized.Money do

  import Monetized.Money.Utils
  alias Monetized.Currency

  @moduledoc """

  Defines the money struct and functions to handle it.

  Also defines `Money` Ecto.Type.

  Although we're able to override any configuration when
  calling functions that create/handle money, it is possible
  to change any of the default values seen below, through config.

  Below are the configuration options.

  ## Examples

      config :monetized, config: [
        delimiter: ",",
        separator: ".",
        currency: "USD",
        format: "%c %n%s%d"
      ]

  """

  @typedoc """

  A money struct containing the a Decimal tha holds the amount
  and the currency.

  """

  @type money :: %Monetized.Money{}

  defstruct decimal: Decimal.new("0.00"), currency: nil

  @behaviour Ecto.Type

  def type, do: :money

  def cast(%Monetized.Money{} = money) do
    {:ok, money}
  end

  def cast(%{"amount" => a, "currency" => c}) do
    {:ok, Monetized.Money.make(a, [currency: c])}
  end

  def cast(%{amount: a, currency: c}) do
    {:ok, Monetized.Money.make(a, [currency: c])}
  end

  def cast(amount) when is_bitstring(amount) do
    {:ok, Monetized.Money.from_string(amount)}
  end

  def cast(amount) when is_float(amount) do
    {:ok, Monetized.Money.from_float(amount)}
  end

  def cast(amount) when is_integer(amount) do
    {:ok, Monetized.Money.from_integer(amount)}
  end

  def cast(%Decimal{} = amount) do
    {:ok, Monetized.Money.from_decimal(amount)}
  end

  def cast(_), do: :error

  def dump(%Monetized.Money{decimal: d, currency: c}) do
    {:ok, %{"decimal" => d, "currency" => c}}
  end

  def dump(_), do: :error

  def load(%{"decimal" => d, "currency" => c}) do
    {:ok, %Monetized.Money{decimal: d, currency: c}}
  end

  def load(_), do: :error

  @doc """

  Returns a string representation of the given money.

  ## Examples

    iex> money = Monetized.Money.make("£ 20150.25")
    ...> Monetized.Money.to_string(money, [show_currency: true])
    "£ 20,150.25"

    # Ignores currency as there isn't one
    iex> money = Monetized.Money.make(999999999)
    ...> Monetized.Money.to_string(money, [delimiter: " ", separator: " ", show_currency: true])
    "999 999 999 00"

    iex> money = Monetized.Money.make(100_000_000, [currency: "USD"])
    ...> Monetized.Money.to_string(money, [format: "%n%s%d %c", show_currency: true])
    "100,000,000.00 $"

    iex> money = Monetized.Money.make(-99.50, [currency: "USD"])
    ...> Monetized.Money.to_string(money, [show_currency: true])
    "$ -99.50"

  """

  @spec to_string(money, list) :: String.t

  def to_string(%Monetized.Money{} = money, options \\ []) do
    delimiter = option_or_config(config, options, :delimiter)
    separator = option_or_config(config, options, :separator)

    [base, decimal] = Regex.split(~r/\./, Decimal.to_string(money.decimal))

    number = String.to_integer(base)
    |> delimit_integer(delimiter)
    |> String.Chars.to_string

    currency = if options[:show_currency] && money.currency,
      do: Currency.get(money.currency).symbol,
    else: ""

    option_or_config(config, options, :format)
    |> String.replace(~r/%c/, currency)
    |> String.replace(~r/%n/, number)
    |> String.replace(~r/%s/, separator)
    |> String.replace(~r/%d/, decimal)
    |> String.strip
  end

  @doc """

  Creates a money struct from any of the supported
  types for amount.

  If a string is given with either the currency key/code
  (ie "USD") or the symbol present, that currency will be
  assumed.

  Passing `currency` in the options will make it use that
  despite of configured, or assumed from string.

  ## Examples

    iex> Monetized.Money.make("20150.25 EUR")
    #Money<20150.25EUR>

    iex> Monetized.Money.make(20150.25, [currency: "EUR"])
    #Money<20150.25EUR>

    iex> Decimal.new("100.50") |> Monetized.Money.make
    #Money<100.50>

    iex> Monetized.Money.make("£ 100")
    #Money<100.00GBP>

    # currency in options takes precedence
    iex> Monetized.Money.make("€ 50", [currency: "USD"])
    #Money<50.00USD>

  """

  @spec make(integer | float | String.t | Decimal, list) :: money

  def make(amount, options \\ []) do
    do_make(amount, options)
  end

  defp do_make(%Decimal{} = decimal, options) do
    from_decimal(decimal, options)
  end

  defp do_make(amount, options) when is_bitstring(amount) do
    from_string(amount, options)
  end

  defp do_make(amount, options) when is_integer(amount) do
    from_integer(amount, options)
  end

  defp do_make(amount, options) when is_float(amount) do
    from_float(amount, options)
  end

  @doc """

  Creates a money struct from a string value.

  Passing currency in the options will make it use that
  despite of configured default.

  ## Examples

    iex> Monetized.Money.from_string("GBP 10.52")
    #Money<10.52GBP>

    iex> Monetized.Money.from_string("€ 100")
    #Money<100.00EUR>

    iex> Monetized.Money.from_string("100.00", [currency: "EUR"])
    #Money<100.00EUR>

    iex> Monetized.Money.from_string("$50")
    #Money<50.00USD>

    iex> Monetized.Money.from_string("1,000,000 EUR")
    #Money<1000000.00EUR>

  """

  @spec from_string(String.t, list) :: money

  def from_string(amount, options \\ []) when is_bitstring(amount) do
    if currency = Currency.parse(amount) do
      options = Dict.merge([currency: currency.key], options)
    end

    amount = Regex.run(~r/-?[0-9]{1,300}(,[0-9]{3})*(\.[0-9]+)?/, amount)
    |> List.first
    |> String.replace(~r/\,/, "")

    if Regex.run(~r/\./, amount) == nil do
      amount = Enum.join([amount, ".00"])
    end

    amount
    |> Decimal.new
    |> from_decimal(options)
  end

  @doc """

  Creates a money struct from a integer value.

  Passing currency in the options will make it use that
  despite of configured default.

  ## Examples

    iex> Monetized.Money.from_integer(152, [currency: "GBP"])
    #Money<152.00GBP>

    iex> Monetized.Money.from_integer(100_000, [currency: "GBP"])
    #Money<100000.00GBP>

  """

  @spec from_integer(integer, list) :: money

  def from_integer(amount, options \\ []) when is_integer(amount) do
    amount
    |> Integer.to_string
    |> from_string(options)
  end

  @doc """

  Creates a money struct from a float value.

  Passing currency in the options will make it use that
  despite of configured default.

  ## Examples

    iex> Monetized.Money.from_float(100.00, [currency: "EUR"])
    #Money<100.00EUR>

    iex> Monetized.Money.from_float(150.52)
    #Money<150.52>

    # iex> Monetized.Money.from_float(20.50)
    #Money<20.50>

  """

  @spec from_float(float, list) :: money

  def from_float(amount, options \\ []) when is_float(amount) do
    amount
    |> Float.to_string([decimals: 2])
    |> from_string(options)
  end

  @doc """

  Creates a money struct from a Decimal.

  It uses the default currency ("USD") if one isn't
  configured.

  Passing currency in the options will make it use that
  despite of configured default.

  ## Examples

    iex> Decimal.new(100.00) |> Monetized.Money.from_decimal([currency: "EUR"])
    #Money<100.00EUR>

    iex> Decimal.new(150.52) |> Monetized.Money.from_decimal
    #Money<150.52>

    iex> Decimal.new("300.25") |> Monetized.Money.from_decimal
    #Money<300.25>

  """

  @spec from_decimal(Decimal, list) :: money

  def from_decimal(amount, options \\ []) do
    currency_key = option_or_config(config, options, :currency)

    str = Decimal.to_string(amount)
    Regex.replace(~r/\.(\d)$/, str, ".\\g{1}0")
    |> Decimal.new
    |> create(currency_key)
  end

  defp create(amount, currency_key) do
    %Monetized.Money{currency: currency_key, decimal: amount}
  end

  defp config do
    defaults = [
      delimiter: ",",
      separator: ".",
      format: "%c %n%s%d"
    ]

    Dict.merge(defaults, Application.get_env(:monetized, :config, []))
  end

  defimpl Inspect, for: Monetized.Money do
    def inspect(dec, _opts) do
      if dec.currency do
        "#Money<" <> Decimal.to_string(dec.decimal) <> dec.currency <> ">"
      else
        "#Money<" <> Decimal.to_string(dec.decimal) <> ">"
      end
    end
  end

end
