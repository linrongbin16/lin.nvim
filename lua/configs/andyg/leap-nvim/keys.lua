local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key({ "n", "x", "o" }, "s", "<Plug>(leap)", { desc = "Jump with s{char1}{char2}" }),
  set_lazy_key(
    "n",
    "S",
    "<Plug>(leap-from-window)",
    { desc = "Jump to other windows with s{char1}{char2}" }
  ),
}

return M
