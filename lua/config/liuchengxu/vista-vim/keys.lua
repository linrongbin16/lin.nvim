local map_lazy = require("cfg.keymap").map_lazy

local M = {
    map_lazy(
        "n",
        "<leader>ol",
        ":Vista!!<CR>",
        { silent = false, desc = "Toggle structure outlines(tags)" }
    ),
}

return M