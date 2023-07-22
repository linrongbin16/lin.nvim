local constants = require("builtin.utils.constants")

require("aerial").setup({
    layout = {
        max_width = {
            constants.ui.layout.sidebar.max,
            constants.ui.layout.sidebar.scale,
        },
        width = nil,
        min_width = constants.ui.layout.sidebar.min,
    },
    keymaps = {
        ["<C-w>v"] = "actions.jump_vsplit",
        ["<C-v>"] = "false",
        ["<C-w>s"] = "actions.jump_split",
        ["<C-s>"] = "false",
        ["W"] = "actions.tree_close_recursive",
        ["E"] = "actions.tree_open_recursive",
    },
})