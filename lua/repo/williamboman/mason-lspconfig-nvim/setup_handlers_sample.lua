-- Configure lsp server setup handlers.
-- This module will be passed to `require("mason-lspconfig").setup_handlers(setup_handlers)`.
--
-- For automatic lsp server setup, please refer to:
--  * [mason-lspconfig's Automatic server setup](https://github.com/williamboman/mason-lspconfig.nvim#automatic-server-setup-advanced-feature).

local lspconfig = require("lspconfig")
local setup = require("cfg.lsp.setup")

local setup_handlers = {
    -- default setup
    function(server)
        lspconfig[server].setup({
            on_attach = setup.on_attach,
        })
    end,

    -- specific setup
    tsserver = function()
        lspconfig["tsserver"].setup({
            on_attach = setup.on_attach,
        })
    end,
    clangd = function()
        require("clangd_extensions").setup({
            on_attach = setup.on_attach,
        })
    end,
    ["rust_analyzer"] = function()
        require("rust-tools").setup({
            on_attach = setup.on_attach,
        })
    end,
}

return setup_handlers