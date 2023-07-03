local const = require("cfg.const")
local layout = require("cfg.const").ui.layout

require("mason").setup({
    install_root_dir = vim.fn.stdpath("config") .. "/mason",
    ui = {
        border = const.ui.border,
        width = layout.width,
        height = layout.height,
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})