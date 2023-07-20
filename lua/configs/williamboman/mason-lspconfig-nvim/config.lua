local lspconfig = require("lspconfig")

local ensure_installed_ok, ensure_installed =
    pcall(require, "configs.williamboman.mason-lspconfig-nvim.ensure_installed")

if not ensure_installed_ok then
    ensure_installed = {}
end

require("mason-lspconfig").setup({ ensure_installed = ensure_installed })

local setup_handlers_ok, setup_handlers =
    pcall(require, "configs.williamboman.mason-lspconfig-nvim.setup_handlers")

if not setup_handlers_ok then
    setup_handlers = {
        -- use default setup for all lsp servers
        function(server)
            lspconfig[server].setup({})
        end,
    }
end

require("mason-lspconfig").setup_handlers(setup_handlers)