local map_lazy = require("conf/keymap").map_lazy

local M = {
    map_lazy(
        { "n", "x" },
        "<leader>gl",
        '<cmd>lua require"gitlinker".get_buf_range_url({action_callback = require"gitlinker.actions".open_in_browser})<cr>',
        { silent = true, desc = "Open git link in browser" }
    ),
}

return M