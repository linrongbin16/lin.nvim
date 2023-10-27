local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
    set_lazy_key(
        "n",
        "<leader>bd",
        "<cmd>Bdelete<cr>",
        { desc = "Close buffer" }
    ),
    set_lazy_key(
        "n",
        "<leader>bD",
        "<cmd>Bdelete!<cr>",
        { desc = "Close buffer forcibly!" }
    ),
}

return M
