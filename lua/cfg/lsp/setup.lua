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

local function lsp_on_attach(client, bufnr)
    -- attach navic to work with multiple tabs
    if client.server_capabilities["documentSymbolProvider"] then
        require("nvim-navic").attach(client, bufnr)
    end
    -- async code format
    require("lsp-format").on_attach(client)
end

-- { mason's config
local embeded_servers = {}
local embeded_servers_setups = {
    -- default setup
    function(server)
        lspconfig[server].setup({ on_attach = lsp_on_attach })
    end,
    -- specific setup
    tsserver = function()
        lspconfig["tsserver"].setup({
            on_attach = lsp_on_attach,
            root_dir = function(fname)
                -- disable tsserver when detect flow
                return lspconfig.util.root_pattern("tsconfig.json")(fname)
                    or not lspconfig.util.root_pattern(".flowconfig")(fname)
                        and lspconfig.util.root_pattern(
                            "package.json",
                            "jsconfig.json",
                            ".git"
                        )(fname)
            end,
        })
    end,
    -- clangd = function()
    --   require("clangd_extensions").setup({
    --     on_attach = function(client, bufnr)
    --       attach_ext(client, bufnr)
    --     end,
    --   })
    -- end,
    -- ["rust_analyzer"] = function()
    --   require("rust-tools").setup({
    --     on_attach = function(client, bufnr)
    --       attach_ext(client, bufnr)
    --     end,
    --   })
    -- end,
}
-- } mason's config

-- { null-ls's config
local embeded_nullls = {}
local embeded_nullls_setups = {
    -- default setup
    function(source, methods)
        require("mason-null-ls.automatic_setup")(source, methods)
    end,
    -- specific setup
    -- stylua = function(source, methods)
    --   null_ls.register(null_ls.builtins.formatting.stylua)
    -- end,
}
-- } null-ls's config

-- { lspconfig's setup

local embeded_lspconfig_setups = {
    ["flow"] = { on_attach = lsp_on_attach },
}

-- } lspconfig's setup

-- }

-- { ---- The real config work goes here ----

-- Setup mason-lspconfig
require("mason-lspconfig").setup({ ensure_installed = embeded_servers })
require("mason-lspconfig").setup_handlers(embeded_servers_setups)

-- Setup mason-null-ls and null-ls configs
require("mason-null-ls").setup({
    ensure_installed = embeded_nullls,
})
require("mason-null-ls").setup_handlers(embeded_nullls_setups)
null_ls.setup({ on_attach = lsp_on_attach })

-- Setup nvim-lspconfig
for name, cfg in pairs(embeded_lspconfig_setups) do
    lspconfig[name].setup(cfg)
end

-- }