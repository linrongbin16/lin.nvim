local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
    set_lazy_key(
        "n",
        "<leader>wk",
        ":WhichKey ",
        { silent = false, desc = "Open WhichKey" }
    ),
}

return M