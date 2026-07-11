defmodule YtPotion.Resources.Channel do
  @moduledoc """
  The YouTube Data API `channels` resource.
  """

  use YtPotion.Resource, path: "channels", actions: [:list]
end
