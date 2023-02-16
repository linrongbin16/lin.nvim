local map_lazy = require("conf/keymap").map_lazy

local M = {
    map_lazy(
        "n",
        "<leader>ms",
        ":Mason<CR>",
        { silent = false, desc = "Open Mason" }
    ),
}

return M
