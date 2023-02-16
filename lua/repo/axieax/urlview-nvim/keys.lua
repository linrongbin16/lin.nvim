local map_lazy = require("conf/keymap").map_lazy

local M = {
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
