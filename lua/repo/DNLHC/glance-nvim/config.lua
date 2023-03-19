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
            ["<leader>,"] = actions.enter_win("preview"),
            ["<leader>."] = actions.enter_win("preview"),
            ["<leader>l"] = false,
        },
        preview = {
            -- quit
            ["q"] = false,
            ["Q"] = false,
            -- navigation
            ["<Tab>"] = false,
            ["<S-Tab>"] = false,
            ["<leader>,"] = actions.enter_win("list"),
            ["<leader>."] = actions.enter_win("list"),
            ["<leader>l"] = false,
        },
    },
})