local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key("n", "<leader>ol", "<cmd>Outline<cr>", { desc = "Toggle outline" }),
}

return M
