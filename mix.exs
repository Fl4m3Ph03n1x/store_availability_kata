defmodule Availabilities.MixProject do
  use Mix.Project

  def project do
    [
      app: :availabilities,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Store Availability",
      source_url: "https://github.com/Fl4m3Ph03n1x/store_availability_kata",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:typed_struct, "~> 0.2.1"},

      # Dev
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
    ]
  end

  defp docs(),
    do: [
      main: "Store Availability",
      extras: ["README.md"],
      output: "docs"
    ]
end
