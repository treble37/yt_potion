defmodule YtPotion.Config.Test do
  use ExUnit.Case
  doctest YtPotion.Config

  test "gets current configurations" do
    config = YtPotion.Config.config()
    assert Keyword.has_key?(config, :yt_api_key)
  end
end
