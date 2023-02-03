local key_mappings = {
    -- navigation
    { key = "l", action = "edit" }, -- open folder or edit file
    { key = "h", action = "close_node" }, -- close folder

    -- diagnostics
    { key = "]d", action = "next_diag_item" }, -- next diagnostic item
    { key = "[d", action = "prev_diag_item" }, -- previous diagnostic item
}

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local constants = require("conf/constants")

require("nvim-tree").setup({
    -- open_on_setup = true, -- deprecated
    -- open_on_setup_file = true,
    view = {
        width = 40,
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
})

vim.api.nvim_create_augroup("nvim_tree_open_on_start_augroup", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
    group = "nvim_tree_open_on_start_augroup",
    callback = function(data)
        -- buffer is a [No Name]
        local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
        -- buffer is a directory
        local directory = vim.fn.isdirectory(data.file) == 1
        if not no_name and not directory then
            return
        end
        -- change to the directory
        if directory then
            vim.cmd.cd(data.file)
        end
        -- open the tree
        require("nvim-tree.api").tree.open()
    end,
})
