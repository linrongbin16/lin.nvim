local keymap = require("util.keymap")

local M = {
  keymap.set_lazily(
    "n",
    "<leader>gp",
    "<cmd>lua require('github-preview').fns.toggle()<cr>",
    { desc = "Toggle markdown github previewer" }
  ),
}

return M
