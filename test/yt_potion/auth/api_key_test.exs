defmodule YtPotion.Auth.ApiKeyTest do
  use ExUnit.Case, async: true

  alias YtPotion.Auth.ApiKey

  test "adds the api key as a `key` query param" do
    request = Req.new(url: "https://example.com")

    result = ApiKey.apply(request, "my-secret-key")

    assert result.options[:params] == [key: "my-secret-key"]
  end

  test "appends to existing params instead of overwriting them" do
    request = Req.new(url: "https://example.com", params: [part: "snippet"])

    result = ApiKey.apply(request, "my-secret-key")

    assert result.options[:params] == [part: "snippet", key: "my-secret-key"]
  end

  test "implements the YtPotion.Auth behaviour" do
    assert ApiKey.__info__(:attributes)[:behaviour] == [YtPotion.Auth]
  end
end
