local neoconf = require("neoconf")
local close_mappings =
    { ["<ESC>"] = "Close", ["<C-[>"] = "Close", ["<C-c>"] = "Close" }
local window_min_width_value = 50
local window_min_width_rate = 0.2
local window_min_width = { window_min_width_value, window_min_width_rate }

require("dressing").setup({
    input = {
        border = neoconf.get("linopts.ui.floatwin.border"),
        min_width = window_min_width,
        win_options = {
            winblend = neoconf.get("linopts.ui.blend.winblend"),
        },
        mappings = {
            n = close_mappings,
            i = close_mappings,
        },
    },
    select = {
        nui = {
            border = {
                style = neoconf.get("linopts.ui.floatwin.border"),
            },
            win_options = {
                winblend = neoconf.get("linopts.ui.blend.winblend"),
            },
            min_width = window_min_width_value,
        },
        builtin = {
            border = neoconf.get("linopts.ui.floatwin.border"),
            min_width = window_min_width,
            win_options = {
                winblend = neoconf.get("linopts.ui.blend.winblend"),
            },
            mappings = close_mappings,
        },
    },
})
