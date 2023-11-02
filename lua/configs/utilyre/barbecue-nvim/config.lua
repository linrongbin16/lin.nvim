require("barbecue").setup({
    symbols = {
        separator = "", -- nf-oct-chevron_right \uf460
    },
    -- performance
    create_autocmd = false,
})

vim.api.nvim_create_augroup("barbecue_augroup", { clear = true })
vim.api.nvim_create_autocmd({
    "WinScrolled",
    "WinResized",
    "BufWinEnter",
    "CursorHold",
    "InsertLeave",
}, {
    group = "barbecue_augroup",
    callback = function()
        require("barbecue.ui").update()
    end,
})
