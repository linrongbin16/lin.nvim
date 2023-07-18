local keymap = require("builtin.utils.keymap")

local M = {
    keymap.set_lazy_key(
        "n",
        "<leader>as",
        keymap.exec("ASToggle"),
        { desc = "Toggle auto-save" }
    ),
}

return M