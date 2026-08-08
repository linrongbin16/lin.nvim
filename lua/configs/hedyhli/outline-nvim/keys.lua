local keymap = require("api.keymap")

local M = {
  keymap.set_lazily("n", "<leader>ol", "<cmd>Outline<cr>", { desc = "Toggle outline" }),
}

return M
