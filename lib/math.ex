defmodule Monetized.Math do
  alias Monetized.Money
  alias Decimal

  @moduledoc """

  This module defines arithmetical operations on money.

  All functions in this module take either money structs as
  parameters from which the currency for the result is inferred or
  if you don't care for the currency, any of the `Monetized.Money.make/2`
  supported values.

  A error will be raised if the money structs hold distinct non nil
  values.

  """

  @doc """

  Adds two values and returns a money struct with
  the result.

  ## Examples

      iex> value_one = Monetized.Money.make(10)
      ...> value_two = Monetized.Money.make(20.50)
      ...> Monetized.Math.add(value_one, value_two)
      #Money<30.50>

      iex> five_euros = Monetized.Money.make("€ 5")
      ...> result = Monetized.Math.add(five_euros, 20)
      ...> Monetized.Money.to_string(result, [currency_symbol: true])
      "€ 25.00"

      iex> Monetized.Math.add("£ 100", "£ 1,350.25")
      #Money<1450.25GBP>

  """

  @spec add(
          Money.t() | String.t() | integer | float | Decimal,
          Money.t() | String.t() | integer | float | Decimal
        ) :: Money.t()

  def add(a, b) do
    a = to_money(a)
    b = to_money(b)
    c = determine_currency(a.currency, b.currency)

    Decimal.add(a.value, b.value) |> Money.make(currency: c)
  end

  @doc """

  Substracts money from money returning a money struct
  with the result.

  ## Examples

      iex> payment_one = Monetized.Money.make(50)
      ...> payment_two = Monetized.Money.make(51, [currency: "EUR"])
      ...> Monetized.Math.sub(payment_one, payment_two)
      #Money<-1.00EUR>

      iex> payment_one = Monetized.Money.make(2000)
      ...> payment_two = Monetized.Money.make(150.25)
      ...> result = Monetized.Math.sub(payment_one, payment_two)
      ...> Monetized.Money.to_string(result)
      "1,849.75"

      iex> result = Monetized.Math.sub(100.50, 200)
      ...> Monetized.Money.to_string(result)
      "-99.50"

      iex> result = Monetized.Math.sub("£ -100", "1,200.00")
      ...> Monetized.Money.to_string(result, [currency_symbol: true])
      "£ -1,300.00"

  """

  @spec sub(
          Money.t() | String.t() | integer | float | Decimal,
          Money.t() | String.t() | integer | float | Decimal
        ) :: Money.t()

  def sub(a, b) do
    a = to_money(a)
    b = to_money(b)
    c = determine_currency(a.currency, b.currency)

    Decimal.sub(a.value, b.value)
    |> Money.make(currency: c)
  end

  defp to_money(%Monetized.Money{} = money), do: money
  defp to_money(amount), do: Money.make(amount)

  defp determine_currency(nil, b), do: b
  defp determine_currency(a, nil), do: a
  defp determine_currency(nil, nil), do: nil

  defp determine_currency(a, b) do
    if a != b, do: raise_currency_conflict()
    a || b
  end

  defp raise_currency_conflict do
    raise "Math requires both values to be of the same currency."
  end
end
