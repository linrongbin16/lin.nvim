local keymap = require("util.keymap")

local M = {
  keymap.set_lazily("n", "<leader>gb", "<cmd>BlameToggle<cr>", { desc = "Toggle git blame" }),
}

return M
