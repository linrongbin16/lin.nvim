-- Check if `cfg.lsp.mason-null-ls.ensure_installed` exist
local found_ensure_installed, ensure_installed =
    pcall(require, "user.mason-null-ls.ensure_installed")

if not found_ensure_installed then
    ensure_installed = {}
end

-- Check if `cfg.lsp.mason-null-ls.setup_handlers` exist
local found_setup_handlers, setup_handlers =
    pcall(require, "user.mason-null-ls.setup_handlers")

if not found_setup_handlers then
    setup_handlers = {}
end

require("mason-null-ls").setup({
    ensure_installed = ensure_installed,
    handlers = setup_handlers,
})