local keymap = require("builtin.utils.keymap")

local M = {
    keymap.set_lazy_key(
        "n",
        "<leader>lg",
        "<cmd>LazyGit<cr>",
        { desc = "Open lazygit in terminal" }
    ),
}

return M