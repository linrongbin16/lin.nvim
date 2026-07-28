local keymap = require("util.keymap")

local M = {
  keymap.set_lazily("n", "<leader>ol", "<cmd>Outline<cr>", { desc = "Toggle outline" }),
}

return M
