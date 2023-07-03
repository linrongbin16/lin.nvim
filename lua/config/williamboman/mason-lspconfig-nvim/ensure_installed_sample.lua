-- Ensure installed lsp servers.
-- This module will be passed to `require("mason-lspconfig").setup({ ensure_installed = ... })`.
--
-- For full available lsp servers list, please refer to:
--  * [mason-lspconfig Available LSP servers](https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers) for more LSP servers.

local ensure_installed = {
    "clangd", -- c/c++
    "pyright", -- python
    "lua_ls", -- lua
    "vimls", -- vim
    "tsserver", -- js/ts
    "bashls", -- bash
    "ruby_ls", -- ruby
    "jsonls", -- json
    "cssls", -- css
    "html", -- html
}

return ensure_installed