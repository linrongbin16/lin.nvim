local keymap = require("api.keymap")

local M = {
  keymap.set_lazily(
    "n",
    "<leader>nt",
    "<cmd>Neotree toggle reveal<cr>",
    { silent = false, desc = "Toggle neo-tree file explorer" }
  ),
  keymap.set_lazily(
    "n",
    "<leader>nf",
    "<cmd>Neotree reveal<cr>",
    { silent = false, desc = "Find current file in neo-tree file explorer" }
  ),
}

return M
