defmodule PoisonTest do
  use ExUnit.Case, async: true
  alias Monetized.Money

  test "Poison serialization" do
    money = Money.make("$100.50")

    assert money |> Poison.encode! |> Poison.decode!(as: %Money{}) == money
  end
end
