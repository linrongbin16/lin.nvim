local glance = require("glance")
local actions = glance.actions

glance.setup({
    border = {
        enable = true,
    },
    mappings = {
        list = {
            -- open
            ["<C-w>s"] = actions.jump_split,
            ["s"] = false,
            ["<C-w>v"] = actions.jump_vsplit,
            ["v"] = false,
            ["<C-w>t"] = actions.jump_tab,
            ["t"] = false,

            -- go to preview window
            ["<Leader>l"] = false,
            ["<C-l>"] = actions.enter_win("preview"),
        },
        preview = {
            -- navigation
            ["<Tab>"] = false,
            ["<S-Tab>"] = false,

            -- go to list window
            ["<Leader>l"] = false,
            ["<C-l>"] = actions.enter_win("list"),
        },
    },
})