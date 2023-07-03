local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
    set_lazy_key(
        "n",
        "<leader>ms",
        ":Mason<CR>",
        { silent = false, desc = "Open Mason" }
    ),
}

return M