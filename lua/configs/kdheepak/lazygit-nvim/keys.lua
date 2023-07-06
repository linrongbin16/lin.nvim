local keymap = require("builtin.utils.keymap")

local M = {
    keymap.set_lazy_key(
        "n",
        "<leader>lg",
        keymap.exec("LazyGit"),
        { desc = "Open lazygit in terminal" }
    ),
}

return M