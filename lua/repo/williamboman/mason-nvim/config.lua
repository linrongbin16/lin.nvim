local const = require("cfg.const")

require("mason").setup({
    ui = {
        border = const.ui.border,
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})