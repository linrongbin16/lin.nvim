local constants = require("builtin.utils.constants")

require("oil").setup({
    columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
    },
    delete_to_trash = vim.fn.executable("trash") > 0,
    trash_command = "trash",
    keymaps = {
        -- open in new tab/split/vsplit
        ["<C-w>v"] = "actions.select_vsplit",
        ["<C-s>"] = false,
        ["<C-w>s"] = "actions.select_split",
        ["<C-h>"] = false,
        ["<C-w>t"] = "actions.select_tab",
        ["<C-t>"] = false,

        -- preview, refresh
        ["<C-l>"] = "actions.preview",
        ["<C-p>"] = false,
        ["<C-r>"] = "actions.refresh",

        -- go to upper folder
        ["<BS>"] = "actions.parent",
        ["-"] = false,
    },
    view_options = {
        show_hidden = true,
    },
    float = {
        border = constants.ui.border,
    },
    preview = {
        border = constants.ui.border,
    },
    progress = {
        border = constants.ui.border,
    },
})