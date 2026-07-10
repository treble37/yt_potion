defmodule YtPotion.Client do
  @moduledoc """
  The Req integration point: reads configuration, applies the configured
  `YtPotion.Auth` strategy, issues the request, and routes the response
  through `YtPotion.Parser`.
  """

  alias YtPotion.{Auth, Config, Error, Parser}

  @base_url "https://www.googleapis.com/youtube/v3"

  @doc """
  Issues a GET request against the given YouTube Data API `path` with
  `params` as the query string. `req_options` are merged into the
  underlying `Req` request (e.g. `plug: {Req.Test, MyStub}` in tests).
  """
  @spec get(String.t(), map(), keyword()) :: {:ok, [map()]} | {:error, Error.t()}
  def get(path, params, req_options \\ []) do
    with {:ok, api_key} <- fetch_api_key() do
      [base_url: @base_url, url: "/" <> path, params: Map.to_list(params)]
      |> Keyword.merge(req_options)
      |> Req.new()
      |> Auth.ApiKey.apply(api_key)
      |> Req.request()
      |> handle_response()
    end
  end

  @spec fetch_api_key() :: {:ok, String.t()} | {:error, Error.t()}
  defp fetch_api_key do
    case Config.config(:yt_api_key) do
      {:ok, key} -> {:ok, key}
      {:error, :not_configured} -> {:error, Error.config_error()}
      {:error, :key_not_found} -> {:error, Error.config_error("yt_api_key is not set")}
    end
  end

  @spec handle_response({:ok, Req.Response.t()} | {:error, Exception.t()}) ::
          {:ok, [map()]} | {:error, Error.t()}
  defp handle_response({:ok, %Req.Response{status: status, body: body}})
       when status in 200..299 do
    Parser.parse(body)
  end

  defp handle_response({:ok, %Req.Response{status: status, body: body}}) do
    {:error, Error.http_error(status, body)}
  end

  defp handle_response({:error, exception}) do
    {:error, Error.http_error(nil, Exception.message(exception))}
  end
end
