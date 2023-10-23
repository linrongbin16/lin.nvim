local neoconf = require("neoconf")

require("mason").setup({
    install_root_dir = vim.fn.stdpath("config") .. "/mason",
    ui = {
        border = neoconf.get("linopts.ui.floatwin.border"),
        width = neoconf.get("linopts.ui.floatwin.scale"),
        height = neoconf.get("linopts.ui.floatwin.scale"),
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})
