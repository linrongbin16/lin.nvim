local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key(
    { "n", "x", "o" },
    "s",
    "<Plug>(leap-forward)",
    { desc = "Jump forward with s{char1}{char2}" }
  ),
  set_lazy_key(
    { "n", "x", "o" },
    "S",
    "<Plug>(leap-backward)",
    { desc = "Jump backward with s{char1}{char2}" }
  ),
  set_lazy_key(
    "n",
    "gs",
    "<Plug>(leap-from-window)",
    { desc = "Jump to other windows with s{char1}{char2}" }
  ),
}

return M
