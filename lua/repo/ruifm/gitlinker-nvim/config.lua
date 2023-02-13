require("gitlinker").setup({
    mappings = "<leader>gl",
})

local map = require("conf/keymap").map

map(
    "n",
    "<leader>gL",
    '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
    { silent = true, desc = "Open git link in browser" }
)
map(
    "x",
    "<leader>gL",
    '<cmd>lua require"gitlinker".get_buf_range_url("x", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
    { desc = "Open git link in browser" }
)
