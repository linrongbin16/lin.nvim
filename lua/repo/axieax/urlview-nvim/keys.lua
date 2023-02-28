local map_lazy = require("cfg.keymap").map_lazy

local M = {
    "]u",
    "[u",
    map_lazy(
        "n",
        "<leader>ub",
        "<cmd>UrlView<cr>",
        { desc = "View buffer urls" }
    ),
    map_lazy(
        "n",
        "<leader>up",
        "<cmd>UrlView lazy<cr>",
        { desc = "View plugin urls" }
    ),
}

return M
