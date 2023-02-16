local map_lazy = require("conf/keymap").map_lazy

local M = {
    "<leader>gl",
    -- map_lazy(
    --     "n",
    --     "<leader>gl",
    --     '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".copy_to_clipboard})<cr>',
    --     { silent = true, desc = "Copy git link to clipboard" }
    -- ),
    -- map_lazy(
    --     "x",
    --     "<leader>gl",
    --     '<cmd>lua require"gitlinker".get_buf_range_url("x", {action_callback = require"gitlinker.actions".copy_to_clipboard})<cr>',
    --     { silent = true, desc = "Copy git link to clipboard" }
    -- ),
    map_lazy(
        "n",
        "<leader>gL",
        '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
        { silent = true, desc = "Open git link in browser" }
    ),
    map_lazy(
        "x",
        "<leader>gL",
        '<cmd>lua require"gitlinker".get_buf_range_url("x", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
        { desc = "Open git link in browser" }
    ),
}

return M
