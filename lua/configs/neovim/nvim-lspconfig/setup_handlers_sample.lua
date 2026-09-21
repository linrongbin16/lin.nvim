-- Please copy this file to 'setup_handlers.lua' to enable it.

-- Configure lsp server setup handlers.
-- This module will be passed to `vim.lsp.config`, only use this if mason cannot work.

local setup_handlers = {
  clangd = {
    cmd = { "clangd", "--background-index" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  },
}

return setup_handlers
