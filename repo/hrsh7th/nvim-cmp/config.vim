" auto format on save
augroup nvim_cmp_augroup
    autocmd!
    autocmd BufWritePre * lua vim.lsp.buf.format({async = false})
augroup END
