# Changelog

All notable changes to this project will be documented in this file.

For more information about changelogs, check
[Keep a Changelog](http://keepachangelog.com) and
[Vandamme](http://tech-angels.github.io/vandamme).

## 1.0.0 - 2026-07-11

Breaking rewrite of the public API — a modernization of the 0.1.x line, not an incremental patch.

### Breaking changes

* **Errors are tagged tuples, never exceptions.** Every API call returns
  `{:ok, items} | {:error, %YtPotion.Error{}}`. The parser no longer raises on
  YouTube `"error"` payloads (now `{:error, %YtPotion.Error{type: :api_error}}`).
* **Resource modules renamed.** `YtPotion.Search`, `YtPotion.Video`, and
  `YtPotion.Channel` are now `YtPotion.Resources.Search`,
  `YtPotion.Resources.Video`, and `YtPotion.Resources.Channel`, all defined
  through the new `YtPotion.Resource` macro (`use YtPotion.Resource, path: "...",
  actions: [:list]`). `list/2` arguments are unchanged.
* **`HTTPoison` replaced by `Req`.** The `httpoison` and `json` dependencies are
  gone; `req` and `jason` are the runtime dependencies. Successful calls return
  the decoded `"items"` list, not an HTTPoison response.
* **`YtPotion.Config` no longer raises at load time.** A misconfigured app now
  boots normally and fails on the first API call instead, with
  `{:error, %YtPotion.Error{type: :config_error}}`. Config lookup itself returns
  `{:ok, value} | {:error, :not_configured | :key_not_found}`.
* **Elixir `~> 1.15` required** (was `~> 1.3`).

### Added

* `YtPotion.Error` struct distinguishing `:http_error` (with `:status`/`:body`),
  `:api_error`, and `:config_error`.
* `YtPotion.Auth` behaviour for pluggable credential strategies, with
  `YtPotion.Auth.ApiKey` (query-param key) as the shipped implementation —
  designed so an OAuth strategy can be added without touching `YtPotion.Client`.
* `YtPotion.Resource` macro with an explicit `:actions` list, the extension point
  for future write actions (`:insert`/`:update`/`:delete`).
* Dialyzer-clean `@spec`s on all public functions; Credo linting; CI (GitHub
  Actions) enforcing format, credo, dialyzer, and tests on every push/PR.
* Test suite runs fully offline via `Req.Test` — no API key required.

## 0.1.3 - 1/31/17

* [ENHANCEMENT] YtPotion.Video and YtPotion.Channel modules to return the HTTPoison response
* [ENHANCEMENT] Add YtPotion.Search#list method
* [UPDATE] Update YtPotion.Parser method name(s)

## 0.1.2 - 1/27/17

* Update YtPotion.Video and YtPotion.Channel modules to return lists of map data instead of a HTTPoison response

## 0.1.1 - 1/18/17

* Update documentation
* Add methods to YtPotion.Parser
