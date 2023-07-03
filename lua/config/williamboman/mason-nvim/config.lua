local constants = require("builtin.utils.constants")
local layout = require("builtin.utils.constants").ui.layout

require("mason").setup({
    install_root_dir = vim.fn.stdpath("config") .. "/mason",
    ui = {
        border = constants.ui.border,
        width = layout.width,
        height = layout.height,
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})