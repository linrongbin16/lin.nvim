local glance = require("glance")
local actions = glance.actions

glance.setup({
    border = {
        enable = true,
    },
    mappings = {
        list = {
            ["<C-x>"] = actions.jump_split,
            ["s"] = false,
            ["<C-v>"] = actions.jump_vsplit,
            ["v"] = false,
            ["<C-t>"] = actions.jump_tab,
            ["t"] = false,
        },
        preview = {
            -- quit
            ["q"] = false,
            ["Q"] = false,
            -- navigation
            ["<Tab>"] = false,
            ["<S-Tab>"] = false,
        },
    },
})