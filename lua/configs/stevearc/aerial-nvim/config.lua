local neoconf = require("neoconf")

require("aerial").setup({
    layout = {
        max_width = {
            neoconf.get("linopts.ui.sidebar.max"),
            neoconf.get("linopts.ui.sidebar.scale"),
        },
        width = nil,
        min_width = neoconf.get("linopts.ui.sidebar.min"),
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
