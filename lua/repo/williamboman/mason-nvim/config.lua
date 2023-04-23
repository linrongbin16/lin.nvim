local const = require("cfg.const")
local big_layout = require("cfg.const").ui.layout.big
local lspconfig = require("lspconfig")

require("mason").setup({
    install_root_dir = vim.fn.stdpath("config") .. "/mason",
    ui = {
        border = const.ui.border,
        width = big_layout.width,
        height = big_layout.height,
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})

-- Check if `user.lspconfig.setup_handlers` exist
local found_setup_handlers, setup_handlers =
    pcall(require, "user.lspconfig.setup_handlers")

if not found_setup_handlers then
    setup_handlers = {}
end

for name, config in pairs(setup_handlers) do
    lspconfig[name].setup(config)
end