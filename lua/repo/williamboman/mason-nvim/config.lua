local const = require("cfg.const")
local big_layout = require("cfg.const").ui.layout.big

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