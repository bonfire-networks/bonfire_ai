defmodule Bonfire.AI.RuntimeConfig do
  use Bonfire.Common.Localise

  @behaviour Bonfire.Common.ConfigModule
  def config_module, do: true

  @doc """
  NOTE: you can override this default config in your app's `runtime.exs`, by placing similarly-named config keys below the `Bonfire.Common.Config.LoadExtensionsConfig.load_configs()` line
  """
  def config do
    import Config

    Application.put_env(:nx, :default_backend, EXLA.Backend)

    config :bonfire_ai,
      disabled: false
  end
end
