local keymap = require("util.keymap")

local M = {
  keymap.set_lazily(
    { "n", "x" },
    "<leader>gl",
    "<cmd>GitLink<cr>",
    { desc = "Copy git link to clipboard" }
  ),
  keymap.set_lazily(
    { "n", "x" },
    "<leader>gL",
    "<cmd>GitLink!<cr>",
    { desc = "Open git link in browser" }
  ),
}

return M
