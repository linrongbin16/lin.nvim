local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
    set_lazy_key(
        "n",
        "<leader>ol",
        ":Vista!!<CR>",
        { silent = false, desc = "Toggle structure outlines(tags)" }
    ),
}

return M