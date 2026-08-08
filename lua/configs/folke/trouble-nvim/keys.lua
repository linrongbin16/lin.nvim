local keymap = require("api.keymap")

local M = {
  keymap.set_lazily(
    "n",
    "<leader>tb",
    "<cmd>TroubleToggle<cr>",
    { desc = "Toggle trouble (diagnostics)" }
  ),
}

return M
