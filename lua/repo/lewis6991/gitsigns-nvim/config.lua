require("gitsigns").setup({
    signs = {
        changedelete = { text = "~_" },
    },
    current_line_blame_opts = {
        delay = 200,
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
        end, {
            expr = true,
            buffer = bufnr,
            desc = "Go to next git hunk",
        })

        map("n", "[c", function()
            if vim.wo.diff then
                return "[c"
            end
            vim.schedule(function()
                gs.prev_hunk()
            end)
            return "<Ignore>"
        end, {
            expr = true,
            buffer = bufnr,
            desc = "Go to previous git hunk",
        })
    end,
})