local map_lazy = require("conf/keymap").map_lazy

local M = {
    map_lazy(
        "n",
        "<F10>",
        ":ToggleTerm<CR>",
        { silent = false, desc = "Toggle terminal" }
    ),
}

return M
