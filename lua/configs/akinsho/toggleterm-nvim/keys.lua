local keymap = require("api.keymap")

local M = {
  keymap.set_lazily("n", "<leader>tm", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" }),
}

return M
