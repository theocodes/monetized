defmodule Monetized.Mixfile do
  use Mix.Project

  def project do
    [
      app: :monetized,
      name: "Monetized",
      source_url: "https://github.com/theocodes/monetized",
      version: "0.5.1",
      elixir: "~> 1.3",
      description: description(),
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.11.5", only: :dev},
      {:earmark, "~> 0.2.1", only: :dev},
      {:inch_ex, "~> 0.5.1", only: :docs},
      {:decimal, "~> 1.3"},
      {:ecto, "~> 2.1.3"},
      {:benchfella, "~> 0.3.2", only: :bench},
      {:poison, "~> 1.5 or ~> 2.0", optional: true}
    ]
  end

  defp package do
    [
      maintainers: ["Theo Felippe"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/theocodes/monetized",
        "Docs" => "http://hexdocs.pm/monetized"
      }
    ]
  end

  defp description do
    """

    A lightweight solution for handling and storing money.

    """
  end
end
