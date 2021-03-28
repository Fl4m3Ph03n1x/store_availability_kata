defmodule Availabilities.MixProject do
  use Mix.Project

  def project do
    [
      app: :availabilities,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: preferred_cli_env(),

      # Docs
      name: "Store Availability",
      source_url: "https://github.com/Fl4m3Ph03n1x/store_availability_kata",
      docs: docs()
    ]
  end

  def application,
    do: [
      extra_applications: [:logger]
    ]

  defp deps,
    do: [
      {:typed_struct, "~> 0.2.1"},

      # Dev
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
    ]

  defp docs,
    do: [
      extras: ["README.md"],
      output: "docs"
    ]

  defp preferred_cli_env,
    do: [
      coveralls: :test,
      "coveralls.detail": :test,
      "coveralls.post": :test,
      "coveralls.html": :test
    ]
end
