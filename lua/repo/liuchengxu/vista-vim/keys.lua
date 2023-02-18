local map_lazy = require("conf/keymap").map_lazy

local M = {
    map_lazy(
        "n",
        "<leader>vt",
        ":Vista!!<CR>",
        { silent = false, desc = "Toggle outlines(tags)" }
    ),
}

return M
