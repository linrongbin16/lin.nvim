local keymap = require("api.keymap")

local M = {
  -- keymap.set_lazily(
  --   "n",
  --   "<leader>nt",
  --   "<cmd>Neotree toggle reveal<cr>",
  --   { silent = false, desc = "Toggle neo-tree file explorer" }
  -- ),
  keymap.set_lazily(
    "n",
    "<leader>nt",
    "<cmd>Neotree reveal<cr>",
    { silent = false, desc = "Open neo-tree file explorer" }
  ),
}

return M
