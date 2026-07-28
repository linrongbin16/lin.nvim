local keymap = require("util.keymap")

local M = {
  keymap.set_lazily(
    { "n", "x" },
    "<leader>j",
    "<cmd>HopLineAC<cr>",
    { desc = "Jump to below lines" }
  ),
  keymap.set_lazily(
    { "n", "x" },
    "<leader>k",
    "<cmd>HopLineBC<cr>",
    { desc = "Jump to above lines" }
  ),
}

return M
