defmodule MoneyBench do
  use Benchfella

  bench "make with string" do
    Monetized.Money.make("$100")
  end

  bench "make with string and currency option" do
    Monetized.Money.make("100", currency: "USD")
  end

  bench "make with float" do
    Monetized.Money.make(100.00, currency: "USD")
  end

  bench "make with integer" do
    Monetized.Money.make(100, currency: "USD")
  end

  bench "make with formatted decimal", decimal: Decimal.new("100.00") do
    Monetized.Money.make(decimal, currency: "USD")
  end

  # decimal doesnt have exp -2, meaning the decimal has to be coerced
  bench "make with unformatted decimal", decimal: Decimal.new(100.00) do
    Monetized.Money.make(decimal, currency: "USD")
  end

  bench "zero" do
    Monetized.Money.zero(currency: "USD")
  end
end
