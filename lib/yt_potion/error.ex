defmodule YtPotion.Error do
  @moduledoc """
  Error struct returned by any yt_potion call that can fail at runtime.

  `:type` distinguishes three failure categories:

    * `:http_error` — the HTTP request itself failed or returned a
      non-2xx status. `:status` and `:body` are populated when available.
    * `:api_error` — the request succeeded at the HTTP level but the
      YouTube API returned an `"error"` payload.
    * `:config_error` — yt_potion is not configured (missing API key).
  """

  @type type :: :http_error | :api_error | :config_error

  @type t :: %__MODULE__{
          type: type(),
          message: String.t(),
          status: integer() | nil,
          body: term() | nil
        }

  defstruct [:type, :message, :status, :body]

  @spec http_error(integer(), term()) :: t()
  def http_error(status, body) do
    %__MODULE__{
      type: :http_error,
      message: "HTTP error (status #{status})",
      status: status,
      body: body
    }
  end

  @spec api_error(String.t()) :: t()
  def api_error(message) do
    %__MODULE__{type: :api_error, message: message}
  end

  @spec config_error(String.t()) :: t()
  def config_error(message \\ "YtPotion is not configured") do
    %__MODULE__{type: :config_error, message: message}
  end
end
