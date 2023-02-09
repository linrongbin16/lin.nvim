local glance = require("glance")
local actions = glance.actions

glance.setup({
    border = {
        enable = true,
    },
    list = {
        position = "left",
    },
    mappings = {
        list = {
            -- navigation
            ["j"] = actions.next, -- Bring the cursor to the next item in the list
            ["k"] = actions.previous, -- Bring the cursor to the previous item in the list
            ["<Down>"] = actions.next,
            ["<Up>"] = actions.previous,
            ["<Tab>"] = actions.next_location, -- Bring the cursor to the next location skipping groups in the list
            ["<S-Tab>"] = actions.previous_location, -- Bring the cursor to the previous location skipping groups in the list

            -- preview
            ["<C-u>"] = actions.preview_scroll_win(5),
            ["<C-d>"] = actions.preview_scroll_win(-5),
            ["v"] = false,
            ["<C-v>"] = actions.jump_vsplit,
            ["s"] = false,
            ["<C-s>"] = actions.jump_split,
            ["t"] = false,
            ["<C-t>"] = actions.jump_tab,
            ["<CR>"] = actions.jump,
            ["o"] = actions.jump,
            ["<leader>p"] = actions.enter_win("preview"), -- Focus preview window
            ["<leader>l"] = false,

            -- quit
            ["q"] = actions.close,
            ["Q"] = false,
            ["<Esc>"] = actions.close,
            ["<C-[>"] = actions.close,
            ["<C-c>"] = actions.close,
        },
        preview = {
            -- quit
            ["q"] = actions.close,
            ["Q"] = false,
            ["<ESC>"] = actions.close,
            ["<C-[>"] = actions.close,
            ["<C-c>"] = actions.close,

            -- navigation
            ["<Tab>"] = actions.next_location,
            ["<S-Tab>"] = actions.previous_location,

            -- go back from preview
            ["<leader>p"] = actions.enter_win("list"), -- Focus list window
            ["<leader>l"] = false,
        },
    },
})
