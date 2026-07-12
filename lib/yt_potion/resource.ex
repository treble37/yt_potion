defmodule YtPotion.Resource do
  @moduledoc """
  Macro for declaring a YouTube Data API resource from a `{path, actions}`
  pair, replacing one hand-written module + macro per endpoint.

      defmodule YtPotion.Resources.Search do
        use YtPotion.Resource, path: "search", actions: [:list]
      end

  Only actions present in `:actions` get a function generated — there is no
  implicit default, so it's clear at each call site what's enabled. Phase 1
  resources only ever pass `actions: [:list]`; Phase 3 adds `:insert`,
  `:update`, and `:delete` clauses to `action_ast/2` (a new private
  function clause each, no redesign of this macro) and any resource that
  lists one of them in `:actions` picks up the generated function.
  """

  defmacro __using__(opts) do
    path = Keyword.fetch!(opts, :path)
    actions = Keyword.fetch!(opts, :actions)

    asts = Enum.map(actions, &action_ast(&1, path))

    quote do
      (unquote_splicing(asts))
    end
  end

  defp action_ast(:list, path) do
    quote do
      @spec list(map(), map()) :: {:ok, [map()]} | {:error, YtPotion.Error.t()}
      def list(filter_part, options \\ %{}) do
        YtPotion.Client.get(unquote(path), Map.merge(filter_part, options))
      end
    end
  end
end
