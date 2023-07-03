local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
    set_lazy_key(
        "n",
        "<leader>mp",
        ":MarkdownPreview<CR>",
        { silent = false, desc = "Markdown preview" }
    ),
}

return M