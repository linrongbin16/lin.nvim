local glance = require("glance")
local actions = glance.actions

glance.setup({
    border = {
        enable = true,
    },
    mappings = {
        list = {
            -- open
            ["<C-s>"] = actions.jump_split,
            ["s"] = false,
            ["<C-v>"] = actions.jump_vsplit,
            ["v"] = false,
            ["<C-t>"] = actions.jump_tab,
            ["t"] = false,

            -- go to preview window
            ["<Leader>l"] = false,
            ["<C-l>"] = actions.enter_win("preview"),
        },
        preview = {
            -- quit
            ["q"] = false,
            ["Q"] = false,
            -- navigation
            ["<Tab>"] = false,
            ["<S-Tab>"] = false,

            -- go to list window
            ["<Leader>l"] = false,
            ["<C-l>"] = actions.enter_win("list"),
        },
    },
})