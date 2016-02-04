defmodule Monetized.Mixfile do
  use Mix.Project

  def project do
    [app: :monetized,
     name: "Monetized",
     source_url: "https://github.com/theocodes/monetized",
     version: "0.3.2",
     elixir: "~> 1.1",
     description: description,
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.11", only: :dev},
      {:earmark, "~> 0.1", only: :dev},
      {:inch_ex, only: :docs},
      {:decimal, "~> 1.1.0"},
      {:ecto, "~> 1.1.1"},
      {:poison, "~> 1.0"}
    ]
  end

  defp package do
    [
      maintainers: ["Thiago Felippe"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/theocodes/monetized",
              "Docs" => "http://hexdocs.pm/monetized"}
    ]
  end

  defp description do
    """

    A lightweight solution for handling and storing money.

    """
  end

end
