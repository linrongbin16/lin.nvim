local map_lazy = require("conf/keymap").map_lazy

local M = {
    map_lazy(
        { "n", "x" },
        "<leader>gl",
        '<cmd>lua require"gitlinker".link()<cr>',
        { silent = true, desc = "Open git link in browser" }
    ),
}

return M