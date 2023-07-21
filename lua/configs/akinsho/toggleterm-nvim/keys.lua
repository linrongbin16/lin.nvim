local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
    set_lazy_key(
        "n",
        "<leader>tm",
        ":ToggleTerm<CR>",
        { silent = false, desc = "Toggle terminal" }
    ),
}

return M