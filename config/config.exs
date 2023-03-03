import Config

#### Basic configuration useful for tests, everything else should be in `Bonfire.AI.RuntimeConfig`

# You probably won't want to touch these. You might override some in
# other config files.

config :bonfire, :repo_module, Bonfire.Common.Repo

config :nx, default_backend: EXLA.Backend

config :phoenix, :json_library, Jason

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :mime, :types, %{
  "application/activity+json" => ["activity+json"]
}

config :bonfire.ai, :otp_app, :bonfire.ai
config :bonfire_common, :otp_app, :bonfire.ai
config :bonfire.ai, :repo_module, Bonfire.Common.Repo
config :bonfire.ai, ecto_repos: [Bonfire.Common.Repo]
config :bonfire.ai, :localisation_path, "priv/localisation"

config :bonfire_data_identity, Bonfire.Data.Identity.Credential, hasher_module: Argon2

# import_config "#{Mix.env()}.exs"
