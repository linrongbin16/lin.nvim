require("lspformatter").setup({ null_ls_only = false })

vim.api.nvim_create_augroup("lspformatter_augroup", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
    group = "lspformatter_augroup",
    callback = function(args)
        -- async code format
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf
        require("lspformatter").on_attach(client, bufnr)
    end,
})