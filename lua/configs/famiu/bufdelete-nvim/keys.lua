local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key("n", "<leader>bd", function()
    require("bufdelete").bufdelete(0)
  end, { desc = "Close buffer" }),
  set_lazy_key("n", "<leader>bD", function()
    require("bufdelete").bufdelete(0, true)
  end, { desc = "Close buffer forcibly!" }),
}

return M
