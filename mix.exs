Code.eval_file("mess.exs")
defmodule Bonfire.Upcycle.MixProject do

  use Mix.Project

  def project do
    [
      app: :bonfire_upcycle,
      version: "0.1.0",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: Mess.deps [
        {:phoenix_live_reload, "~> 1.2", only: :dev},
        {:dbg, "~> 1.0", only: [:dev, :test]},
        {:floki, ">= 0.0.0", only: [:dev, :test]},
        {:absinthe, "~> 1.6.6", optional: true},
        {:absinthe_plug, "~> 1.5", optional: true},
        {:bonfire_search, git: "https://github.com/bonfire-networks/bonfire_search#main", optional: true}
      ]
    ]
  end

  def application, do: [ extra_applications: [:logger, :runtime_tools] ]

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]



  defp aliases do
    [
      "hex.setup": ["local.hex --force"],
      "rebar.setup": ["local.rebar --force"],
      "js.deps.get": ["cmd npm install --prefix assets"],
      "ecto.seeds": ["run priv/repo/seeds.exs"],
      setup: ["hex.setup", "rebar.setup", "deps.get", "ecto.setup", "js.deps.get"],
      updates: ["deps.get", "ecto.migrate", "js.deps.get"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "ecto.seeds"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end

end
