defmodule YtPotion.ResourceTest do
  use ExUnit.Case

  defmodule Sample do
    use YtPotion.Resource, path: "sample_resource", actions: [:list]
  end

  setup do
    original = Application.get_env(:yt_potion, YtPotion)
    Application.put_env(:yt_potion, YtPotion, yt_api_key: "test-api-key")
    on_exit(fn -> Application.put_env(:yt_potion, YtPotion, original) end)
    :ok
  end

  describe "list/2" do
    test "delegates to YtPotion.Client.get/2 with the resource path and merged params" do
      Req.Test.stub(YtPotion.Client, fn conn ->
        assert conn.request_path == "/youtube/v3/sample_resource"
        assert conn.query_string =~ "id=abc123"
        assert conn.query_string =~ "part=snippet"
        Req.Test.json(conn, %{"items" => [%{"id" => "abc123"}]})
      end)

      assert Sample.list(%{id: "abc123"}, %{part: "snippet"}) ==
               {:ok, [%{"id" => "abc123"}]}
    end

    test "defaults options to an empty map when only filter_part is given" do
      Req.Test.stub(YtPotion.Client, fn conn ->
        Req.Test.json(conn, %{"items" => []})
      end)

      assert Sample.list(%{id: "abc123"}) == {:ok, []}
    end
  end

  test "does not define functions for actions not declared in :actions" do
    refute function_exported?(Sample, :insert, 2)
    refute function_exported?(Sample, :update, 2)
    refute function_exported?(Sample, :delete, 1)
  end
end
