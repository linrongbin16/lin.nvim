local constants = require("builtin.utils.constants")
local layout = require("builtin.utils.layout")

local chadtree_settings = {
    ["options.show_hidden"] = true,
    ["ignore.name_exact"] = {},
    ["view.width"] = layout.editor.width(
        constants.ui.layout.sidebar.scale,
        constants.ui.layout.sidebar.min,
        constants.ui.layout.sidebar.max
    ),
    ["keymap"] = {
        -- adjust explorer width
        ["bigger"] = { "<Leader>." },
        ["smaller"] = { "<Leader>," },

        -- refresh
        ["refresh"] = { "R" },

        -- open node
        ["primary"] = { "<Enter>", "l", "o", "<2-leftmouse>" },
        -- close node
        ["collapse"] = { "h" },
        ["secondary"] = {},

        -- open in new tab, vsplit, split
        ["tertiary"] = { "<C-w>t" },
        ["v_split"] = { "<C-w>v" },
        ["h_split"] = { "<C-w>s" },

        -- open in system
        ["open_sys"] = { "s" },
    },
}

vim.api.nvim_set_var("chadtree_settings", chadtree_settings)