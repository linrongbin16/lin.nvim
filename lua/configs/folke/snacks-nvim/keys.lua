local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key("n", "<leader>lg", function()
    local Snacks = require("snacks")
    Snacks.lazygit.open()
  end, { desc = "Toggle lazygit" }),
}

return M
