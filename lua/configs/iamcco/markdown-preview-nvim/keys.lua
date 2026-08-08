local keymap = require("api.keymap")

local M = {
  keymap.set_lazily(
    "n",
    "<leader>mp",
    ":MarkdownPreview<CR>",
    { silent = false, desc = "Markdown preview" }
  ),
}

return M
