# Monetized
[![Build Status](https://travis-ci.org/theocodes/monetized.svg?branch=master)](https://travis-ci.org/theocodes/monetized)
[![Inline docs](http://inch-ci.org/github/theocodes/monetized.svg)](http://inch-ci.org/github/theocodes/monetized)

As a general rule, using floats to store money is a [bad idea](http://spin.atomicobject.com/2014/08/14/currency-rounding-errors/).

Integers on the other hand are great. 

However, in order for it to be an actual viable option we must first lay some groundwork and this is why Monetized library exists.

## Usage

```elixir
alias Monetized.Money
alias Monetized.Math

# Create with a string
item_one = Money.make("200.50", [currency: "GBP"])
item_one == %Monetized.Money{currency: "GBP", units: 20050}

# Or a float
item_two = Money.make(10.25)

# Adding two moneys together
Math.add(item_one, item_two) == %Monetized.Money{currency: "USD", units: 21075}

# Or an integer
balance = Money.make(100_000_00, [units: true])

# Substracting from money
result = Math.sub(balance, 50_000)
result == %Monetized.Money{currency: "USD", units: 5000000}

# Getting the string representation
Money.to_string(result, [show_currency: true]) == "$ 50,000.00"
```

Check the [docs](http://hexdocs.pm/monetized/0.1.0/) for more examples

##### Note

Although you can give `Money.make/1` a float to create a money struct,
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
  [{:monetized, "~> 0.1.0"}]
end

```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Licensing

See [LICENSE.md](LICENSE.md)
