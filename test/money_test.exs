defmodule Monetized.MoneyTest do
  use ExUnit.Case
  alias Monetized.Money
  doctest Monetized.Money

  @money %Money{value: Decimal.new("100.50"), currency: "GBP"}

  test "cast itself" do
    assert Money.cast(@money) == {:ok, @money}
  end

  test "cast with amount and currency" do
    params = %{"value" => Decimal.new("100.50"), "currency" => "GBP"}
    assert Money.cast(params) == {:ok, @money}

    params = %{value: Decimal.new("100.50"), currency: "GBP"}
    assert Money.cast(params) == {:ok, @money}
  end

  test "cast with string amount only" do
    expected = %Money{value: Decimal.new("10.50"), currency: nil}
    assert Money.cast("10.50") == {:ok, expected}

    expected = %Money{value: Decimal.new("10.50"), currency: "EUR"}
    assert Money.cast("€ 10.50") == {:ok, expected}

    expected = %Money{value: Decimal.new("10.50"), currency: "USD"}
    assert Money.cast("USD 10.50") == {:ok, expected}

    expected = %Money{value: Decimal.new("10.50"), currency: "THB"}
    assert Money.cast("10.50 THB") == {:ok, expected}
  end

  test "cast with float amount only" do
    expected = %Money{value: Decimal.new("300.50"), currency: nil}
    assert Money.cast(300.50) == {:ok, expected}
  end

  test "cast with integer amount only" do
    expected = %Money{value: Decimal.new("10.00"), currency: nil}
    assert Money.cast(10) == {:ok, expected}
  end

  test "cast with decimal amount only" do
    expected = %Money{value: Decimal.new("20.52"), currency: nil}
    assert Money.cast(Decimal.new("20.52")) == {:ok, expected}
  end

  test "dump iself into a money duplet" do
    assert Money.dump(@money) == {:ok, "100.50 GBP"}

    m = %Money{value: Decimal.new("50.25"), currency: nil}
    assert Money.dump(m) == {:ok, "50.25"}
  end

  test "load a money duplet" do
    assert Money.load("100.50 GBP") == {:ok, @money}
    assert Money.load(@money) == :error
  end

  test "inspect protocol" do
    assert inspect(@money) == "#Money<100.50GBP>"
    assert inspect(Money.make(50)) == "#Money<50.00>"
  end

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
