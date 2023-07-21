require("trouble").setup({
    action_keys = {
        -- manually refresh
        refresh = "R",
        -- open in new tab/split/vsplit
        open_split = { "<C-w>s" },
        open_vsplit = { "<C-w>v" },
        open_tab = { "<C-w>t" },
        -- toggle between workspace/document
        toggle_mode = "t",
        -- preview
        preview = "<C-l>", -- preview the diagnostic location
        -- toggle fold of current file
        toggle_fold = { "zA", "za", "h", "l" },
    },
})