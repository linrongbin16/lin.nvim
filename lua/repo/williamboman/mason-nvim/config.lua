local const = require("cfg.const")
local width_on_editor = require("cfg.ui").width_on_editor
local height_on_editor = require("cfg.ui").height_on_editor
local big_layout = require("cfg.const").ui.layout.big

require("mason").setup({
    install_root_dir = vim.fn.stdpath("config") .. "/mason",
    ui = {
        border = const.ui.border,
        width = width_on_editor(
            big_layout.width.pct,
            big_layout.width.min,
            big_layout.width.max
        ),
        height = height_on_editor(
            big_layout.height.pct,
            big_layout.height.min,
            big_layout.height.max
        ),
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})