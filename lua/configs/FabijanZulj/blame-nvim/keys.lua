local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  -- toggle git blame
  set_lazy_key("n", "<leader>gb", "<cmd>BlameToggle virtual<cr>", { desc = "Toggle git blame" }),
}

return M
