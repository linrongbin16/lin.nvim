-- Please copy this file to 'ensure_installed.lua' to enable it.

-- Ensure installed lsp servers.
-- This module will be passed to `require("mason-lspconfig").setup({ ensure_installed = ... })`.
-- For full available lsp servers list, please checkout:
--  * [mason-lspconfig Available LSP servers](https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers) for more LSP servers.

local ensure_installed = {
    "lua_ls", -- lua
    "vimls", -- vim
    "jsonls", -- json
}

return ensure_installed