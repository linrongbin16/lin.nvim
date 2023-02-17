local map_lazy = require("conf/keymap").map_lazy

local M = {
    { "<leader>gL", nil, { "n", "v" }, desc = "Copy git link to clipboard" },
    map_lazy(
        "n",
        "<leader>gl",
        '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
        { silent = true, desc = "Open git link in browser" }
    ),
    map_lazy(
        "v",
        "<leader>gl",
        '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
        { desc = "Open git link in browser" }
    ),
}

return M
