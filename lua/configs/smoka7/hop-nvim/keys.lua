local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key({ "n", "x" }, "<leader>j", "<cmd>HopLineAC<cr>", { desc = "Jump to below lines" }),
  set_lazy_key({ "n", "x" }, "<leader>k", "<cmd>HopLineBC<cr>", { desc = "Jump to above lines" }),
}

return M
