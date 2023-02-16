local map_lazy = require("conf/keymap").map_lazy

local M = {
    map_lazy(
        "n",
        "<F2>",
        ":UndotreeToggle<CR>",
        { silent = false, desc = "Toggle undo tree" }
    ),
}

return M
