local map_lazy = require("cfg.keymap").map_lazy

local M = {
    map_lazy(
        "n",
        "<leader>ut",
        ":UndotreeToggle<CR>",
        { silent = false, desc = "Toggle undo tree" }
    ),
}

return M
