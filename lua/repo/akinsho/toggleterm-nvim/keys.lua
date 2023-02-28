local map_lazy = require("cfg.keymap").map_lazy

local M = {
    map_lazy(
        "n",
        "<leader>tt",
        ":ToggleTerm<CR>",
        { silent = false, desc = "Toggle terminal" }
    ),
}

return M
