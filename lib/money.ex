defmodule Monetized.Money do

  import Monetized.Money.Utils
  alias Monetized.Currency
  
  @moduledoc """
  
  Defines the money struct and functions to handle it.

  Although we're able to override any configuration when
  calling functions that create/handle money, it is possible
  to change any of the default values seen below, through config.

  ## Examples

      config :monetized, config: [
        delimiter: ",",
        separator: ".",
        currency: "USD",
        format: "%c %n%s%d"
      ]
  
  """

  @typedoc """
  
  A money struct containing the basic unit amount and 
  the currency key.

  """
  @type money :: %Monetized.Money{}
  
  defstruct currency: nil, units: nil
  
  @doc """
  
  Returns a string representation of the given money.
  
  ## Examples
  
      iex> money = Monetized.Money.make("£ 20150.25")
      ...> Monetized.Money.to_string(money, [show_currency: true])
      "£ 20,150.25"
      
      iex> money = Monetized.Money.make(999999999)
      ...> Monetized.Money.to_string(money, [delimiter: " ", separator: " "])
      "999 999 999 00"
      
      iex> money = Monetized.Money.make(100_000_000)
      ...> Monetized.Money.to_string(money, [format: "%n%s%d %c", show_currency: true])
      "100,000,000.00 $"
      
      iex> money = Monetized.Money.make(-9950, [currency: "USD", units: true])
      ...> Monetized.Money.to_string(money, [show_currency: true])
      "$ -99.50"
      
  """

  @spec to_string(money, list) :: String.t
  
  def to_string(money, options \\ []) do
    delimiter = option_or_config(config, options, :delimiter)
    separator = option_or_config(config, options, :separator)
    
    {base, decimal} = Integer.to_string(money.units) 
    |> String.split_at(-2)
    
    number = String.to_integer(base) 
    |> delimit_integer(delimiter) 
    |> String.Chars.to_string
    
    currency = if options[:show_currency] do 
      Currency.get(money.currency).symbol 
    else
      "" 
    end
    
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

  It uses the default currency ("USD") if one isn't
  configured.

  If a string is given with either the currency key/code 
  (ie "USD") or the symbol present, that currency will be
  assumed.

  Passing `currency` in the options will make it use that
  despite of configured, default or assumed from string.
  
  ## Examples

      iex> Monetized.Money.make("20150.25 EUR")
      %Monetized.Money{currency: "EUR", units: 2015025}
      
      iex> Monetized.Money.make(20150.25, [currency: "EUR"])
      %Monetized.Money{currency: "EUR", units: 2015025}
      
      iex> Monetized.Money.make(20150)
      %Monetized.Money{currency: "USD", units: 2015000}

      iex> Monetized.Money.make(-100.50)
      %Monetized.Money{currency: "USD", units: -10050}  
      
  """

  @spec make(integer | float | String.t, list) :: money
  
  def make(amount, options \\ []) do
    do_make(amount, options)
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

  It uses the default currency ("USD") if one isn't
  configured.

  Passing currency in the options will make it use that
  despite of configured or default.
  
  ## Examples

      iex> Monetized.Money.from_string("GBP 10.52")
      %Monetized.Money{currency: "GBP", units: 1052}
      
      iex> Monetized.Money.from_string("€ 100")
      %Monetized.Money{currency: "EUR", units: 10000}

      iex> Monetized.Money.from_string("100", [currency: "EUR"])
      %Monetized.Money{currency: "EUR", units: 10000}
      
      iex> Monetized.Money.from_string("$50")
      %Monetized.Money{currency: "USD", units: 5000}

  """

  @spec from_string(String.t, list) :: money
  
  def from_string(amount, options \\ []) when is_bitstring(amount) do
    cond do
      currency = Currency.parse(amount) ->
        currency_key = currency.key
        options = Dict.merge([currency: currency_key], options)
      true ->
        # NOOP!
    end

    if Regex.run(~r/\./, amount) != nil do
      options = Dict.merge([units: true], options)
    end

    Regex.run(~r/-?[0-9]{1,300}(,[0-9]{3})*(\.[0-9]+)?/, amount) 
    |> List.first 
    |> String.replace(~r/\./, "") 
    |> String.replace(~r/\,/, "")
    |> String.to_integer
    |> from_integer(options)
  end
  
  @doc """
  
  Creates a money struct from a integer value.

  It uses the default currency ("USD") if one isn't
  configured.

  Passing currency in the options will make it use that
  despite of configured or default.
  
  ## Examples

      iex> Monetized.Money.from_integer(152, [currency: "GBP"])
      %Monetized.Money{currency: "GBP", units: 15200}
      
      iex> Monetized.Money.from_integer(152, [currency: "GBP"])
      %Monetized.Money{currency: "GBP", units: 15200}
      
  """

  @spec from_integer(integer, list) :: money
  
  def from_integer(amount, options \\ []) when is_integer(amount) do
    create(amount, options)
  end
  
  @doc """
  
  Creates a money struct from a float value.

  It uses the default currency ("USD") if one isn't
  configured.

  Passing currency in the options will make it use that
  despite of configured or default.

  This function exists for convenience and despite it taking
  a float value, the internal calculations are done on 
  integers (basic units)

  ## Examples

      iex> Monetized.Money.from_float(100.00, [currency: "EUR"])
      %Monetized.Money{currency: "EUR", units: 10000}

      iex> Monetized.Money.from_float(150.52)
      %Monetized.Money{currency: "USD", units: 15052}
      
      iex> Monetized.Money.from_float(20.50)
      %Monetized.Money{currency: "USD", units: 2050}
      
  """

  @spec from_float(float, list) :: money
  
  def from_float(amount, options \\ []) when is_float(amount) do
    Float.to_string(amount, [decimals: 2])
    |> from_string(options)
  end
  
  defp create(amount, options) do
    currency_key = option_or_config(config, options, :currency)
    currency = Currency.get(currency_key)
    
    unless options[:units] do
      amount = amount * currency.to_unit
    end
    
    do_create(amount, currency_key)
  end
  
  defp do_create(amount, currency_key) do
    %Monetized.Money{currency: currency_key, units: amount}
  end
  
  defp config do
    defaults = [
      delimiter: ",",
      separator: ".",
      currency: "USD",
      format: "%c %n%s%d"
    ]

    Dict.merge(defaults, Application.get_env(:Monetized_money, :config, []))
  end
  
end
