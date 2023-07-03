local constants = require("builtin.utils.constants")
local close_mappings =
    { ["<ESC>"] = "Close", ["<C-[>"] = "Close", ["<C-c>"] = "Close" }
local window_transparency = 10
local window_min_width_value = 50
local window_min_width_rate = 0.2
local window_min_width = { window_min_width_value, window_min_width_rate }

require("dressing").setup({
    input = {
        border = constants.ui.border,
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
                style = constants.ui.border,
            },
            win_options = {
                winblend = window_transparency,
            },
            min_width = window_min_width_value,
        },
        builtin = {
            border = constants.ui.border,
            min_width = window_min_width,
            win_options = {
                winblend = window_transparency,
            },
            mappings = close_mappings,
        },
    },
})