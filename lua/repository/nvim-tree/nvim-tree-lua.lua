local key_mappings = {
    -- navigation
    { key = "l", action = "edit" }, -- open folder or edit file
    { key = "h", action = "close_node" }, -- close folder

    -- copy/paste/cut
    { key = "X", action = "cut" },
    { key = "C", action = "copy" },
    { key = "V", action = "paste" },
}

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local constants = require('conf/constants')

require 'nvim-tree'.setup {
    open_on_setup = true,
    open_on_setup_file = true,
    view = {
        width = 40,
        side = "left",
        signcolumn = "yes",
        mappings = {
            custom_only = false,
            list = key_mappings,
        },
    },
    renderer = {
        highlight_git = true,
        indent_markers = {
            enable = true,
        },
        icons = {
            webdev_colors = true,
            git_placement = "after",
            modified_placement = "before",
            glyphs = {
                default = "",
            },
        },
    },
    update_focused_file = {
        enable = true,
        update_root = true,
    },
    diagnostics = {
        enable = true,
        icons = {
          hint = constants.lsp.diagnostics.signs["hint"],
          info = constants.lsp.diagnostics.signs["info"],
          warning = constants.lsp.diagnostics.signs["warning"],
          error = constants.lsp.diagnostics.signs["error"],
        },
    },
    git = {
        enable = true,
        ignore = false,
    },
    modified = {
        enable = true,
    },
}
