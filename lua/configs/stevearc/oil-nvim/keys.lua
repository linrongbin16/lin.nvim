local keymap = require("api.keymap")

local M = {
  keymap.set_lazily("n", "<leader>fe", "<cmd>Oil<cr>", { desc = "Open oil file explorer" }),
}

return M
