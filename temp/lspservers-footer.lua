-- }

-- { ---- The real config work goes here ----

-- Setup mason-lspconfig
require("mason-lspconfig").setup({ ensure_installed = embeded_servers })
require("mason-lspconfig").setup_handlers(embeded_servers_setups)

-- Setup mason-null-ls and null-ls configs
require("mason-null-ls").setup({ ensure_installed = embeded_nullls })
require("mason-null-ls").setup_handlers(embeded_nullls_setups)
null_ls.setup()

-- Setup flow here :)
lspconfig["flow"].setup({
  on_attach = function(client, bufnr)
    attach_ext(client, bufnr)
  end,
})

-- }
