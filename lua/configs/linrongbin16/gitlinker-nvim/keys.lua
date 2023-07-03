local set_lazy_key = require("builtin.utils.keymap").set_lazy_key

local M = {
    set_lazy_key(
        { "n", "x" },
        "<leader>gl",
        '<cmd>lua require("gitlinker").link({action = require("gitlinker.actions").clipboard})<cr>',
        { desc = "Copy git link to clipboard" }
    ),
    set_lazy_key(
        { "n", "x" },
        "<leader>gL",
        '<cmd>lua require("gitlinker").link({action = require("gitlinker.actions").system})<cr>',
        { desc = "Open git link in browser" }
    ),
}

return M