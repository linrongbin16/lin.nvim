local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key(
    "n",
    "<leader>nt",
    "<cmd>Neotree toggle reveal<cr>",
    { silent = false, desc = "Toggle neo-tree file explorer" }
  ),
  set_lazy_key(
    "n",
    "<leader>nf",
    "<cmd>Neotree reveal<cr>",
    { silent = false, desc = "Find current file in neo-tree file explorer" }
  ),
}

return M
