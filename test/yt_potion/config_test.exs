defmodule YtPotion.ConfigTest do
  use ExUnit.Case

  alias YtPotion.Config

  describe "config/0" do
    test "returns {:ok, keyword} when yt_potion is configured" do
      assert {:ok, config} = Config.config()
      assert Keyword.keyword?(config)
    end

    test "returns {:error, :not_configured} when yt_potion has no config entry" do
      original = Application.get_env(:yt_potion, YtPotion)
      Application.delete_env(:yt_potion, YtPotion)

      on_exit(fn -> Application.put_env(:yt_potion, YtPotion, original) end)

      assert Config.config() == {:error, :not_configured}
    end
  end

  describe "config/1" do
    test "returns {:ok, value} for a configured key" do
      assert {:ok, _value} = Config.config(:yt_api_key)
    end

    test "returns {:error, :key_not_found} for a missing key on a configured app" do
      assert Config.config(:does_not_exist) == {:error, :key_not_found}
    end

    test "returns {:error, :not_configured} when yt_potion has no config entry" do
      original = Application.get_env(:yt_potion, YtPotion)
      Application.delete_env(:yt_potion, YtPotion)

      on_exit(fn -> Application.put_env(:yt_potion, YtPotion, original) end)

      assert Config.config(:yt_api_key) == {:error, :not_configured}
    end
  end
end
