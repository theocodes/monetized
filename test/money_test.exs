defmodule Monetized.MoneyTest do
  use ExUnit.Case
  alias Monetized.Money

  doctest Monetized.Money

  test "raises if amount not float" do
    assert_raise FunctionClauseError, fn ->
      Money.from_float(100)
    end
  end

  test "raises if amount not integer" do
    assert_raise FunctionClauseError, fn ->
      Money.from_integer(100.00)
    end
  end

  test "raises if amount not string" do
    assert_raise FunctionClauseError, fn ->
      Money.from_string(100.00)
    end
  end

  test "raises if amount not decimal" do
    assert_raise FunctionClauseError, fn ->
      Money.from_decimal(100.00)
    end
  end

end
