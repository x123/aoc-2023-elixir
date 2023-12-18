defmodule Day3.MixProject do
  use Mix.Project

  def project do
    [
      app: :day3,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      escript: escript(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp escript do
    [main_module: Day3]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:matrix_reloaded, ">= 2.3.0"}
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
