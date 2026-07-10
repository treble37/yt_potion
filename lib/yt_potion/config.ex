defmodule YtPotion.Config do
  @moduledoc """
  Runtime lookup for yt_potion's configuration.

  Configuration is read lazily on each call rather than checked at compile
  or application-load time, so a misconfigured app boots fine and only
  fails the specific call that needs the missing config.
  """

  @spec config() :: {:ok, keyword()} | {:error, :not_configured}
  def config do
    case Application.get_env(:yt_potion, YtPotion) do
      nil -> {:error, :not_configured}
      config -> {:ok, config}
    end
  end

  @spec config(atom()) :: {:ok, term()} | {:error, :not_configured | :key_not_found}
  def config(key) do
    with {:ok, config} <- config() do
      case Keyword.fetch(config, key) do
        {:ok, value} -> {:ok, value}
        :error -> {:error, :key_not_found}
      end
    end
  end
end
