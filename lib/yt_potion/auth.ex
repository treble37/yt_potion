defmodule YtPotion.Auth do
  @moduledoc """
  Behaviour for pluggable authentication strategies.

  An implementation receives a `Req.Request.t()` and a credentials term
  (whatever shape that strategy expects — an API key string, an OAuth
  token, etc.) and returns the request modified to carry authentication,
  e.g. as a query param or an `Authorization` header.

  `YtPotion.Auth.ApiKey` is the only strategy shipped in Phase 1. This
  behaviour exists so a future OAuth strategy can be added without
  changing `YtPotion.Client`.
  """

  @callback apply(Req.Request.t(), credentials :: term()) :: Req.Request.t()
end
