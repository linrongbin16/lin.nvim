-- Please copy this file to 'setup_handlers.lua' to enable it.

-- Configure lsp server setup handlers.
-- This module will be passed to `require("mason-lspconfig").setup_handlers(setup_handlers)`.
-- For automatic lsp server setup, please refer to:
--  * [mason-lspconfig's Automatic server setup](https://github.com/williamboman/mason-lspconfig.nvim#automatic-server-setup-advanced-feature).

local lspconfig = require("lspconfig")

local setup_handlers = {
    jsonls = function()
        lspconfig["jsonls"].setup({
            settings = {
                json = {
                    schemas = require("schemastore").json.schemas(),
                    validate = { enable = true },
                },
            },
        })
    end,

    -- Please uncomment below lines to enable them.

    -- tsserver = function()
    --     lspconfig["tsserver"].setup({})
    -- end,
    -- clangd = function()
    --     require("clangd_extensions").setup({})
    -- end,
    -- ["rust_analyzer"] = function()
    --     require("rust-tools").setup({})
    -- end,
}

return setup_handlers