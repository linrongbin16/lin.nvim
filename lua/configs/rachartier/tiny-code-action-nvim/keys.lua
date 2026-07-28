local keymap = require("util.keymap")

local M = {
  keymap.set_lazily({ "n", "x" }, "<leader>ca", function()
    require("tiny-code-action").code_action()
  end, { desc = "Code Actions" }),
}

return M
