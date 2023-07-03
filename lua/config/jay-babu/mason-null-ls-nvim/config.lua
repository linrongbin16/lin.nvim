local ensure_installed_ok, ensure_installed =
    pcall(require, "config.jay-babu.mason-null-ls-nvim.ensure_installed")

if not ensure_installed_ok then
    ensure_installed = {}
end

local setup_handlers_ok, setup_handlers =
    pcall(require, "config.jay-babu.mason-null-ls-nvim.setup_handlers")

if not setup_handlers_ok then
    setup_handlers = {}
end

require("mason-null-ls").setup({
    ensure_installed = ensure_installed,
    handlers = setup_handlers,
})