defmodule LangtoolPro.Mixfile do
  use Mix.Project

  @description """
    Phoenix web application for auto-translation
  """

  def project do
    [
      app: :langtool_pro,
      version: "0.1.3",
      elixir: "~> 1.4",
      name: "Langtool.pro",
      description: @description,
      source_url: "https://github.com/kortirso/langtool.pro",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      mod: {LangtoolPro.Application, []},
      extra_applications: [:logger, :runtime_tools, :bamboo, :bamboo_smtp, :galnora]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support", "test/factories"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.4.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:plug_cowboy, "~> 2.0"},
      {:plug, "~> 1.7"},
      {:poison, "~> 3.1"},
      {:comeonin, "~> 4.0"},
      {:bcrypt_elixir, "~> 1.0"},
      # testing factories
      {:ex_machina, "~> 2.2", only: :test},
      # mailing
      {:bamboo, "~> 1.3.0"},
      {:bamboo_smtp, "~> 1.7.0"},
      {:premailex, "~> 0.3.0"},
      {:joken, "~> 2.0"},
      {:jason, "~> 1.0"},
      # saving files
      {:arc_ecto, "~> 0.11.2"},
      # file parse packages
      {:i18n_parser, "~> 0.1.10"},
      # translation genserver
      {:galnora, "~> 0.1.4"},
      # deploying
      {:distillery, "~> 2.1"},
      {:edeliver, ">= 1.7.0"}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  defp package do
    [
      maintainers: ["Anton Bogdanov"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/kortirso/langtool.pro"}
    ]
  end
end
