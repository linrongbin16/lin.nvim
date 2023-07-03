local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
    set_lazy_key(
        "n",
        "<leader>ud",
        ":UndotreeToggle<CR>",
        { silent = false, desc = "Toggle undo tree" }
    ),
}

return M