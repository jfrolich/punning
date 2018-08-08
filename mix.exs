defmodule Punning.MixProject do
  use Mix.Project

  def project do
    [
      app: :punning,
      description: "Add the field punning language feature to Elixir",
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  defp package do
    [
      maintainers: ["Jaap Frolich"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/jfrolich/punning"}
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
