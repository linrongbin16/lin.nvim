local lspconfig = require("lspconfig")
local setup = require("cfg.lsp.setup")

-- Check if `cfg.lsp.mason-lspconfig.ensure_installed` exist
local found_ensure_installed, ensure_installed =
    pcall(require, "cfg.lsp.mason-lspconfig.ensure_installed")

if not found_ensure_installed then
    ensure_installed = {}
end

require("mason-lspconfig").setup({ ensure_installed = ensure_installed })

-- Check if `user.mason-lspconfig.setup_handlers` exist
local found_setup_handlers, setup_handlers =
    pcall(require, "user.mason-lspconfig.setup_handlers")

if not found_setup_handlers then
    setup_handlers = {
        -- use default setup for all lsp servers
        function(server)
            lspconfig[server].setup({ on_attach = setup.on_attach })
        end,
    }
end

require("mason-lspconfig").setup_handlers(setup_handlers)