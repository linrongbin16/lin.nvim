local map_lazy = require("cfg.keymap").map_lazy

local M = {
    map_lazy(
        { "n", "x" },
        "<leader>gl",
        '<cmd>lua require("gitlinker").link({action = require("gitlinker.actions").clipboard})<cr>',
        { desc = "Copy git link to clipboard" }
    ),
    map_lazy(
        { "n", "x" },
        "<leader>gL",
        '<cmd>lua require("gitlinker").link({action = require("gitlinker.actions").system})<cr>',
        { desc = "Open git link in browser" }
    ),
}

return M