require("gitlinker").setup({
    mappings = false,
    debug = true,
    file_log = true,
})

local map = require("conf/keymap").map

map(
    "n",
    "<leader>gl",
    '<cmd>lua require"gitlinker".get_buf_range_url({action_callback = require"gitlinker.actions".open_in_browser})<cr>',
    { desc = "Open git link in browser" }
)
map(
    "x",
    "<leader>gl",
    '<cmd>lua require"gitlinker".get_buf_range_url({action_callback = require"gitlinker.actions".open_in_browser})<cr>',
    { desc = "Open git link in browser" }
)