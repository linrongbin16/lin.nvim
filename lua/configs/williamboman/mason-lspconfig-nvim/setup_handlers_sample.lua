-- Please copy this file to 'setup_handlers.lua' to enable it.

-- Configure lsp server setup handlers.
-- This module will be passed to `require("mason-lspconfig").setup_handlers(setup_handlers)`.
-- For automatic lsp server setup, please refer to:
--  * [mason-lspconfig's Automatic server setup](https://github.com/williamboman/mason-lspconfig.nvim#automatic-server-setup-advanced-feature).

local lspconfig = require("lspconfig")
local lsp_setup_helper = require("builtin.utils.lsp_setup_helper")

local setup_handlers = {
    -- Default setup.
    function(server)
        lspconfig[server].setup({
            on_attach = lsp_setup_helper.on_attach,
        })
    end,

    -- Custom setup.
    jsonls = function()
        lspconfig["jsonls"].setup({
            settings = {
                json = {
                    schemas = require("schemastore").json.schemas(),
                    validate = { enable = true },
                },
            },
            on_attach = lsp_setup_helper.on_attach,
        })
    end,

    -- Please uncomment below lines to enable them.

    -- tsserver = function()
    --     lspconfig["tsserver"].setup({
    --         on_attach = lsp_setup_helper.on_attach,
    --     })
    -- end,
    -- clangd = function()
    --     require("clangd_extensions").setup({
    --         on_attach = lsp_setup_helper.on_attach,
    --     })
    -- end,
    -- ["rust_analyzer"] = function()
    --     require("rust-tools").setup({
    --         on_attach = lsp_setup_helper.on_attach,
    --     })
    -- end,
}

return setup_handlers