# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :monetized, config: [
  delimiter: ",",
  separator: ".",
  currency: "USD",
  format: "%c %n%s%d"
]
