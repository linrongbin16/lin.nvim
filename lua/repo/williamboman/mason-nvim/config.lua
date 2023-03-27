local const = require("cfg.const")

require("mason").setup({
    install_root_dir = vim.fn.stdpath('config') .. "/.nvim/mason",
    ui = {
        border = const.ui.border,
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})