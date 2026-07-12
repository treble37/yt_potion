defmodule YtPotion.ClientTest do
  use ExUnit.Case

  alias Plug.Conn
  alias YtPotion.{Client, Error}

  setup do
    original = Application.get_env(:yt_potion, YtPotion)
    Application.put_env(:yt_potion, YtPotion, yt_api_key: "test-api-key")
    on_exit(fn -> Application.put_env(:yt_potion, YtPotion, original) end)
    :ok
  end

  describe "get/3" do
    test "returns {:ok, items} on a successful response" do
      Req.Test.stub(__MODULE__.Success, fn conn ->
        Req.Test.json(conn, %{"items" => [%{"id" => "abc123"}]})
      end)

      assert Client.get("videos", %{id: "abc123"}, plug: {Req.Test, __MODULE__.Success}) ==
               {:ok, [%{"id" => "abc123"}]}
    end

    test "returns {:error, %Error{type: :api_error}} when the API returns an error payload in a 200 response" do
      Req.Test.stub(__MODULE__.ApiError, fn conn ->
        Req.Test.json(conn, %{"error" => %{"message" => "quota exceeded"}})
      end)

      assert {:error, %Error{type: :api_error, message: "quota exceeded"}} =
               Client.get("search", %{}, plug: {Req.Test, __MODULE__.ApiError})
    end

    test "returns {:error, %Error{type: :http_error}} on a non-2xx status" do
      Req.Test.stub(__MODULE__.HttpError, fn conn ->
        conn
        |> Conn.put_status(404)
        |> Req.Test.json(%{"message" => "not found"})
      end)

      assert {:error, %Error{type: :http_error, status: 404}} =
               Client.get("videos", %{id: "nope"}, plug: {Req.Test, __MODULE__.HttpError})
    end

    test "returns {:error, %Error{type: :http_error}} on a transport failure" do
      Req.Test.stub(__MODULE__.Transport, fn conn ->
        Req.Test.transport_error(conn, :timeout)
      end)

      assert {:error, %Error{type: :http_error, status: nil}} =
               Client.get("videos", %{id: "abc123"},
                 plug: {Req.Test, __MODULE__.Transport},
                 retry: false
               )
    end

    test "returns {:error, %Error{type: :config_error}} when yt_potion is not configured" do
      Application.delete_env(:yt_potion, YtPotion)

      assert {:error, %Error{type: :config_error}} = Client.get("videos", %{id: "abc123"})
    end
  end
end
