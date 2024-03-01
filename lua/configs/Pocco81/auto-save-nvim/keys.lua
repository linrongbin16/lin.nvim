local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key("n", "<leader>as", "<cmd>ASToggle<cr>", { desc = "Toggle auto-save" }),
}

return M
