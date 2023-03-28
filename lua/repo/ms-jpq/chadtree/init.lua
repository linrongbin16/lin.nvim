local function get_view_width()
    local rate = 0.25
    local min_w = 25
    local max_w = 80
    local editor_w = vim.o.columns
    local tree_w = math.floor(editor_w * rate)
    tree_w = vim.fn.min({ max_w, tree_w })
    tree_w = vim.fn.max({ min_w, tree_w })
    return tree_w
end

local chadtree_settings = {
    ["options.show_hidden"] = true,
    ["ignore.name_exact"] = {},
    ["view.width"] = get_view_width(),
    ["keymap"] = {
        -- adjust explorer width
        ["bigger"] = { "<Leader>." },
        ["smaller"] = { "<Leader>," },

        -- refresh
        ["refresh"] = { "R" },

        -- open node
        ["primary"] = { "<Enter>", "l", "o", "<2-leftmouse>" },
        -- close node
        ["collapse"] = { "h" },
        ["secondary"] = {},

        -- open in new tab, vsplit, split
        ["tertiary"] = { "<C-t>" },
        ["v_split"] = { "<C-v>" },
        ["h_split"] = { "<C-x>" },

        -- open in system
        ["open_sys"] = { "s" },
    },
}

vim.api.nvim_set_var("chadtree_settings", chadtree_settings)