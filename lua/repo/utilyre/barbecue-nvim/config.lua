require("barbecue").setup({
    symbols = {
        ---entry separator
        ---@type string
        separator = "", -- nf-oct-chevron_right \uf460
        -- separator = "",  -- nf-cod-chevron_right \ueab6
    },
    -- better performance
    create_autocmd = false,
    show_modified = true,
})

vim.api.nvim_create_augroup("barbecue_update_augroup", { clear = true })
vim.api.nvim_create_autocmd({
    "BufWinEnter",
    "CursorHold",
    "InsertLeave",

    -- include these if you have set `show_modified` to `true`
    "BufWritePost",
    "TextChanged",
    "TextChangedI",
}, {
    group = "barbecue_update_augroup",
    callback = function(data)
        require("barbecue.ui").update()
    end,
})
