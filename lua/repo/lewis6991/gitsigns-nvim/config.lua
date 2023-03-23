require("gitsigns").setup({
    signs = {
        -- add = { text = "+" }, -- vim-gitgutter style signs
        -- change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~_" },
        untracked = { text = "┆" },
    },
    current_line_blame_opts = {
        delay = 300,
    },
    on_attach = function(bufnr)
        local map = require("cfg.keymap").map
        local gs = package.loaded.gitsigns

        -- Navigation
        map("n", "]c", function()
            if vim.wo.diff then
                return "]c"
            end
            vim.schedule(function()
                gs.next_hunk()
            end)
            return "<Ignore>"
        end, { expr = true, buffer = bufnr })

        map("n", "[c", function()
            if vim.wo.diff then
                return "[c"
            end
            vim.schedule(function()
                gs.prev_hunk()
            end)
            return "<Ignore>"
        end, { expr = true, buffer = bufnr })
    end,
})
