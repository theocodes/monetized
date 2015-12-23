# Monetized
[![Build Status](https://travis-ci.org/theocodes/monetized.svg?branch=master)](https://travis-ci.org/theocodes/monetized)
[![Inline docs](http://inch-ci.org/github/theocodes/monetized.svg)](http://inch-ci.org/github/theocodes/monetized)

As a general rule, using floats to store money is a [bad idea](http://spin.atomicobject.com/2014/08/14/currency-rounding-errors/).

Integers on the other hand are great!

However, in order for it to be an actual viable option we must first lay some groundwork and this is why Monetized library exists.

## Usage

```elixir
alias Monetized.Money
alias Monetized.Math

# Create with a string
item_one = Money.make("£ 200.50")
item_one == %Monetized.Money{currency: "GBP", units: 20050}

# Or a float
item_two = Money.make(10.25, [currency: "GBP"])
item_two == %Monetized.Money{currency: "GBP", units: 1025}

# Adding two moneys together
Math.add(item_one, item_two) == %Monetized.Money{currency: "GBP", units: 21075}

# Or an integer
balance = Money.make(100_000_00, [units: true])

# Subtracting from money
result = Math.sub(balance, 50_000)
result == %Monetized.Money{currency: "USD", units: 5000000}

# Getting the string representation
Money.to_string(result, [show_currency: true]) == "$ 50,000.00"

# You can also use `from_integer/2`, `from_float/2` and `from_string/2`
# respectively if the desired behavior is to raise when the amount is 
# not of the expected type.

# If either the symbol or the currency key is found within the string,
# that currency will be used. However, if a different currency is given in the
# options, it will take precedence.
Money.from_string("£ 200") == %Monetized.Money{currency: "GBP", units: 20000}
Money.from_string("200 EUR") == %Monetized.Money{currency: "EUR", units: 20000}

# Passing `units: true` in the options will make it assume the amount is
# already in the basic fractional unit format
Money.from_integer(20050, [units: true]) == %Monetized.Money{currency: "USD", units: 20050}

Money.from_float(200.50) == %Monetized.Money{currency: "USD", units: 20050}

Money.from_integer("10") # This will raise FunctionClauseError
```

Check the [docs](http://hexdocs.pm/monetized/0.2.0/) for more examples

##### Note

Although you can give `Money.make/2` a float to create a money struct,
serves only as a convenience utility and none of the internal operactions 
are done on floats but rather on the basic fractional units (integers).

## Config


```elixir
config :monetized, config: [
  delimiter: ",",
  separator: ".",
  currency: "USD",
  format: "%c %n%s%d"
]
```

## Installation

  Add monetized to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:monetized, "~> 0.2.0"}]
end

```

## TODO

[] Add more currencies (currenctly only supports USD, GBP and EUR)
[] Get feedback...

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Licensing

See [LICENSE.md](LICENSE.md)
