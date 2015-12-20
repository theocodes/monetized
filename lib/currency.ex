defmodule Monetized.Currency do
  
  @moduledoc """
  
  Defines available currencies and functions to handle them
  
  """
  
  def get_currency(key) do
    all[key]
  end
  
  defp all do
    %{
      "EUR" => %{name: "Euro", symbol: "€", to_unit: 100},
      "GBP" => %{name: "Pound Sterling", symbol: "£", to_unit: 100},
      "USD" => %{name: "US Dollar", symbol: "$", to_unit: 100}
    }
  end
  
end
