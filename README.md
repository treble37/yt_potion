# YtPotion

An Elixir wrapper for the YouTube Data API v3 (read-only: search, videos, channels), built on [`Req`](https://hexdocs.pm/req).

All runtime failures return tagged tuples — `{:ok, items}` or `{:error, %YtPotion.Error{}}` — never exceptions.

## Installation

Add `yt_potion` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:yt_potion, "~> 1.0"}
  ]
end
```

Requires Elixir `~> 1.15`.

## Configuration

Configure your YouTube Data API key (e.g. in `config/runtime.exs`):

```elixir
config :yt_potion, YtPotion, yt_api_key: System.get_env("YT_API_KEY")
```

Configuration is checked at runtime, on each API call. A misconfigured
app boots fine; the first call that needs the key returns
`{:error, %YtPotion.Error{type: :config_error}}`.

## Usage

Each resource module exposes `list/2`: the first argument is the filter
part (e.g. `id`, `part`), the second an optional map of extra query
options. Both are merged into the request's query string.

```elixir
# Search
{:ok, items} = YtPotion.Resources.Search.list(%{q: "elixir", part: "snippet"}, %{maxResults: 5})

# Videos
{:ok, items} = YtPotion.Resources.Video.list(%{id: "gBTpB4CV0kU", part: "statistics"})

# Channels
{:ok, items} = YtPotion.Resources.Channel.list(%{forUsername: "elixirconf", part: "snippet"})
```

On success you get the decoded `"items"` list from the API response.

### Error handling

Every failure is a `%YtPotion.Error{}` with a `:type`:

```elixir
case YtPotion.Resources.Video.list(%{id: "abc123", part: "statistics"}) do
  {:ok, items} ->
    items

  {:error, %YtPotion.Error{type: :api_error, message: message}} ->
    # HTTP 2xx, but the YouTube API returned an "error" payload
    Logger.warning(message)

  {:error, %YtPotion.Error{type: :http_error, status: status, body: body}} ->
    # non-2xx status, or the request itself failed (status is nil then)
    Logger.warning("HTTP failure: #{inspect(status)} #{inspect(body)}")

  {:error, %YtPotion.Error{type: :config_error, message: message}} ->
    # missing configuration / API key
    Logger.warning(message)
end
```

### Authentication strategies

HTTP authentication is pluggable via the `YtPotion.Auth` behaviour.
`YtPotion.Auth.ApiKey` (query-param API key) is the shipped
implementation; an OAuth strategy can implement the same behaviour
without changes to `YtPotion.Client`.

## Development

```
mix deps.get
mix compile --warnings-as-errors
mix test              # Req.Test stubs — no network access, no API key needed
mix format
mix credo --strict
mix dialyzer
mix docs
```

The test suite makes zero live network calls; HTTP is stubbed with
`Req.Test`.

## License

MIT — see [LICENSE](LICENSE).
