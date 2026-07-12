defmodule YtPotion.Resources.ChannelTest do
  use ExUnit.Case

  alias YtPotion.Resources.Channel

  setup do
    original = Application.get_env(:yt_potion, YtPotion)
    Application.put_env(:yt_potion, YtPotion, yt_api_key: "test-api-key")
    on_exit(fn -> Application.put_env(:yt_potion, YtPotion, original) end)
    :ok
  end

  describe "list/2" do
    test "returns {:ok, items} on a successful response" do
      Req.Test.stub(YtPotion.Client, fn conn ->
        assert conn.request_path == "/youtube/v3/channels"
        Req.Test.json(conn, %{"items" => [%{"id" => "abc123"}]})
      end)

      assert Channel.list(%{id: "abc123"}, %{part: "snippet"}) ==
               {:ok, [%{"id" => "abc123"}]}
    end

    test "returns {:error, %YtPotion.Error{type: :api_error}} on an API error payload" do
      Req.Test.stub(YtPotion.Client, fn conn ->
        Req.Test.json(conn, %{"error" => %{"message" => "quota exceeded"}})
      end)

      assert {:error, %YtPotion.Error{type: :api_error, message: "quota exceeded"}} =
               Channel.list(%{id: "abc123"})
    end
  end
end
