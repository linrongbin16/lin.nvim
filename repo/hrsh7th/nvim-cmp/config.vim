" auto format on save
augroup LinNvimCmpAuGroup
    autocmd!
    autocmd BufWritePre * lua vim.lsp.buf.format{async = true}
augroup END
