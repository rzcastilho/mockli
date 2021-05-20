defmodule Mockli.MixProject do
  use Mix.Project

  def project do
    [
      app: :mockli,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.7"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.3"},
      {:x509, "~> 0.8.1"},
      {:do_it, "~> 0.2"},
      {:ex_prompt, "~> 0.1"}
    ]
  end

  defp escript do
    [main_module: Mockli.Client]
  end
end
