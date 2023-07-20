require("barbecue").setup({
    -- attach_navic = false, -- prevent auto attach, do it manually
    symbols = {
        separator = "", -- nf-oct-chevron_right \uf460
    },
    -- performance
    create_autocmd = false,
    show_modified = true,
})

vim.api.nvim_create_augroup("barbecue_augroup", { clear = true })
vim.api.nvim_create_autocmd({
    "WinScrolled",
    "WinResized",
    "BufWinEnter",
    "CursorHold",
    "InsertLeave",
    -- include these if you have set `show_modified` to `true`
    "BufModifiedSet",
}, {
    group = "barbecue_augroup",
    callback = function(data)
        require("barbecue.ui").update()
    end,
})