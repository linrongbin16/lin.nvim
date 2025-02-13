local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key("n", "<leader>bd", function()
    require("snacks").bufdelete()
  end, { desc = "Close buffer" }),
  set_lazy_key("n", "<leader>bD", function()
    require("snacks").bufdelete({ force = true })
  end, { desc = "Close buffer forcibly!" }),
}

return M
