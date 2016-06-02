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

  @type t :: %__MODULE__{
    value: Decimal.t,
    currency: String.t,
  }

  defstruct value: Decimal.new("0.00"), currency: nil

  @behaviour Ecto.Type

  @doc """

  The Ecto primitive type.

  """

  def type, do: :string

  @doc """

  Casts the given value to money.

  It supports:

    * A string (if currency not relevant).
    * A float (if currency not relevant).
    * An `Decimal` struct (if currency not relevant).
    * An integer (if currency not relevant).
    * A map with `:value` and `:currency` keys.
    * A map with "value" and "currency" keys.
    * An `Monetized.Money` struct.

  """

  def cast(%Monetized.Money{} = money) do
    {:ok, money}
  end

  def cast(%{"value" => v, "currency" => c}) do
    {:ok, Monetized.Money.make(v, [currency: c])}
  end

  def cast(%{value: v, currency: c}) do
    {:ok, Monetized.Money.make(v, [currency: c])}
  end

  def cast(value) when is_bitstring(value) do
    {:ok, Monetized.Money.from_string(value)}
  end

  def cast(value) when is_float(value) do
    {:ok, Monetized.Money.from_float(value)}
  end

  def cast(value) when is_integer(value) do
    {:ok, Monetized.Money.from_integer(value)}
  end

  def cast(%Decimal{} = value) do
    {:ok, Monetized.Money.from_decimal(value)}
  end

  def cast(_), do: :error

  @doc """

  Converts an `Monetized.Money` into a string for
  saving to the db. ie: "100.50 EUR"

  """

  def dump(%Monetized.Money{} = money) do
    {:ok, Monetized.Money.to_string(money, [currency_code: true])}
  end

  def dump(_), do: :error

  @doc """

  Converts a string as saved to the db into a
  `Monetized.Money` struct.

  """

  def load(m) when is_bitstring(m) do
    {:ok, Monetized.Money.make(m)}
  end

  def load(_), do: :error

  @doc """

  Returns a string representation of the given money.

  ## Examples

      iex> money = Monetized.Money.make("£ 20150.25")
      ...> Monetized.Money.to_string(money, [currency_symbol: true])
      "£ 20,150.25"

      # Ignores currency as there isn't one
      iex> money = Monetized.Money.make(999999999)
      ...> Monetized.Money.to_string(money, [delimiter: " ", separator: " ", currency_symbol: true])
      "999 999 999 00"

      iex> money = Monetized.Money.make(100_000_000, [currency: "USD"])
      ...> Monetized.Money.to_string(money, [format: "%n%s%d %cs", currency_symbol: true])
      "100,000,000.00 $"

      iex> money = Monetized.Money.make(-99.50, [currency: "USD"])
      ...> Monetized.Money.to_string(money, [currency_symbol: true])
      "$ -99.50"

      iex> money = Monetized.Money.make("100.50 EUR")
      ...> Monetized.Money.to_string(money, [currency_code: true])
      "100.50 EUR"

      iex> money = Monetized.Money.make(Decimal.new("10"))
      ...> Monetized.Money.to_string(money)
      "10.00"
  """

  @spec to_string(t, list) :: String.t

  def to_string(%Monetized.Money{} = money, options \\ []) do
    delimiter = option_or_config(config, options, :delimiter)
    separator = option_or_config(config, options, :separator)

    value_as_string = Decimal.to_string(money.value)
    value = if String.contains?(value_as_string, "."), do: value_as_string, else: value_as_string <> ".00"
    [base, decimal] = Regex.split(~r/\./, value)

    number = String.to_integer(base)
    |> delimit_integer(delimiter)
    |> String.Chars.to_string

    cs = if options[:currency_symbol] && money.currency,
      do: Currency.get(money.currency).symbol,
    else: ""

    cc = if options[:currency_code] && money.currency,
    do: Currency.get(money.currency).key,
    else: ""

    option_or_config(config, options, :format)
    |> String.replace(~r/%cs/, cs)
    |> String.replace(~r/%n/, number)
    |> String.replace(~r/%s/, separator)
    |> String.replace(~r/%d/, decimal)
    |> String.replace(~r/%cc/, cc)
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

  @spec make(integer | float | String.t | Decimal, list) :: t

  def make(amount, options \\ []) do
    do_make(amount, options)
  end

  defp do_make(%Decimal{} = value, options) do
    from_decimal(value, options)
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

      iex> Monetized.Money.from_string("200", currency: "THB")
      #Money<200.00THB>

  """

  @spec from_string(String.t, list) :: t

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
      #
      iex> Monetized.Money.from_integer(-100, [currency: "GBP"])
      #Money<-100.00GBP>

  """

  @spec from_integer(integer, list) :: t

  def from_integer(amount, options \\ []) when is_integer(amount) do
    currency_key = option_or_config(config, options, :currency)
    do_from_integer(amount, currency_key)
  end

  defp do_from_integer(amount, currency_key) when amount >= 0 do
    %Decimal{
      coef: amount * 100,
      sign: 1,
      exp: -2,
    }
    |> create(currency_key)
  end

  defp do_from_integer(amount, currency_key) do
    %Decimal{
      coef: -(amount * 100),
      sign: -1,
      exp: -2,
    }
    |> create(currency_key)
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

  @spec from_float(float, list) :: t

  def from_float(amount, options \\ []) when is_float(amount) do
    currency_key = option_or_config(config, options, :currency)

    amount
    |> Float.to_string([decimals: 2])
    |> Decimal.new
    |> create(currency_key)
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

  @spec from_decimal(Decimal, list) :: t

  def from_decimal(value = %Decimal{}, options \\ []) do
    currency_key = option_or_config(config, options, :currency)
    do_from_decimal(value, currency_key)
  end

  defp do_from_decimal(value = %Decimal{exp: -2}, currency_key) do
    value
    |> create(currency_key)
  end

  defp do_from_decimal(value, currency_key) do
    str = Decimal.to_string(value)
    Regex.replace(~r/\.(\d)$/, str, ".\\g{1}0")
    |> Decimal.new
    |> create(currency_key)
  end

  @doc """

  Creates a money struct with 0 value.

  Useful for setting a default value of "0.00".

  ## Examples

      iex> Monetized.Money.zero
      #Money<0.00>

      iex> Monetized.Money.zero([currency: "GBP"])
      #Money<0.00GBP>

  """

  def zero(options \\ []) do
    from_integer(0, options)
  end

  defp create(value, currency_key) do
    %Monetized.Money{value: value, currency: currency_key}
  end

  defp config do
    defaults = [
      delimiter: ",",
      separator: ".",
      format: "%cs %n%s%d %cc"
    ]

    Dict.merge(defaults, Application.get_env(:monetized, :config, []))
  end

  defimpl Inspect, for: Monetized.Money do
    def inspect(dec, _opts) do
      if dec.currency do
        "#Money<" <> Decimal.to_string(dec.value) <> dec.currency <> ">"
      else
        "#Money<" <> Decimal.to_string(dec.value) <> ">"
      end
    end
  end

end
