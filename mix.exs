defmodule Consul.MixProject do
  use Mix.Project

  def project do
    [
      app: :exconsulex,
      version: "0.2.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      source_url: "https://github.com/simplifi/exconsulex",
      description: "Library for interacting with Consul",
      dialyzer: [
        flags: [
          :unmatched_returns,
          :error_handling,
          :race_conditions
        ],
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Consul.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.3"},
      {:jason, "~> 1.0", optional: true},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:credo, "~> 1.5", only: :dev, runtime: false},
      {:dialyxir, "~> 1.1", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Kurt Johnson <kurt@simpli.fi>"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/simplifi/exconsulex"},
      files: ~w"lib mix.exs README.md LICENSE"
    ]
  end
end
