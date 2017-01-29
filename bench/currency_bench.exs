defmodule CurrencyBench do
  use Benchfella

  bench "parse" do
    Monetized.Currency.parse("EUR 200.00")
  end

  bench "parse_by_key" do
    Monetized.Currency.parse("EUR 200.00")
  end

  bench "parse_by_symbol" do
    Monetized.Currency.parse_by_symbol("€ 200.00")
  end

  bench "all" do
    Monetized.Currency.all
  end

  bench "get" do
    Monetized.Currency.get("EUR")
  end
end
