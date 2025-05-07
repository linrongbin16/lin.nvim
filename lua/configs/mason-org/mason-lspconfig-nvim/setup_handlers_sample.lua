-- Please copy this file to 'setup_handlers.lua' to enable it.

-- Configure lsp server setup handlers.
-- This module will be passed to `require("mason-lspconfig").setup_handlers(setup_handlers)`.
-- For automatic lsp server setup, please refer to:
--  * [mason-lspconfig's Automatic server setup](https://github.com/mason-org/mason-lspconfig.nvim#automatic-server-setup-advanced-feature).

local lspconfig = require("lspconfig")

local setup_handlers = {
  -- Please uncomment below lines to enable them.

  -- lua_ls = function()
  --     lspconfig["lua_ls"].setup({
  --         settings = {
  --             Lua = {
  --                 workspace = {
  --                     checkThirdParty = false,
  --                 },
  --             },
  --         },
  --     })
  -- end,
  -- tsserver = function()
  --     lspconfig["tsserver"].setup({})
  -- end,
  -- clangd = function()
  --   local capabilities = vim.lsp.protocol.make_client_capabilities()
  --   capabilities = vim.tbl_deep_extend("force", capabilities, {
  --     offsetEncoding = { "utf-16" },
  --     general = {
  --       positionEncodings = { "utf-16" },
  --     },
  --   })
  --   lspconfig["clangd"].setup({
  --     capabilities = capabilities,
  --   })
  -- end,
  -- ["rust_analyzer"] = function()
  --   local capabilities = vim.lsp.protocol.make_client_capabilities()
  --   capabilities = vim.tbl_deep_extend("force", capabilities, {
  --     offsetEncoding = { "utf-16" },
  --     general = {
  --       positionEncodings = { "utf-16" },
  --     },
  --   })
  --   lspconfig["rust_analyzer"].setup({
  --     capabilities = capabilities,
  --   })
  -- end,
}

return setup_handlers
