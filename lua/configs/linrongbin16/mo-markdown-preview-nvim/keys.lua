local keymap = require("api.keymap")

local M = {
  keymap.set_lazily("n", "<leader>mo", "<cmd>MoOpen<cr>", { desc = "Open markdown previewer" }),
  keymap.set_lazily("n", "<leader>mc", "<cmd>MoClose<cr>", { desc = "Close markdown previewer" }),
}

return M
