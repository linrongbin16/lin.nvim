local map_lazy = require("conf/keymap").map_lazy

local M = {
    map_lazy(
        { "n", "x" },
        "<leader>gl",
        '<cmd>lua require("gitlinker").link()<cr>',
        { desc = "Open git link in browser" }
    ),
}

return M