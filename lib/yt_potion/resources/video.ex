defmodule YtPotion.Resources.Video do
  @moduledoc """
  The YouTube Data API `videos` resource.
  """

  use YtPotion.Resource, path: "videos", actions: [:list]
end
