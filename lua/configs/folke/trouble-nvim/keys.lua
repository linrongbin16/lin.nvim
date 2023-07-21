local keymap = require("builtin.utils.keymap")

local M = {
    keymap.set_lazy_key(
        "n",
        "<leader>tb",
        keymap.exec("TroubleToggle"),
        { desc = "Toggle trouble (diagnostics)" }
    ),
}

return M