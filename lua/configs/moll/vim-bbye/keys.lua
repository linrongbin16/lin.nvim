local keymap = require("util.keymap")

local M = {
  keymap.set_lazily("n", "<leader>bd", "<cmd>Bdelete<cr>", { desc = "Close buffer" }),
  keymap.set_lazily("n", "<leader>bD", "<cmd>Bdelete!<cr>", { desc = "Close buffer forcibly!" }),
}

return M
