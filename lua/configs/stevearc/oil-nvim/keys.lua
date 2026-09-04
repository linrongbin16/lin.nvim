local keymap = require("api.keymap")

local M = {
  keymap.set_lazily("n", "<leader>oi", "<cmd>Oil<cr>", { desc = "Open oil file explorer" }),
}

return M
