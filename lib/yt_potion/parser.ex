defmodule YtPotion.Parser do
  @moduledoc """
  Parses a decoded YouTube Data API response body into either the list of
  result items or a `YtPotion.Error` describing what the API rejected.
  """

  alias YtPotion.Error

  @spec parse(map()) :: {:ok, [map()]} | {:error, Error.t()}
  def parse(%{"items" => items}), do: {:ok, items}

  def parse(%{"error" => %{"message" => message}}) when is_binary(message) do
    {:error, Error.api_error(message)}
  end

  def parse(%{"error" => error}) do
    {:error, Error.api_error(inspect(error))}
  end
end
