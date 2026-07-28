local keymap = require("util.keymap")

local M = {
  keymap.set_lazily("n", "<leader>ms", ":Mason<CR>", { silent = false, desc = "Open Mason" }),
}

return M
