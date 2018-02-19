defmodule Monetized.CurrencyTest do
  use ExUnit.Case
  alias Monetized.Currency

  doctest Monetized.Currency

  test "parse_by_symbol" do
    assert Currency.parse("$200.00") == %{name: "US Dollar", symbol: "$", key: "USD", type: "Fiat"}
    assert Currency.parse("C$200.00") == %{name: "Canadian Dollar", symbol: "C$", key: "CAD", type: "Fiat"}
    assert Currency.parse("₿200.00") == %{name: "Bitcoin", symbol: "₿", key: "BTC", type: "Crypto"}
  end
end
