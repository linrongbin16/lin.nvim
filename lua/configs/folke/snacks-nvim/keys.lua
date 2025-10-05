local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key("n", "<leader>lg", function()
    local Snacks = require("snacks")
    Snacks.lazygit.open()
  end, { desc = "Toggle lazygit" }),
  set_lazy_key("n", "<leader>bd", function()
    local Snacks = require("snacks")
    Snacks.bufdelete()
  end, { desc = "Close buffer" }),
  set_lazy_key("n", "<leader>bD", function()
    local Snacks = require("snacks")
    Snacks.bufdelete({ force = true })
  end, { desc = "Close buffer forcibly!" }),
}

return M
