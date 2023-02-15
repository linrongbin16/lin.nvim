-- { ---- Add new LSP server ----
--
-- Case-1: Add LSP server name in 'embeded_servers'.
--  LSP server is working as nvim-cmp sources, installed by mason-lspconfig.
--  Please refer to:
--      * [mason-lspconfig Available LSP servers](https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers) for more LSP servers.
--      * [nvim-lspconfig's language specific plugins](https://github.com/neovim/nvim-lspconfig/wiki/Language-specific-plugins) for more specific language plugins.
--
-- Case-2: Add extra null-ls source in 'embeded_extras'.
--  Extra null-ls source is working as null-ls sources, installed by mason-null-ls.
--  Please refer to:
--      * [mason-null-ls Available Null-ls sources](https://github.com/jay-babu/mason-null-ls.nvim#available-null-ls-sources) for more null-ls sources.
--      * [null-ls BUILTINS](https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md) for null-ls source configurations.

local null_ls = require("null-ls")
local lspconfig = require("lspconfig")

local function attach_ext(client, bufnr)
  -- attach navic to work with multiple tabs
  if client.server_capabilities["documentSymbolProvider"] then
    require("nvim-navic").attach(client, bufnr)
  end
end
