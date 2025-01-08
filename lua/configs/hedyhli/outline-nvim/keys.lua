local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key("n", "<leader>ol", "<cmd>Outline<cr>", { desc = "Toggle outline" }),
  set_lazy_key("n", "<leader>or", "<cmd>OutlineRefresh<cr>", { desc = "Refresh outline" }),
}

return M
