require("aerial").setup({
    layout = {
        max_width = { 40, 0.2 },
        width = 40,
        min_width = 10,
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