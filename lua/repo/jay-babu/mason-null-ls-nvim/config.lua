-- Check if `lsp.mason-null-ls.ensure_installed` exist
local found_ensure_installed, ensure_installed =
    pcall(require, "lsp.mason-null-ls.ensure_installed")

if not found_ensure_installed then
    ensure_installed = {}
end

require("mason-null-ls").setup({ ensure_installed = ensure_installed })

-- Check if `lsp.mason-null-ls.setup_handlers` exist
local found_setup_handlers, setup_handlers =
    pcall(require, "lsp.mason-null-ls.setup_handlers")

if not found_setup_handlers then
    setup_handlers = {
        -- use default setup for all sources
        function(source, methods)
            require("mason-null-ls.automatic_setup")(source, methods)
        end,
    }
end

require("mason-null-ls").setup_handlers(setup_handlers)