local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
    set_lazy_key(
        "n",
        "<leader>nt",
        ":NvimTreeFindFileToggle<CR>",
        { silent = false, desc = "Toggle nvim-tree file explorer" }
    ),
}

return M