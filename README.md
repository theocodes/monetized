# Monetized
[![Build Status](https://travis-ci.org/theocodes/monetized.svg?branch=master)](https://travis-ci.org/theocodes/monetized)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/theocodes/monetized.svg)](https://beta.hexfaktor.org/github/theocodes/monetized)
[![Inline docs](http://inch-ci.org/github/theocodes/monetized.svg)](http://inch-ci.org/github/theocodes/monetized)

As a general rule, using floats to store money is a [bad idea](http://spin.atomicobject.com/2014/08/14/currency-rounding-errors/).

Enter Monetized. A library that aims to facilitate the handling of money through a safe way to store currency values and
and providing abstractions to perform arithmetical operations on those values.

Monetized leverages [Decimal](https://github.com/ericmj/decimal)'s ability to safely handle arbitrary precision to perform calculations
on money values.

A typical `%Monetized.Money{}` struct will contain a value in the shape of a `Decimal` struct and a currency (if any) as a string.

Requires elixir version 1.3.x or above as per ecto 2.x

## Usage

Monetized also ships with a `Ecto.Type` that gives us an easier way to store money.

```elixir

alias Monetized.Money

schema "transaction" do
  field :description, :string
  field :balance, Money, default: Money.zero

  timestamps
end

```

By doing this we're able to pass a `%Money{}` struct to the changeset and
insert in the `Repo` since Ecto knows how to convert that struct into a primitive
type to save and back when you read from it.

```elixir

balance = Money.make("£ 100.50")
changeset = Transaction.changeset(%Transaction{}, %{description: "Invoice payment", balance: balance})

# Or

balance = %{value: "100.50", currency: "GBP"}
changeset = Transaction.changeset(%Transaction{}, %{description: "Invoice payment", balance: balance})

```

Check the [docs](http://hexdocs.pm/monetized/api-reference.html) for more.

## Other usage

```elixir
alias Monetized.Money
alias Monetized.Math

# Create with a string
iex> item_one = Money.make("£ 200.50")
#Money<200.50GBP>

# Or a float
iex> item_two = Money.make(10.25, [currency: "GBP"])
#Money<10.25GBP>

# Adding two moneys together
iex> Math.add(item_one, item_two)
#Money<210.75GBP>

# Or an integer
iex> balance = Money.make(100_000, [currency: "USD"])
#Money<100000.00USD>

# Substracting from money (currency inferred from balance)
iex> result = Math.sub(balance, 50_000)
#Money<50000.00USD>

# Getting the string representation
iex> Money.to_string(result, [currency_symbol: true])
"$ 50,000.00"

# You can also use `from_integer/2`, `from_float/2`, `from_decimal/2` and `from_string/2`
# respectively if the desired behavior is to raise when the amount is 
# not of the expected type.

# If either the symbol or the currency key is found within the string,
# that currency will be used. However, if a different currency is given in the
# options, it will take precedence.

iex> Money.from_string("£ 200")
#Money<200.00GBP>

iex> Money.from_string("200 EUR")
#Money<200.00EUR>

iex> Money.from_integer(200)
#Money<200.00>

iex> Money.from_float(200.50)
#Money<200.50>

iex> decimal = Decimal.new(10.25)
...> Money.from_decimal(decimal, currency: "EUR")
#Money<10.15EUR>

iex> Money.from_integer("10")
** (FunctionClauseError) no function clause matching in Monetized.Money.from_integer/2
    (monetized) lib/money.ex:204: Monetized.Money.from_integer("10", [])

```

Check the [docs](http://hexdocs.pm/monetized/api-reference.html) for more examples

## Config


```elixir
config :monetized, config: [
  delimiter: ",",
  separator: ".",
  currency: "USD",
  format: "%cs %n%s%d"
]
```

## Installation

  Add monetized to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:monetized, "~> 0.5.0"}]
end

```

## TODO

[] New currencies can be added through the package's config
[] 1.0.0 ! yay!

## Benchmarking

```sh-session
$ mix deps.get
$ MIX_ENV=bench mix compile
$ MIX_ENV=bench mix bench
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Licensing

See [LICENSE.md](LICENSE.md)
