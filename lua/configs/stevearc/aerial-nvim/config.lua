local constants = require("builtin.utils.constants")
local layout = require("builtin.utils.layout")

require("aerial").setup({
    layout = {
        max_width = {
            constants.ui.layout.sidebar.max,
            constants.ui.layout.sidebar.scale,
        },
        width = layout.editor.width(
            constants.ui.layout.sidebar.scale,
            constants.ui.layout.sidebar.min,
            constants.ui.layout.sidebar.max
        ),
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
