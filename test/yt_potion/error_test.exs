defmodule YtPotion.ErrorTest do
  use ExUnit.Case, async: true

  alias YtPotion.Error

  describe "http_error/2" do
    test "builds a struct with type :http_error, the status, and the body" do
      error = Error.http_error(404, %{"reason" => "not found"})

      assert %Error{type: :http_error, status: 404, body: %{"reason" => "not found"}} = error
      assert is_binary(error.message)
    end

    test "accepts a nil status for transport-level failures with no HTTP response" do
      error = Error.http_error(nil, "timeout")

      assert %Error{
               type: :http_error,
               status: nil,
               body: "timeout",
               message: "HTTP request failed"
             } =
               error
    end
  end

  describe "api_error/1" do
    test "builds a struct with type :api_error and the given message" do
      error = Error.api_error("quota exceeded")

      assert %Error{type: :api_error, message: "quota exceeded", status: nil, body: nil} = error
    end
  end

  describe "config_error/0 and config_error/1" do
    test "defaults to a standard not-configured message" do
      error = Error.config_error()

      assert %Error{type: :config_error, status: nil, body: nil} = error
      assert error.message =~ "not configured"
    end

    test "accepts a custom message" do
      error = Error.config_error("custom reason")

      assert %Error{type: :config_error, message: "custom reason"} = error
    end
  end
end
