local constants = require("conf/constants")
local close_mappings = { ["<ESC>"] = "Close", ["<C-[>"] = "Close", ["<C-c>"] = "Close" }
local window_transparency = 0
local window_width = 55

require("dressing").setup({
    input = {
        border = constants.ui.border,
        min_width = { window_width, 0.2 },
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
        },
        builtin = {
            border = constants.ui.border,
            win_options = {
                winblend = window_transparency,
            },
            mappings = close_mappings,
        },
    },
})
