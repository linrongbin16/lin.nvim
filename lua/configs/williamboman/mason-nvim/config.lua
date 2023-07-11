local constants = require("builtin.utils.constants")

require("mason").setup({
    install_root_dir = vim.fn.stdpath("config") .. "/mason",
    ui = {
        border = constants.ui.border,
        width = constants.ui.layout.scale,
        height = constants.ui.layout.scale,
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})