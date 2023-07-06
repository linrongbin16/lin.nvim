local keymap = require("builtin.utils.keymap")

local M = {
    keymap.set_lazy_key(
        "n",
        "<leader>lf",
        keymap.exec("Lf"),
        { desc = "Open lf file manager in terminal" }
    ),
}

return M