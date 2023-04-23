local lspconfig = require("lspconfig")
local setup = require("cfg.lsp.setup")

-- Check if `ensure_installed` exist
local found_ensure_installed, ensure_installed =
    pcall(require, "repo.williamboman.mason-lspconfig-nvim.ensure_installed")

if not found_ensure_installed then
    ensure_installed = {}
end

require("mason-lspconfig").setup({ ensure_installed = ensure_installed })

-- Check if `setup_handlers` exist
local found_setup_handlers, setup_handlers =
    pcall(require, "repo.williamboman.mason-lspconfig-nvim.setup_handlers")

if not found_setup_handlers then
    setup_handlers = {
        -- use default setup for all lsp servers
        function(server)
            lspconfig[server].setup({ on_attach = setup.on_attach })
        end,
    }
end

require("mason-lspconfig").setup_handlers(setup_handlers)