local keymap = require("api.keymap")

local M = {
  keymap.set_lazily("n", "<leader>fl", "<cmd>Fyler<cr>", { desc = "Open Fyler file explorer" }),
}

return M
