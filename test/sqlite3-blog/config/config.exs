use Mix.Config

config :blog, Blog.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "blog_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"
