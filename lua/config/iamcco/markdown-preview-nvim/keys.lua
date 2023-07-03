local map_lazy = require("cfg.keymap").map_lazy

local M = {
    map_lazy(
        "n",
        "<leader>mp",
        ":MarkdownPreview<CR>",
        { silent = false, desc = "Markdown preview" }
    ),
}

return M
