local keymap = require("util.keymap")

local M = {
  keymap.set_lazily("n", "<leader>wk", ":WhichKey ", { silent = false, desc = "Open WhichKey" }),
}

return M
