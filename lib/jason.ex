if Code.ensure_loaded?(Jason) do
  defimpl Jason.Encoder, for: Monetized.Money do
    def encode(%Monetized.Money{} = money, _options), do: Monetized.Money.to_string(money)
  end
end
