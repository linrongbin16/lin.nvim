local glance = require("glance")
local actions = glance.actions

glance.setup({
    border = {
        enable = true,
    },
    mappings = {
        list = {
            ["<C-s>"] = actions.jump_split,
            ["s"] = false,
            ["<C-v>"] = actions.jump_vsplit,
            ["v"] = false,
            ["<C-t>"] = actions.jump_tab,
            ["t"] = false,
            -- quit
            ["Q"] = false,
        },
        preview = {
            -- quit
            ["q"] = actions.close,
            ["Q"] = false,
            -- navigation
            ["<Tab>"] = false,
            ["<S-Tab>"] = false,
        },
    },
})