local lin_keymap = {
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

require 'nvim-tree'.setup {
    open_on_setup = true,
    open_on_setup_file = true,
    view = {
        width = 40,
        side = "left",
        signcolumn = "yes",
        mappings = {
            custom_only = false,
            list = lin_keymap,
        },
    },
    renderer = {
        highlight_git = true,
        indent_markers = {
            enable = true,
        },
        icons = {
            webdev_colors = true,
            git_placement = "signcolumn",
            glyphs = {
                default = "",
                symlink = "",
            },
        },
    },
    update_focused_file = {
        enable      = true,
        update_root = true,
    },
    diagnostics = {
        enable = false,
        show_on_dirs = false,
    },
    git = {
        enable = true,
        ignore = false,
    },
    modified = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
    },
}
