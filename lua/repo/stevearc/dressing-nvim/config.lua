local const = require("cfg.const")
local close_mappings =
    { ["<ESC>"] = "Close", ["<C-[>"] = "Close", ["<C-c>"] = "Close" }
local window_transparency = 0
local window_min_width = { 50, 0.2 }

require("dressing").setup({
    input = {
        border = const.ui.border,
        min_width = window_min_width,
        win_options = {
            winblend = window_transparency,
        },
        mappings = {
            n = close_mappings,
            i = close_mappings,
        },
    },
    select = {
        nui = {
            border = {
                style = const.ui.border,
            },
        },
        builtin = {
            border = const.ui.border,
            min_width = window_min_width,
            win_options = {
                winblend = window_transparency,
            },
            mappings = close_mappings,
        },
    },
})
