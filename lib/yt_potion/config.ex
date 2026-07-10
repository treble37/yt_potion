defmodule YtPotion.Config do
  @moduledoc false

  def config, do: Application.get_env(:yt_potion, YtPotion)
  def config(key), do: Keyword.get(config(), key)

  if !Application.get_env(:yt_potion, YtPotion), do: raise("YtPotion is not configured")
end
