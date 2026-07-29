local keymap = require("api.keymap")

local M = {
  keymap.set_lazily("n", "<leader>>", function()
    require("smart-splits").resize_right()
  end, { desc = "Resize window right" }),
  keymap.set_lazily("n", "<leader><", function()
    require("smart-splits").resize_left()
  end, { desc = "Resize window left" }),
}

return M
