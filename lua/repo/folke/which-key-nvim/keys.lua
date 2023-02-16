local map_lazy = require("conf/keymap").map_lazy

local M = {
    map_lazy(
        "n",
        "<leader>wk",
        ":WhichKey ",
        { silent = false, desc = "Open WhichKey" }
    ),
}

return M
