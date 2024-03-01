local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key(
    "n",
    "<leader>tb",
    "<cmd>TroubleToggle<cr>",
    { desc = "Toggle trouble (diagnostics)" }
  ),
}

return M
