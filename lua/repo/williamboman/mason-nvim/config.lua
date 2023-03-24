local const = require("cfg.const")

require("mason").setup({
    install_root_dir = vim.fn.expand('$HOME') .. "/.nvim/mason",
    ui = {
        border = const.ui.border,
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})