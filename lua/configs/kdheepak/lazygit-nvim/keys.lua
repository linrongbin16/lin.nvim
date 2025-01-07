local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "Open lazygit in terminal" }),
}

return M
