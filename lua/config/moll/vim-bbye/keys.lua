local keymap = require("builtin.utils.keymap")

local M = {
    keymap.set_lazy_key(
        "n",
        "<leader>bd",
        keymap.exec("Bdelete"),
        { desc = "Close buffer" }
    ),
    keymap.set_lazy_key(
        "n",
        "<leader>bD",
        keymap.exec("Bdelete!"),
        { desc = "Close buffer forcibly!" }
    ),
}

return M