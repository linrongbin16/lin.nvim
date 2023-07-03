vim.api.nvim_create_augroup("ccc_augroup", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
    group = "ccc_augroup",
    callback = function()
        vim.cmd("CccHighlighterEnable")
    end,
})
