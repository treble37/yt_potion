defmodule YtPotion.Auth.ApiKey do
  @moduledoc """
  Default `YtPotion.Auth` strategy: adds the YouTube API key as a `key`
  query parameter, appending to any params already set on the request.
  """

  @behaviour YtPotion.Auth

  @impl YtPotion.Auth
  @spec apply(Req.Request.t(), String.t()) :: Req.Request.t()
  def apply(request, api_key) when is_binary(api_key) do
    existing_params = Req.Request.get_option(request, :params, [])
    Req.Request.merge_options(request, params: existing_params ++ [key: api_key])
  end
end
