ExUnit.start()

# Resource-generated `list/2` functions call `YtPotion.Client.get/2` with no
# room for a per-call `plug:` option, so route all test-env Req requests
# through Req.Test by default. Req.new/1 merges explicit options on top of
# this (Keyword.merge/2 favors the second argument), so client_test.exs's
# explicit per-test `plug:` names still take precedence over this default.
Req.default_options(plug: {Req.Test, YtPotion.Client})
