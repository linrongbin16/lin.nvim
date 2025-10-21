local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
  set_lazy_key("n", "<leader>>", function()
    require("smart-splits").resize_right()
  end, { desc = "Resize window right" }),
  set_lazy_key("n", "<leader><", function()
    require("smart-splits").resize_left()
  end, { desc = "Resize window left" }),
}

return M
