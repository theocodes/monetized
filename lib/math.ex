defmodule Monetized.Math do
  alias Monetized.Money
  
  @moduledoc """
  
  This modules defines mathematical operations using money.

  All functions in this module take either money struct as
  parameters from which the currency is copied or it will
  convert the given values into a money struct using
  `Monetized.Money.make/1` which in turn will use the default
  currency.
  
  """
  
  @doc """
  
  Adds money to money returning a money struct with
  the result.
  
  ## Examples
  
      iex> payment_one = Monetized.Money.make(10, [currency: "GBP"])
      ...> payment_two = Monetized.Money.make(20.50, [currency: "GBP"])
      ...> result = Monetized.Math.add(payment_one, payment_two)
      ...> Monetized.Money.to_string(result, [show_currency: true])
      "£ 30.50"
      
      iex> result = Monetized.Math.add(100.50, 200)
      ...> Monetized.Money.to_string(result, [show_currency: true])
      "$ 300.50"
      
  """

  @spec add(Money.money | String.t | integer | float, Money.money | String.t | integer | float) :: Money.money
  
  def add(a, b) do
    a = to_money(a)
    b = to_money(b)
    
    a.units + b.units 
    |> Money.make([currency: a.currency, units: true])
  end
  
  
  @doc """
  
  Substracts money from money returning a money struct
  with the result.
  
  ## Examples
  
      iex> payment_one = Monetized.Money.make(50)
      ...> payment_two = Monetized.Money.make(51)
      ...> Monetized.Math.sub(payment_one, payment_two)
      %Monetized.Money{currency: "USD", units: -100}
      
      iex> payment_one = Monetized.Money.make(2000)
      ...> payment_two = Monetized.Money.make(150.25)
      ...> result = Monetized.Math.sub(payment_one, payment_two)
      ...> Monetized.Money.to_string(result, [show_currency: true])
      "$ 1,849.75"
      
      iex> result = Monetized.Math.sub(100.50, 200)
      ...> Monetized.Money.to_string(result, [show_currency: true])
      "$ -99.50"
      
  """

  @spec sub(Money.money | String.t | integer | float, Money.money | String.t | integer | float) :: Money.money
  
  def sub(a, b) do
    a = to_money(a)
    b = to_money(b)
    
    a.units - b.units 
    |> Money.make([currency: a.currency, units: true])
  end
  
  defp to_money(money) when is_map(money), do: money
  defp to_money(amount), do: Money.make(amount)

end
