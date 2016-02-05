defmodule Monetized.Money.Utils do

  @moduledoc false

  # Positive values

  def pf(base, decimal), do: base + decimal
  def pf(base, decimal, to_unit), do: base * to_unit + decimal

  # Negative values

  def nf(base, decimal), do: base - decimal
  def nf(base, decimal, to_unit), do: base * to_unit - decimal

  def is_negative?(n), do: Integer.to_string(n) |> String.match?(~r/-/)

  def option_or_config(config, options, key), do: options[key] || config[key]

  def delimit_integer(number, delimiter) do
    Integer.to_char_list(number)
    |> Enum.reverse
    |> delimit_integer(delimiter, [])
  end

  def delimit_integer([a,b,c,d|tail], delimiter, acc) do
    delimit_integer([d|tail], delimiter, [delimiter,c,b,a|acc])
  end

  def delimit_integer(list, _, acc), do: Enum.reverse(list) ++ acc

end
