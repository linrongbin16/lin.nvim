local constants = require("builtin.utils.constants")

require("mason").setup({
    registries = {
        "github:nvim-java/mason-registry",
        "github:mason-org/mason-registry",
    },
    install_root_dir = vim.fn.stdpath("config") .. "/mason",
    ui = {
        border = constants.ui.border,
        width = constants.ui.layout.middle.scale,
        height = constants.ui.layout.middle.scale,
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})
