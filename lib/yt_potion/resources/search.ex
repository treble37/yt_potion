defmodule YtPotion.Resources.Search do
  @moduledoc """
  The YouTube Data API `search` resource.
  """

  use YtPotion.Resource, path: "search", actions: [:list]
end
