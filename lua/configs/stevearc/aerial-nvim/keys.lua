local keymap = require("builtin.utils.keymap")

local M = {
    keymap.set_lazy_key(
        "n",
        "<leader>ar",
        ":AerialToggle!<CR>",
        { desc = "Toggle structure outlines (aerial)" }
    ),
}

return M