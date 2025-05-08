-- Please copy this file to 'setup_handlers.lua' to enable it.

-- Configure lsp server setup handlers.
-- This module will be passed to `vim.lsp.config`, and lsp servers will be automatically started by mason-lspconfig.

local setup_handlers = {
  -- Please uncomment below lines to enable them.

  -- clangd = {
  --   capabilities = {
  --     offsetEncoding = { "utf-16" },
  --     general = {
  --       positionEncodings = { "utf-16" },
  --     },
  --   },
  -- },
  -- flow = {},
  -- lua_ls = {
  --   settings = {
  --     Lua = {
  --       workspace = {
  --         checkThirdParty = false,
  --       },
  --     },
  --   },
  -- },
  -- ["rust_analyzer"] = {
  --   capabilities = {
  --     offsetEncoding = { "utf-16" },
  --     general = {
  --       positionEncodings = { "utf-16" },
  --     },
  --   },
  -- },
  -- tsserver = {},
}

return setup_handlers
