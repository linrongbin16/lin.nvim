local keymap = require("api.keymap")

local M = {
  keymap.set_lazily("n", "<leader>mo", "<cmd>MoPreview<cr>", { desc = "Open markdown previewer" }),
  keymap.set_lazily(
    "n",
    "<leader>mc",
    "<cmd>MoPreview --close<cr>",
    { desc = "Close markdown previewer" }
  ),
}

return M
