local keymap = require("api.keymap")

local M = {
  keymap.set_lazily("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "Open lazygit in terminal" }),
}

return M
