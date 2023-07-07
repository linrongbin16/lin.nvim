local keymap = require("builtin.utils.keymap")

local M = {
    keymap.set_lazy_key(
        "n",
        "<leader>rg",
        "<cmd>RnvimrToggle<cr>",
        { desc = "Open ranger file manager in terminal" }
    ),
}

return M