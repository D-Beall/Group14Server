defmodule Mix.Tasks.Hello do
  use Mix.Task

  def run(_) do
    Mix.shell().info("Hello world")
  end
end

defmodule MyApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :my_app,
      version: "1.0.0",
      deps: deps()
    ]
  end

  defp deps do
    [
      {:ecto, "~> 2.0"},
      {:plug, github: "elixir-lang/plug"}
    ]
  end
end
