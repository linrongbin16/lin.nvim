local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
    set_lazy_key(
        "n",
        "<leader>tr",
        "<cmd>Neotree toggle reveal<cr>",
        { silent = false, desc = "Toggle file explorer" }
    ),
}

return M