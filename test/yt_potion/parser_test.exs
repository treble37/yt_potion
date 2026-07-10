defmodule YtPotion.ParserTest do
  use ExUnit.Case, async: true

  alias YtPotion.{Error, Parser}

  describe "parse/1" do
    test "returns {:ok, items} when the body has an items list" do
      body = %{
        "kind" => "youtube#videoListResponse",
        "items" => [%{"id" => "abc123", "kind" => "youtube#video"}]
      }

      assert Parser.parse(body) == {:ok, [%{"id" => "abc123", "kind" => "youtube#video"}]}
    end

    test "returns {:ok, []} when items is an empty list" do
      assert Parser.parse(%{"items" => []}) == {:ok, []}
    end

    test "returns {:error, %YtPotion.Error{}} for a real YouTube API error payload" do
      body =
        "test/support/fixtures/youtube_error_response.json"
        |> File.read!()
        |> Jason.decode!()

      assert {:error, %Error{type: :api_error, message: message}} = Parser.parse(body)
      assert message =~ "exceeded your quota"
    end
  end
end
